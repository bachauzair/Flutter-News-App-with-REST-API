import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newss/View%20Model/CategoryNewsModel.dart';

import 'HomePage.dart';
import 'News Detail Screen.dart';
import 'View Model/News view Model.dart';

class CategoreisScreen extends StatefulWidget {
  const CategoreisScreen({Key? key}) : super(key: key);

  @override
  State<CategoreisScreen> createState() => _CategoreisScreenState();
}

class _CategoreisScreenState extends State<CategoreisScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoriesName = 'General';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          categoriesName = categoriesList[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: categoriesName == categoriesList[index]
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(17)),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                categoriesList[index].toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<CategoryNewsModel>(
                future: newsViewModel.fetchCategoriesNews(categoriesName),
                builder: (BuildContext context,
                    AsyncSnapshot<CategoryNewsModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 40,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null ||
                      snapshot.data!.articles == null ||
                      snapshot.data!.articles!.isEmpty) {
                    return Center(
                      child: Text('No articles available'),
                    );
                  } else {
                    return ListView.builder(

                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());

                        return InkWell(
                          onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                  newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  newsTitle: snapshot.data!.articles![index].title.toString(),
                                  newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString()
                              )));

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(

                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),

                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: SpinKitCircle(
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error_outline,
                                            color: Colors.red),
                                    height: height * .18,
                                    width: width * .3,
                                  ),
                                ),

                                Expanded(
                                    child: Container(
                                      height: height * .18,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Column(
                                          children: [
                            Text(snapshot
                                .data!.articles![index].title
                                .toString(),

                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w700
                            ),
                            maxLines: 3,



                            ),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot
                                                    .data!.articles![index].source!.name
                                                    .toString(),

                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w600
                                                  ),
                            ),
                                                  Text(format.format(dateTime),

                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.w600
                                                    ),




                                                  ),




                                              ],
                                            )
                                          ],),
                                      ),
                                    )),

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
