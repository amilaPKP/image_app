import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperapp/Service/curated_photo_api.dart';
import 'package:wallpaperapp/full_screen_image.dart';

class CategoryImageDisplay extends StatefulWidget {
  String categoryName;
  CategoryImageDisplay({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryImageDisplay> createState() => _CategoryImageDisplayState();
}

class _CategoryImageDisplayState extends State<CategoryImageDisplay> {
  final photoapi =
      photoApi('xD96MUjzrcFjM3nIYLiXI9x70TTEvqUcU6iVDLaI3DNqXJXrjuC2trQk');
  List images = [];
  int page = 1;
  ScrollController _scrollController = ScrollController();
  bool _showLoadMoreButton = false;

  Future fetchCategoryPhotos() async {
    try {
      var photos = await photoapi.getCategoryPhotos(query: widget.categoryName);
      setState(() {
        images = photos['photos'];
      });
    } catch (e) {}
  }

  Future loadMorePhotos() async {
    try {
      setState(() {
        page = page + 1;
      });

      var morePhotos = await photoapi.loadMorePhotos(
          query: widget.categoryName, pageNumber: page);

      setState(() {
        images.addAll(morePhotos['photos']);
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    fetchCategoryPhotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _showLoadMoreButton = true;
        });
      } else {
        setState(() {
          _showLoadMoreButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Container(
            height: 50,
            width: 400,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.fromARGB(255, 118, 117, 117), // Border color
                width: 3, // Border width
              ),
              color: Color.fromARGB(255, 24, 23, 23),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 25),
                    child: Text(
                      widget.categoryName,
                      style: GoogleFonts.aBeeZee(
                        textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 226, 224, 224),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 27, 27, 27),
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          photo: images[index]['src']['portrait'].toString(),
                          photographerName: images[index]['photographer'],
                          visitPhotoUrl: images[index]['url'],
                          visitProfile: images[index]['photographer_url'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          Color.fromARGB(255, 48, 48, 48), // Placeholder color
                      image: DecorationImage(
                        image: NetworkImage(
                          images[index]['src']['portrait'].toString(),
                        ), // Replace with your image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            Visibility(
              visible: _showLoadMoreButton,
              child: Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      backgroundColor: Color.fromARGB(255, 169, 166, 166),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 63, 63, 63),
                          width: 2.5,
                        ),
                      ),
                    ),
                    onPressed: loadMorePhotos,
                    child: Text(
                      'Load More',
                      style: GoogleFonts.acme(
                        textStyle: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
