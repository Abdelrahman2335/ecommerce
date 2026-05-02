// import 'dart:developer';
//
// import 'package:ecommerce/domain/repositories/unsplash_repository.dart';
// import 'package:flutter/material.dart';
//
// class UnsplashViewModel extends ChangeNotifier {
//   final UnsplashRepository unsplashRepository;
//   List? url;
//
//   UnsplashViewModel(this.unsplashRepository) {
//     Future.microtask(() => getPhotos());
//   }
//
//   List? get getUrl => url;
//
//   getPhotos() async {
//     try {
//
//       List? photoUrl = await unsplashRepository.getTitle();
//
//       if (photoUrl == null || photoUrl.isEmpty) return;
//
//       url = photoUrl;
//       log(url.toString());
//       notifyListeners();
//     } catch (error) {
//       log("Error when viewing the photos: $error");
//       rethrow;
//     }
//   }
// }
