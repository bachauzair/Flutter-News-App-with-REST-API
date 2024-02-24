import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newss/Categories%20Screen.dart';
import 'package:newss/News%20Detail%20Screen.dart';
import 'package:newss/View%20Model/News%20view%20Model.dart';

import 'NewsHeadlines.dart';
import 'View Model/CategoryNewsModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum FilterList {bbcNews, aryNews,  foxNews, alJazeera, bbcSports, abcNews}



class _HomePageState extends State<HomePage> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String sourceName = 'al-jazeera-english';

  FilterList? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
     appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoreisScreen()));
          },
          icon: Image.asset(
            'Assets/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert), // Use Icon directly without IconButton
            onSelected: (FilterList item) {
              String selectedSourceName;
              switch (item) {
                case FilterList.bbcNews:
                  selectedSourceName = 'bbc-news';
                  break;
                case FilterList.aryNews:
                  selectedSourceName = 'ary-news';
                  break;
                case FilterList.foxNews:
                  selectedSourceName = 'fox-news';
                  break;
                case FilterList.alJazeera:
                  selectedSourceName = 'al-jazeera-english';
                  break;
                case FilterList.abcNews:
                  selectedSourceName = 'abc-news';
                  break;
                case FilterList.bbcSports:
                  selectedSourceName = 'bbc-sport';
                  break;
                default:
                  throw Exception('Unhandled filter: $item');
              }
              setState(() {
                selectedMenu = item;
                sourceName = selectedSourceName;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text('ARY News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.foxNews,
                child: Text('Fox News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.alJazeera,
                child: Text('Al Jazeera News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.abcNews,
                child: Text('ABC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.bbcSports,
                child: Text('BBC SPORTS'),
              ),
            ],
          ),
        ],
      ),

      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsHeadlines>(
              future: newsViewModel.fetchNewsHeadlines(sourceName), // Corrected type
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  // Handle other states
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,

                      itemBuilder: (context, index){
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
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
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * .9,
                                  padding: EdgeInsets.symmetric(horizontal: height * .02),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,

                                      placeholder: (context, url) => Container(child: spinkit2),
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 3,

                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      width: width * 0.76,
                                      height: height * 0.20,// Adjust the width here
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].title.toString(),

                                            style: GoogleFonts.poppins(
                                              fontSize: 17, fontWeight: FontWeight.w700
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          Spacer(),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13, fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Text(format.format(dateTime),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12, fontWeight: FontWeight.w500
                                                  ),
                                                )

                                              ],

                                            ),

                                          )
                                        ],
                                      ),
                                    ),

                                  ),
                                ),


                              ],
                            ),
                          ),
                        );






                      });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoryNewsModel>(
              future: newsViewModel.fetchCategoriesNews('General'),
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
            shrinkWrap: true,
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
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,

);