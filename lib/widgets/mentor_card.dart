import 'package:flutter/material.dart';

class MentorCard extends StatelessWidget {
  final String name;
  final String title;
  final String image;
  final VoidCallback onTap;

  const MentorCard({
    super.key,
    required this.name,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 30,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}