import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CollegeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> college;

  const CollegeDetailsPage({super.key, required this.college});

  @override
  _CollegeDetailsPageState createState() => _CollegeDetailsPageState();
}

class _CollegeDetailsPageState extends State<CollegeDetailsPage> {
  late bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarkStatus();
  }

  Future<void> _loadBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedColleges = prefs.getStringList('bookmarked_colleges') ?? [];

    setState(() {
      isBookmarked = bookmarkedColleges.contains(jsonEncode(widget.college));
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedColleges = prefs.getStringList('bookmarked_colleges') ?? [];

    setState(() {
      if (isBookmarked) {
        bookmarkedColleges.remove(jsonEncode(widget.college));
      } else {
        bookmarkedColleges.add(jsonEncode(widget.college));
      }
      isBookmarked = !isBookmarked;
    });

    await prefs.setStringList('bookmarked_colleges', bookmarkedColleges);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.college["college_name"] ?? "College Details"),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 Location: ${widget.college["city"]}, ${widget.college["state"]}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("🏛️ Type: ${widget.college["college_type"]}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("📚 Courses Offered:",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.college["courses"] ?? "Not specified", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("💰 Avg Fees: ₹${widget.college["average_fees"]}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("More details coming soon...", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
