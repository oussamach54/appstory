import 'package:flutter/material.dart';
import 'package:my_app/services/firestore_service.dart';
import 'package:my_app/Screens/story_selection_page.dart';
import 'package:my_app/Screens/historique_page.dart';
import 'package:my_app/Screens/home.page.dart'; // Import your HomePage

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> stories = [];
  List<Map<String, dynamic>> filteredStories = [];
  bool isLoading = true;
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    final FirestoreService firestoreService = FirestoreService();
    final fetchedStories = await firestoreService.fetchStories();

    if (mounted) {
      setState(() {
        stories = fetchedStories;
        filteredStories = fetchedStories;
        isLoading = false;
      });
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredStories = stories.where((story) {
        final storyCategory = story["category"] ?? "Unknown";
        return category == "All" || storyCategory == category;
      }).toList();
    });
  }

  Future<bool> _onWillPop() async {
    // Navigate back to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    return false; // Prevent default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        appBar: AppBar(
          backgroundColor: Colors.indigo[800],
          elevation: 0,
          title: const Text(
            "Dashboard",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pushNamed(context, '/camera');
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Historique'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoriquePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Stories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            onChanged: (value) {
                              if (value != null) {
                                _filterByCategory(value);
                              }
                            },
                            underline: Container(),
                            items: ["All", "Adventure", "Fantasy", "Mystery"]
                                .map<DropdownMenuItem<String>>(
                                  (String category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filteredStories.isEmpty
                          ? const Center(
                              child: Text(
                                "No stories available.",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: filteredStories.length,
                              itemBuilder: (context, index) {
                                final story = filteredStories[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StorySelectionPage(
                                          title: story["title"] ?? "No Title",
                                          content:
                                              story["content"] ?? "No Content",
                                          imageUrl: story["imageUrl"] ?? "",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            ),
                                            child: Image.network(
                                              story["imageUrl"] ?? "",
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                  stackTrace) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            story["title"] ?? "No Title",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    ));
  }
}
