import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newcollegefinder/features/auth/presentation/pages/chatbot_page.dart';
import 'package:newcollegefinder/features/auth/presentation/pages/login_page.dart';
import 'package:newcollegefinder/features/dashboard/presentation/pages/college_details_page.dart';
import 'package:newcollegefinder/features/dashboard/presentation/pages/profile_page.dart';
import 'package:newcollegefinder/features/dashboard/presentation/pages/scholarship_page.dart';
import 'package:newcollegefinder/features/dashboard/presentation/pages/search_results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:newcollegefinder/features/dashboard/presentation/pages/college_details_page.dart';
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class ApplicationsTab extends StatefulWidget {
  const ApplicationsTab({super.key});

  @override
  State<ApplicationsTab> createState() => _ApplicationsTabState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _pages = [
    _HomeTab(),
    ApplicationsTab(),
    ScholarshipPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to log out
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      // Navigate back to login after logout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void _onSearch() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduZapp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Logout button
            onPressed: _logout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Colleges...',
                // prefixIcon: const Icon(Icons.search),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(25.0),
                //   borderSide: BorderSide.none,
                // ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(query: _searchController.text.trim()),
                      ),
                    );
                  },
                ),
              ),
              onSubmitted: (value) => _onSearch(),
            ),
          ),
        ),
      ),
      
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color of selected item
        unselectedItemColor: Colors.black54, // Color of unselected items
        backgroundColor: Colors.white, // Background color
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Scholarship icon
            label: 'Scholarships',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotPage()),
          );
        },
        child: const Icon(Icons.chat),
        tooltip: 'Open Chatbot',
      ),
    );
  }
}
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('colleges').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No colleges found."));
        }

        var colleges = snapshot.data!.docs;

        return ListView.builder(
          itemCount: colleges.length,
          itemBuilder: (context, index) {
            var college = colleges[index].data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(college["college_name"] ?? "Unknown College"),
                subtitle: Text("${college["city"]}, ${college["state"]}"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // Navigate to CollegeDetailsPage with details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollegeDetailsPage(college: college),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _ApplicationsTabState extends State<ApplicationsTab> {
  List<Map<String, dynamic>> bookmarkedColleges = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedColleges();
  }

  Future<void> _loadBookmarkedColleges() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedColleges = prefs.getStringList('bookmarked_colleges') ?? [];

    setState(() {
      bookmarkedColleges = storedColleges
          .map((e) => jsonDecode(e) as Map<String, dynamic>) // Explicit cast
          .toList();
    });
  }

  Future<void> _removeBookmark(Map<String, dynamic> college) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedColleges = prefs.getStringList('bookmarked_colleges') ?? [];

    storedColleges.remove(jsonEncode(college));
    await prefs.setStringList('bookmarked_colleges', storedColleges);

    _loadBookmarkedColleges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarked Colleges")),
      body: bookmarkedColleges.isEmpty
          ? const Center(child: Text("No bookmarked colleges."))
          : ListView.builder(
        itemCount: bookmarkedColleges.length,
        itemBuilder: (context, index) {
          final college = bookmarkedColleges[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(college["college_name"], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${college["city"]}, ${college["state"]}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeBookmark(college),
              ),
            ),
          );
        },
      ),
    );
  }
}
