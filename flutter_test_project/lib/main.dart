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
  int maxPages = 3;

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
          noMoreData = (page > maxPages ? true : false);
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
      body: kIsWeb ?
          ListView.builder(
            itemCount: persons.length + 1,
            itemBuilder: (context, index) {
              if (index < persons.length) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
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
              } else if(index == persons.length && !noMoreData) {
                    return
                      GestureDetector(
                        onTap: () {
                          fetchData();
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.center,
                          child: const Text(
                            'Load More',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      );
              } else {
                return const Center(
                  child: Text('No more data.'),
                );
              }
            },
          )
          : RefreshIndicator(
            onRefresh: refreshData,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: persons.length + (noMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                  if (index < persons.length) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
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