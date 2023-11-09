import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test_project/openDetailsPage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PersonList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PersonList extends StatefulWidget {
  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  List<dynamic> persons = [];
  int page = 1;
  bool isLoading = false;
  bool noMoreData = false;
  int record = 10;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();

    // Add a listener to the scroll controller to check for reaching the end of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {

    if (isLoading || noMoreData) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://fakerapi.it/api/v1/persons?_quantity=15&_page=$page'),
    );

    if (response.statusCode == 200) {
      final newData = json.decode(response.body)['data'];

      if (newData.isNotEmpty) {
        setState(() {
          persons.addAll(newData);
          record = (page == 1 ?  10 : 20);
          page++;
          noMoreData = (page > 3 ? true : false);
        });

      } else {
        setState(() {
          noMoreData = true;
        });
      }

    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> refreshData() async {
    setState(() {
      page = 1;
      noMoreData = false;
      isLoading = false;
      persons.clear();
    });

    await fetchData();

  }


  void _openDetailsPage(String firstName, String email, String image, String phoneNumber, String gender, String birthday, String city, String zipcode ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(firstName: firstName, email: email, image: image, phoneNumber:phoneNumber, gender: gender, birthday: birthday, city:city, zipcode:zipcode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person List'),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: persons.length + (noMoreData ? 1 : 0),
          itemBuilder: (context, index) {
              if (index < persons.length) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),

                  child: ListTile(
                    // leading: Image.network('$persons[index]["image"]'),
                    leading:
                    // index == 1 ? CircleAvatar(
                    //   backgroundImage: CachedNetworkImageProvider('https://picsum.photos/250?image=9'),
                    // ) :
                    CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(persons[index]['image']),
                      ),
                    title: Text(persons[index]['firstname'] + ' ' +persons[index]['lastname'] ),
                    subtitle: Text('Email: ' + persons[index]['email']),
                    onTap: () => _openDetailsPage(
                        persons[index]['firstname'] != null ? persons[index]['firstname'] : 'NA',
                        persons[index]['email'] != null ? persons[index]['email'] : "NA",
                        persons[index]['image'] != null ? persons[index]['image'] : "NA",
                        persons[index]['phone'] != null ? persons[index]['phone'] : "NA",
                        persons[index]['gender'] != null ? persons[index]['gender'] : "NA",
                        persons[index]['birthday'] != null ? persons[index]['birthday'] : "NA",
                        persons[index]['city'] != null ? persons[index]['city'] : "NA",
                        persons[index]['zipcode'] != null ? persons[index]['zipcode'] : "NA",
                    ),
                  ),
                );
              } else if (index == persons.length && !noMoreData) {
                if (!isLoading) {
                  fetchData();
                }
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const Center(
                    child: Text('No more data.'),
                );
              }
          },
        ),
      ),
    );
  }
}

//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Web Load More Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PersonList(),
//     );
//   }
// }
//
// class PersonList extends StatefulWidget {
//   @override
//   _PersonListState createState() => _PersonListState();
// }
//
// class _PersonListState extends State<PersonList> {
//   List<dynamic> persons = [];
//   int page = 1;
//   bool isLoading = false;
//   bool noMoreData = false;
//
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//         fetchData();
//       }
//     });
//   }
//
//   Future<void> fetchData() async {
//     if (isLoading || noMoreData) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final response = await http.get(
//       Uri.parse('https://fakerapi.it/api/v1/persons?_quantity=10&_page=$page'),
//     );
//
//     if (response.statusCode == 200) {
//       final newData = json.decode(response.body)['data'];
//
//       if (newData.isNotEmpty) {
//         setState(() {
//           persons.addAll(newData);
//           page++;
//         });
//       } else {
//         setState(() {
//           noMoreData = true;
//         });
//       }
//     } else {
//       throw Exception('Failed to load data');
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Person List - Flutter Web'),
//       ),
//       body: Center(
//         child: Container(
//           width: 400,
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: persons.length + (noMoreData ? 0 : 1),
//             itemBuilder: (context, index) {
//               if (index == persons.length && !noMoreData) {
//                 if (!isLoading) {
//                   fetchData();
//                 }
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               } else {
//                 final person = persons[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 10),
//                   child: ListTile(
//                     title: Text(person['firstname']),
//                     subtitle: Text('Email: ' + person['email']),
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
