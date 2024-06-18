import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:course_template/models/sublesson.dart';
import 'package:course_template/models/discussion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubLessonContentScreen extends StatefulWidget {
  final SubLesson subLesson;

  const SubLessonContentScreen({Key? key, required this.subLesson})
      : super(key: key);

  @override
  _SubLessonContentScreenState createState() => _SubLessonContentScreenState();
}

class _SubLessonContentScreenState extends State<SubLessonContentScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Discussion> discussions = [];
  Map<int, List<Discussion>> discussionReplies = {};
  int? userId;

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
    });
  }

  Future<void> _loadDiscussions() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/api/discussions/sublesson?sLessonId=${widget.subLesson.id}'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());

      final allDiscussions = jsonResponse
          .where((element) => element is Map<String, dynamic>)
          .map((json) => Discussion.fromJson(json))
          .toList();

      // Separate top-level discussions from replies
      final rootDiscussions = <Discussion>[];
      final replyMapping = <int, List<Discussion>>{};

      for (var discussion in allDiscussions) {
        if (discussion.parentId == null) {
          rootDiscussions.add(discussion);
        } else {
          replyMapping
              .putIfAbsent(discussion.parentId!, () => [])
              .add(discussion);
        }
      }

      setState(() {
        discussions = rootDiscussions;
        discussionReplies = replyMapping;
      });
    }
  }

  Future<void> _submitComment({int? parentId}) async {
    final comment = _commentController.text;
    if (comment.isNotEmpty && userId != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/discussions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'subLessonId': widget.subLesson.id,
          'userId': userId,
          'parentId': parentId,
          'content': comment,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _commentController.clear();
        _loadDiscussions();
      }
    }
  }

  Future<void> _editComment(int discussionId, String content) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/api/discussions/$discussionId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': content,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      _loadDiscussions();
    }
  }

  Future<void> _deleteComment(int discussionId) async {
    final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/api/discussions/$discussionId'));

    if (response.statusCode == 204) {
      _loadDiscussions();
    }
  }

  Widget _buildCommentTile(Discussion discussion, {bool isReply = false}) {
    final children = discussionReplies[discussion.id] ?? [];

    return Padding(
      padding: EdgeInsets.only(left: isReply ? 16.0 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (discussion.parentId != null)
            Text(
              '${discussion.user.fullName} to ${discussions.firstWhereOrNull((d) => d.id == discussion.parentId)?.user.fullName ?? 'Unknown'}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (discussion.parentId == null)
            Text(
              discussion.user.fullName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          Divider(),
          Text(discussion.content),
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
                    // Implement edit functionality
                    _editComment(discussion.id, 'New content'); // Example usage
                  },
                ),
              if (userId == discussion.user.id)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Implement delete functionality
                    _deleteComment(discussion.id);
                  },
                ),
              IconButton(
                icon: Icon(Icons.reply),
                onPressed: () {
                  // Implement reply functionality
                  _submitComment(parentId: discussion.id);
                },
              ),
            ],
          ),
          ...children
              .map((child) => _buildCommentTile(child, isReply: true))
              .toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subLesson.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(
              data: widget.subLesson.content,
            ),
            const SizedBox(height: 16),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...discussions
                .map((discussion) => _buildCommentTile(discussion))
                .toList(),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add a comment',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _submitComment(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
