import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:course_template/models/sublesson.dart';
import 'package:course_template/models/discussion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:course_template/utils/PublicBaseURL.dart'; // Import the base URL

class SubLessonContentScreen extends StatefulWidget {
  final SubLesson subLesson;
  final String instructorName;

  const SubLessonContentScreen(
      {Key? key, required this.subLesson, required this.instructorName})
      : super(key: key);

  @override
  _SubLessonContentScreenState createState() => _SubLessonContentScreenState();
}

class _SubLessonContentScreenState extends State<SubLessonContentScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Discussion> discussions = [];
  int? userId;
  String? userName;
  int? replyingToId;
  String? replyingToName;
  int currentPage = 1;
  static const int commentsPerPage = 5;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadDiscussions();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      userName = prefs.getString('userFullname');
    });
  }

  Future<void> _loadDiscussions() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/api/discussions/sublesson?sLessonId=${widget.subLesson.id}')); // Use baseUrl
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());

      final allDiscussions = jsonResponse
          .where((element) => element is Map<String, dynamic>)
          .map((json) => Discussion.fromJson(json))
          .toList();

      setState(() {
        discussions = allDiscussions;
      });
    }
  }

  Future<void> _submitComment() async {
    final comment = _commentController.text;
    if (comment.isNotEmpty && userId != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/discussions'), // Use baseUrl
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'subLessonId': widget.subLesson.id,
          'userId': userId,
          'parentId': replyingToId,
          'content': comment,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _commentController.clear();
        setState(() {
          replyingToId = null;
          replyingToName = null;
        });
        _loadDiscussions();
      } else {
        log('Failed to post comment');
      }
    }
  }

  Future<void> _editComment(Discussion discussion) async {
    final response = await http.put(
      Uri.parse(
          '$baseUrl/api/discussions/${discussion.id}?content=${Uri.encodeComponent(discussion.editedContent!)}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        discussion.isEditing = false;
        discussion.content = discussion.editedContent!;
        discussion.editedAt = DateTime.now();
      });
      _loadDiscussions();
    } else {
      log('Failed to edit comment: ${response.body}');
    }
  }

  Future<void> _deleteComment(int discussionId) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/api/discussions/$discussionId')); // Use baseUrl

    if (response.statusCode == 204) {
      _loadDiscussions();
    } else {
      log('Failed to delete comment');
    }
  }

  void _setReplyingTo(Discussion discussion) {
    setState(() {
      replyingToId = discussion.id;
      replyingToName = discussion.user.fullName;
    });
  }

  void _cancelReply() {
    setState(() {
      replyingToId = null;
      replyingToName = null;
    });
  }

  Widget _buildCommentTile(Discussion discussion, {int depth = 0}) {
    bool isFirstChild = depth == 1;

    return Padding(
      padding: EdgeInsets.only(left: isFirstChild ? 16.0 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                discussion.user.fullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (discussion.user.fullName == widget.instructorName)
                Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'INSTRUCTOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          Divider(),
          if (discussion.isEditing)
            TextField(
              controller: TextEditingController(
                  text: discussion.editedContent ?? discussion.content),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    discussion.editedContent = value;
                  });
                });
              },
              decoration: InputDecoration(
                hintText: 'Edit Comment',
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: discussion.editedContent?.isNotEmpty == true
                      ? () {
                          _editComment(discussion);
                        }
                      : null,
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(child: Text(discussion.content)),
                if (discussion.editedAt != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      '(edited)',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
              ],
            ),
          SizedBox(height: 8),
          Text(
            discussion.createdAt.toString(),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Row(
            children: [
              if (userId == discussion.user.id)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      discussion.isEditing = true;
                    });
                  },
                ),
              if (userId == discussion.user.id)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteComment(discussion.id);
                  },
                ),
              if (userId != discussion.user.id)
                IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: () {
                    _setReplyingTo(discussion);
                  },
                ),
            ],
          ),
          ...discussion.children
              .map((child) => _buildCommentTile(child, depth: depth + 1))
              .toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginatedDiscussions = discussions
        .skip((currentPage - 1) * commentsPerPage)
        .take(commentsPerPage)
        .toList();
    final totalPages = (discussions.length / commentsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subLesson.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(data: widget.subLesson.content),
            const SizedBox(height: 16),
            const Text('Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add a comment',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitComment,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (replyingToName != null)
              Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Replying to $replyingToName'),
                    IconButton(
                      icon: Icon(Icons.cancel, size: 16),
                      onPressed: _cancelReply,
                    ),
                  ],
                ),
              ),
            ...paginatedDiscussions
                .map((discussion) => _buildCommentTile(discussion))
                .toList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage++)
                      : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
