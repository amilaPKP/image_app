import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenImage extends StatelessWidget {
  final String photo;
  final String visitPhotoUrl;
  final String visitProfile;
  final String photographerName;
  const FullScreenImage({
    Key? key,
    required this.photo,
    required this.visitPhotoUrl,
    required this.visitProfile,
    required this.photographerName,
  }) : super(key: key);

  // void _launchURL({required String url}) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.network(
            photo,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              height: 155,
              width: 365,
              decoration: BoxDecoration(
                color: Color.fromRGBO(38, 32, 63, 0.808),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 182, 181, 181),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 90,
                        width: 6,
                        color: Color.fromRGBO(211, 149, 5, 1),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PHOTO BY',
                              style: GoogleFonts.acme(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 222, 226, 224),
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                          Text(
                            photographerName,
                            style: GoogleFonts.aBeeZee(
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 162, 164, 163),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  backgroundColor:
                                      Color.fromARGB(106, 169, 166, 166),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 250, 249, 249),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                onPressed: () => _launchURL(visitProfile),
                                child: Text(
                                  'Visit Profile',
                                  style: GoogleFonts.acme(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 243, 241, 241),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  backgroundColor:
                                      Color.fromARGB(106, 169, 166, 166),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 254, 254, 254),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                onPressed: () => _launchURL(visitPhotoUrl),
                                child: Text(
                                  'Visit Photo',
                                  style: GoogleFonts.acme(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 253, 251, 251),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Powered by Pexels.',
                      style: GoogleFonts.acme(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(211, 149, 5, 1),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
