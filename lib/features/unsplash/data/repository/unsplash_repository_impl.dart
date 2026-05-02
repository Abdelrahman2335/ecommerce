// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:ecommerce/core/network/dio_client.dart';
// import 'package:ecommerce/core/services/firebase_service.dart';
// import 'package:ecommerce/core/services/remote_config_service.dart';
//
// import '../../domain/repositories/unsplash_repository.dart';
//
// class UnsplashRepositoryImpl implements UnsplashRepository {
//   final RemoteConfigService remoteConfigService = RemoteConfigService();
//   final String url = "https://api.unsplash.com/search/photos/";
//   final FirebaseService firebaseService = FirebaseService();
//
//   @override
//   Future<List?> getPhotos({List? queries}) async {
//     List? photos = [];
//     try {
//       String token = remoteConfigService.remoteConfig.getString("access_key");
//       log(token);
//       log(queries.toString());
//       Response? response;
//       for (String query in queries ?? []) {
//         response = await DioClient.initializeDio(url: url).get(url,
//             queryParameters: {
//               "query": query,
//               "per_page": queries?.length, // Fetch a couple of images per query
//             },
//             options: Options(headers: {"Authorization": "Client-ID $token"}));
//       }
//
//       if (response != null &&
//           response.statusCode == 200 &&
//           response.data["results"].isNotEmpty) {
//         photos.addAll(
//             response.data["results"].map((image) => image["urls"]["regular"]));
//
//         // log("originalUrl: ${response.data["results"][1]["urls"]["regular"]},StatusCode: ${response.statusCode},Response data type: ${response.data.runtimeType}");
//         // log(photos.toString());
//         return photos;
//       } else {
//         log(response?.statusCode.toString() ?? "response is null");
//         return null;
//       }
//     } catch (error) {
//       log("Error when getting the photos: $error");
//       rethrow;
//     }
//   }
//
//   @override
//   Future? getTitle() async {
//     List<String?> titles = [];
//     try {
//       FirebaseFirestore fireStore = firebaseService.firestore;
//
//       final data = await fireStore.collection("mainData").get();
//
//       if (data.docs.isNotEmpty) {
//         // log("The result is: ${data.docs.first.data().toString()}");
//         titles.addAll(
//             data.docs.map((doc) => doc.data()["category"].toString()).toList());
//         // log("titles: $titles, length: ${titles.length}");
//       } else {
//         log("No data found");
//         return null;
//       }
//     } catch (error) {
//       log("Error when getting the title: $error");
//       rethrow;
//     }
//     return getPhotos(queries: titles);
//   }
// }
