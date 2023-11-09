import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String firstName;
  final String email;
  final String image;
  final String phoneNumber;
  final String gender;
  final String birthday;
  final String city;
  final String zipcode;

  DetailsPage({required this.firstName, required this.email, required this.image, required this.phoneNumber, required this.gender, required this.birthday, required this.city, required this.zipcode });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top : 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(child: Image.network('https://picsum.photos/250?image=9'), width: 120, height: 120,),
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(image),
                radius: 70,
              ),
              SizedBox(height: 20),
              Text('Name: $firstName'),
              SizedBox(height: 15),
              Text('Zipcode: $zipcode'),
              SizedBox(height: 15),
              Text('Birthday: $birthday'),
              SizedBox(height: 15),
              Text('Gender: $gender'),
              SizedBox(height: 15),
              Text('City: $city'),
              SizedBox(height: 15),
              Text('Email: $email'),
              SizedBox(height: 15),
              Text('Phone Number: $phoneNumber'),
            ],
          ),
        ),
      ),
    );
  }
}