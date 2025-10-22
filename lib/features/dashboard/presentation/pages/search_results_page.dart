import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'college_details_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;

  // Filters
  String? selectedType;
  String? selectedLocation;
  int? maxFees;
  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    _fetchAllColleges(); // Fetch all colleges initially
  }

  void _fetchAllColleges() async {
    setState(() => _isLoading = true);
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('colleges')
          .orderBy('college_name')
          .get();

      List<Map<String, dynamic>> colleges = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        _searchResults = colleges;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching colleges: $e");
      setState(() => _isLoading = false);
    }
  }

  void _fetchSearchResults(String keyword) async {
    if (keyword.isEmpty) {
      _fetchAllColleges(); // Show all colleges when search bar is empty
      return;
    }

    setState(() => _isLoading = true);

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('colleges')
          .orderBy('college_name')
          .get();

      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> suggestions = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String collegeName = data['college_name']?.toLowerCase() ?? '';

        if (collegeName.contains(keyword.toLowerCase())) {
          results.add(data);
        }

        if (collegeName.startsWith(keyword.toLowerCase())) {
          suggestions.add(data);
        }
      }

      setState(() {
        _searchResults = _applyFilters(results);
        _suggestions = suggestions.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching search results: $e");
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> results) {
    return results.where((college) {
      bool matchesType = selectedType == null || college['college_type'] == selectedType;
      bool matchesLocation = selectedLocation == null || college['city'] == selectedLocation;
      bool matchesFees = maxFees == null || (college['average_fees'] != null && college['average_fees'] <= maxFees!);
      bool matchesCourse = selectedCourse == null || (college['courses'] != null && college['courses'].contains(selectedCourse));

      return matchesType && matchesLocation && matchesFees && matchesCourse;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      selectedType = null;
      selectedLocation = null;
      maxFees = null;
      selectedCourse = null;
      _fetchAllColleges();
    });
  }

  void _showFiltersDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Filters", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: ["Public", "Private", "Autonomous"]
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => setModalState(() => selectedType = value),
                    decoration: const InputDecoration(labelText: "College Type"),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    items: ["Agaskhind", "Ahmednagar", "Ahmedpur", "Akola", "Akurdi", "Almala", "Alore", "Ambajogai", "Ambav", "Amravati", "Angangaon Bari", "Anjaneri", "Arvi", "Ashta", "Ashti", "Aurangabad", "Awasari Khurd", "Babhulgaon", "Badlapur", "Badnera", "Balapur", "Balharshah", "Bambhori Pr. Chandsar", "Baramati", "Barshi", "Beed", "Belhe", "Bhoyar", "Bhusawal", "Boripardhi", "Bota", "Buldana", "Chalisgaon", "Chandrapur", "Chas", "Chikhli", "Chinchewadi", "Chincholi", "Chiplun", "Chopda", "Dahegaon", "Dattapur Dhamangaon", "Dhanore", "Dhule", "Digras", "Dombivli", "Dondaicha", "Dongargaon", "Dorli", "Dumbarwadi", "Ekatmata Nagar Gramin", "Faizpur", "Gadhinglaj", "Gajawadi", "Ghoturli", "Gokul Shirgaon", "Gondia", "Harangul Bk.", "Harkul Bk.", "Hingoli", "Hipparge", "Ichalkaranji", "Induri", "Jalgaon", "Jalna", "Jangalewadi", "Jaysingpur", "Kadachiwadi", "Kagal", "Kamptee", "Karad", "Karav", "Kathora", "Kegaon", "Khambale Bhalvani", "Khamshet 2", "Khapari", "Khed Bhalawani", "Khopi", "Khupsarwadi", "Kolhapur", "Kondharki", "Kondhavli", "Kopargaon", "Koregaon Bhima", "Kumbhivali", "Latur", "Lavale", "Lonavala", "Lonere", "Maan", "Mahiravni", "Mahurzari", "Malegaon", "Malkapur", "Mandaviamba", "Mhasala", "Miraj", "Mohgaon", "Mokarwadi", "Mumbai", "Nagaon", "Nagpur", "Nande", "Nanded", "Nashik", "Navi Mumbai", "Neral", "Nilanga", "Osmanabad", "Pal", "Palghar", "Pandharpur", "Paniv", "Panvel", "Parbhani", "Pardari", "Parli", "Parsoda", "Patgaon", "Phulenagar", "Pimpri-Chinchwad", "Poman", "Posheri", "Pune", "Pusad", "Raigad", "Rasayani", "Ratnagiri", "Sadale", "Sangamner", "Sangli", "Sarola Baddi", "Satara", "Satnavari", "Savalade", "Sawargaon", "Sawarna", "Sevagram", "Shahada", "Shahapur", "Shegaon", "Shelu", "Shenit", "Shinde Wasti", "Shindevadi", "Shirala", "Shirol", "Shirpur", "Shirur", "Sindhudurg", "Sinnar", "Sirul", "Solapur", "Sudumbre", "Tala", "Talegaon Dabhade", "Thakurki", "Thane", "Tuljapur", "Untavad", "Uran Islampur", "Uti", "Vadgaon Kasba", "Vangali", "Vasai", "Velaneshwar", "Vhirgaon", "Vichumbe", "Vilad", "Virar", "Vishnupuri", "Vita", "Wardha", "Washim", "Yavatmal", "Yelgaon", "Yewalewadi"]
                        .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                        .toList(),
                    onChanged: (value) => setModalState(() => selectedLocation = value),
                    decoration: const InputDecoration(labelText: "Location"),
                  ),

                  const SizedBox(height: 10),

                  Slider(
                    value: maxFees?.toDouble() ?? 1000000,
                    min: 50000,
                    max: 1000000,
                    divisions: 10,
                    label: maxFees?.toString() ?? "Any",
                    onChanged: (value) => setModalState(() => maxFees = value.toInt()),
                  ),
                  const Text("Max Fees (₹)"),

                  const SizedBox(height: 10),

                  TextField(
                    decoration: const InputDecoration(labelText: "Course"),
                    onChanged: (value) => setModalState(() => selectedCourse = value),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _clearFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text("Clear Filters"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _searchResults = _applyFilters(_searchResults));
                          Navigator.pop(context);
                        },
                        child: const Text("Apply Filters"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Colleges")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for colleges...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchAllColleges();
                  },
                )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _fetchSearchResults,
            ),

            const SizedBox(height: 10),

            if (_suggestions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final college = _suggestions[index];
                  return ListTile(
                    title: Text(college["college_name"]),
                    onTap: () {
                      _searchController.text = college["college_name"];
                      _fetchSearchResults(college["college_name"]);
                    },
                  );
                },
              ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _showFiltersDialog,
              icon: const Icon(Icons.filter_list),
              label: const Text("Filters"),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                  ? const Center(child: Text("No colleges found"))
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final college = _searchResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(college["college_name"]),
                      subtitle: Text("${college["city"]}, ${college["state"]}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CollegeDetailsPage(college: college)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
