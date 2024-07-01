import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperapp/Service/curated_photo_api.dart';
import 'package:wallpaperapp/category_image_display.dart';
import 'package:wallpaperapp/full_screen_image.dart';
import 'package:wallpaperapp/search_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final photoapi =
      photoApi('xD96MUjzrcFjM3nIYLiXI9x70TTEvqUcU6iVDLaI3DNqXJXrjuC2trQk');
  PageController _pageController = PageController(viewportFraction: 0.75);
  List images = [];
  final TextEditingController _searchcontroller = TextEditingController();

  Future fetchCuratedPhotos() async {
    try {
      var photos = await photoapi.getPhotos();
      setState(() {
        images = photos['photos'];
      });
    } catch (e) {}
  }

  final List<String> categories = [
    'Abstract',
    'Nature',
    'Cars',
    'Fashion',
    'Food',
  ];

  String getCategoryBackground(String? category) {
    if (category == null) return 'assets/stone1.jpg';

    switch (category) {
      case 'Abstract':
        return 'assets/stone1.jpg';
      case 'Nature':
        return 'assets/nature.jpg';
      case 'Cars':
        return 'assets/cars.jpg';
      case 'Fashion':
        return 'assets/fashion.jpeg';
      case 'Food':
        return 'assets/food.jpg';
      default:
        return 'assets/food.jpg';
    }
  }

  double _currentPage = 0.0;

  bool _showLoadMoreButton = false;

  @override
  void initState() {
    super.initState();
    fetchCuratedPhotos();
    _pageController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _currentPage = _pageController.page ?? 0.0;
      _showLoadMoreButton = _currentPage >= images.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'FlicksArt',
              style: GoogleFonts.aBeeZee(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 226, 224, 224),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('assets/dealtsoul-logo.jpg'),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 27, 27, 27),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 125,
            ),
            Center(
              child: Container(
                width: 370,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10), // Add some spacing
                    InkWell(
                      child: const Icon(Icons.search),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchImage(
                              searchName: _searchcontroller.text,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10), // Add some spacing
                    Expanded(
                      child: TextField(
                        controller: _searchcontroller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                      height: 150,
                      width: 190,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 245, 243, 243),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryImageDisplay(
                                    categoryName: categories[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Image.asset(
                                getCategoryBackground(categories[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: Text(
                              categories[index],
                              style: GoogleFonts.aBeeZee(
                                textStyle: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 226, 224, 224),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 500,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  double scaleFactor =
                      (1.0 - (_currentPage - index).abs() * 0.2)
                          .clamp(0.3, 1.0);
                  return Center(
                    child: Transform.scale(
                      scale: scaleFactor,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 24, 24, 24),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 9, 9, 9),
                              width: 0.2,
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                    photo: images[index]['src']['portrait']
                                        .toString(),
                                    photographerName: images[index]
                                        ['photographer'],
                                    visitPhotoUrl: images[index]['url'],
                                    visitProfile: images[index]
                                        ['photographer_url'],
                                  ),
                                ),
                              );
                            },
                            child: images[index]['src']['portrait'] != null
                                ? Image.network(
                                    images[index]['src']['portrait'].toString(),
                                    fit: BoxFit.fitHeight,
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.black),
                          )),
                    ),
                  );
                },
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index.toDouble();
                  });
                },
              ),
            ),
            if (_showLoadMoreButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    print('Load more...');
                  },
                  child: Text('Load more...'),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
