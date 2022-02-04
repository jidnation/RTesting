// import 'package:equatable/equatable.dart';

// class User extends Equatable {
//   final String id;
//   final String name;
//   final String email;
//   final String phoneNumber;
//   final String address;
//   final String city;
//   final String state;
//   final String zip;
//   final String country;
//   final String image;
//   final String role;
//   final String status;
//   final String createdAt;
//   final String updatedAt;

//   const User(
//       {this.id,
//       this.name,
//       this.email,
//       this.phoneNumber,
//       this.address,
//       this.city,
//       this.state,
//       this.zip,
//       this.country,
//       this.image,
//       this.role,
//       this.status,
//       this.createdAt,
//       this.updatedAt});

//   @override
//   List<Object> get props => [
//         id,
//         name,
//         email,
//         phoneNumber,
//         address,
//         city,
//         state,
//         zip,
//         country,
//         image,
//         role,
//         status,
//         createdAt,
//         updatedAt
//       ];

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       phoneNumber: json['phoneNumber'],
//       address: json['address'],
//       city: json['city'],
//       state: json['state'],
//       zip: json['zip'],
//       country: json['country'],
//       image: json['image'],
//       role: json['role'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['name'] = name;
//     data['email'] = email;