import 'package:boba_buddy/Database/database.dart';
import 'package:boba_buddy/Screens/store_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String searchTerm;

  const SearchPage({Key? key, required this.searchTerm}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    Database db = Database();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Search Results",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Josefin Sans",
              fontWeight: FontWeight.w600,
              fontSize: 22),
        ), // You can add title here
        backgroundColor: Colors.white, foregroundColor: Colors.black,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        child: Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: FutureBuilder(
                future: db.itemSearch(widget.searchTerm),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data.length == 0) {
                    return Center(
                        child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Text(
                          'No drinks found',
                          style: TextStyle(
                              fontFamily: "Josefin Sans",
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Try Again',
                            style: TextStyle(
                                fontFamily: "Josefin Sans",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            minimumSize: const Size(100, 40),
                            primary: const Color.fromRGBO(86, 99, 255, 1),
                          ))
                    ]));
                  } else {
                    print("___________");
                    print(snapshot.data);
                    return Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {

                              return singleShop(
                                  context: context,
                                  imageSrc:
                                      'https://d1ralsognjng37.cloudfront.net/3586a06b-55c6-4370-a9b9-fe34ef34ad61.jpeg',
                                  //todo need image src implemented in entity classes
                                  title: snapshot.data[index]["store"]
                                          ["name"] ??
                                      "",
                                  address: snapshot.data[index]["store"]
                                          ["location"] ??
                                      "",
                                  storeId: snapshot.data[index]["store"]['id'],
                                  itemId: snapshot.data[index]["id"]);
                            }));
                  }
                })

            //         ListView.builder(
            //         itemCount:testData.length, //todo set a limit for amount of popular shops to be displayed on homepage
            //         shrinkWrap: true,scrollDirection: Axis.horizontal,itemBuilder: (context, index){
            //     return singleShop(
            //               context: context,
            //               imageSrc: 'https://d1ralsognjng37.cloudfront.net/3586a06b-55c6-4370-a9b9-fe34ef34ad61.jpeg', //todo mock data
            //               title: testData.elementAt(index).elementAt(0) ?? "",
            //               address: testData.elementAt(index).elementAt(1) ?? ""
            //             );
            // })
            ),
      ),
    );

    // return Scaffold(
    //   body: Stack(
    //       children: [Container(
    //         child: ListView.builder(
    //             padding: const EdgeInsets.only(top: 100),
    //             itemCount:30, //TODO: pull length from api call
    //             shrinkWrap: true,scrollDirection: Axis.vertical,itemBuilder: (context, index){
    //
    //           return singleShop(
    //               // price: 12.99,
    //               // itemName: "Some Bubble Tea",
    //
    //
    //               imageSrc: "https://chatime.com/wp-content/uploads/2020/10/Brown-Sugar-Pearls-with-Milk-Tea.png",
    //
    //               address: "some address", title: 'title', context: context, ID: '9e123115-9d23-4244-96f2-5cfca4ff6d6d'
    //
    //           );
    //         }
    //
    //         ),
    //       ),
    //
    //
    //         Positioned(
    //           top: 0.0,
    //           left: 0.0,
    //           right: 0.0,
    //           child: AppBar(
    //             centerTitle: true,
    //             title: const Text('Store Results',style: TextStyle(color: Colors.black,
    //                 fontFamily: "Josefin Sans", fontWeight: FontWeight.bold, fontSize: 22
    //             ),),// You can add title here
    //             leading: IconButton(
    //               icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
    //               onPressed: () => Navigator.of(context).pop(),
    //             ),
    //             backgroundColor: Colors.white.withOpacity(1), //You can make this transparent
    //             elevation: 0.0, //No shadow
    //           ),),
    //
    //       ]
    //
    //
    //   ),
    // );
  }
}

Widget singleShop(
    {required String imageSrc,
    required String title,
    required String address,
    required context,
    required String storeId,
    required String itemId}) {
  const double WIDGETWIDTH = 325;
  const double WIDGETHEIGHT = 220;

  return InkWell(
    onTap: () {
      print("Navigate to ${title} shop page");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StorePage(
                    storeName: title,
                    imageSrc: imageSrc,
                    address: address,
                    storeId: storeId,
                    itemId: itemId,
                  )));
    },
    child: Container(
      width: WIDGETWIDTH,
      height: WIDGETHEIGHT,
      margin: const EdgeInsets.only(bottom: 20, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        //borderRadius: BorderRadius.all(const Radius.circular(8)),
        child: Stack(
          children: <Widget>[
            SizedBox(
                width: WIDGETWIDTH + 45,
                height: 160,
                child: Image.network(imageSrc,
                    width: WIDGETWIDTH,
                    height: 100,
                    fit: BoxFit.fitWidth, errorBuilder: (BuildContext context,
                        Object exception, StackTrace? stackTrace) {
                  // Appropriate logging or analytics, e.g.
                  // myAnalytics.recordError(
                  //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                  //   exception,
                  //   stackTrace,
                  // );
                  return const Image(
                      //fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/default-store.png"));
                })),
            Positioned(
              bottom: -15,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: WIDGETWIDTH,
                  height: 110,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        title,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontFamily: "Josefin Sans",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        // style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                        //     fontWeight: 600, color: Colors.white, letterSpacing: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -45,
              left: -12,
              child: SizedBox(
                width: WIDGETWIDTH,
                height: 120,
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 23),
                      child: Text(
                        address,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                        // style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                        //     fontWeight: 600, color: Colors.white, letterSpacing: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Widget singleItem({required String imageSrc, required String itemName, required double price}){
//   return Container(
//     margin: const EdgeInsets.only(bottom:30, right: 30, left: 30),
//     height: 125,
//     //width: 20,
//     color: Colors.white,
//
//     child: Stack(
//         children: [Row(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(right: 10),
//               height: 125,
//               width: 100,
//               child: Image.network(imageSrc, fit: BoxFit.fitWidth,),
//             ),
//             Align(
//                 alignment: Alignment.topCenter,
//                 child: Padding(
//                     padding: EdgeInsets.only(top: 15),
//                     child: Column(
//
//                         children: [Text(itemName, style:
//                         TextStyle(fontSize: 22,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: "Josefin Sans"
//                         ),),
//                           Padding(
//                               padding: EdgeInsets.only(right: 135),
//                               child: Text('\$6.99',
//                                 style: TextStyle(
//                                     color: Colors.grey.shade500,
//                                     fontWeight: FontWeight.bold),
//                               ))
//
//                         ]
//                     )
//                 )
//             )
//
//
//           ],
//
//         ),
//
//           Positioned(right: 40, top: 70,
//             child: ElevatedButton(
//               onPressed: () {
//
//               },
//               child: Text(
//                 "View",
//                 style: TextStyle(
//                     fontFamily: "Josefin Sans",
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15),
//               ),
//               style: ElevatedButton.styleFrom(
//                 shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8))),
//                 minimumSize: const Size(150, 45),
//                 primary: const Color.fromRGBO(86, 99, 255, 1),
//               ),
//             ),
//           ),
//
//         ]
//     ),
//
//   );
// }
