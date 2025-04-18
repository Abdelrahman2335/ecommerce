import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/wishlist_repository.dart';

import '../models/product_model.dart';

class WishListRepositoryImpl implements WishListRepository {
  static final WishListRepositoryImpl _instance = WishListRepositoryImpl._internal();

  /// Singleton
  factory WishListRepositoryImpl() => _instance;

  /// Named constructor
  WishListRepositoryImpl._internal();


  FirebaseService firebaseService = FirebaseService();

  String? _userId;
  static CollectionReference<Map<String, dynamic>>? mainListRef;
  static CollectionReference<Map<String, dynamic>>? wishListRef;
  Map<String, dynamic>? wishData;
  final List<Product> items = [];
  List productIds = [];
  bool itemExist = false;
  bool noItemsInWishList = true;

  /// We are calling [fetchData] inside the Constructor of the class to initialize it as soon as we call the class

  /// This function is used to get the data from the database,
  /// also it's used to filter the data to get only the wished items
  @override
  fetchData() async {
    _userId = firebaseService.auth.currentUser?.uid;
    mainListRef = firebaseService.firestore.collection("mainData");
    wishListRef = firebaseService.firestore.collection("wishList");

    /// Don't take [docSnapshot] out of the try block, when we are creating the doc for the first time it's null
    try {
      wishData =
          await wishListRef?.doc(_userId).get().then((value) => value.data());

      productIds = wishData?["productId"] ?? [];

      /// You have to check if the [wishData] is not null and not empty or you will catch an error
      if (wishData != null && !wishData?["productId"].isEmpty) {
        /// Important to know that whereIn is limited with only 10 elements.
        /// this variable is used to get the data from the database
        /// [where] and [whereIn] go inside the document. Note: doc id is the same as the product id
        QuerySnapshot<Map<String, dynamic>> docSnapshot =
            await mainListRef!.where("id", whereIn: productIds).get();

        if (docSnapshot.docs.isNotEmpty) {
          items.addAll(docSnapshot.docs
              .map((element) => Product.fromJson(element.data())));
          noItemsInWishList = false;
        }
      } else {
        return;
      }
    } catch (error) {
      log("Error fetchData: $error");
    }
  }

  @override
  Future addAndRemoveWish(Product product) async {

    itemExist = productIds.contains(product.id);

    try {
      log("itemExist: ${itemExist.toString()}");
      log("productId: ${product.id}");
      if (wishData != null && wishData!.isNotEmpty) {
        if (itemExist) {
          await wishListRef?.doc(_userId).update({
            "productId": FieldValue.arrayRemove([product.id])
          });

          productIds.remove(product.id);
          items.remove(product);
          items.isEmpty ? noItemsInWishList = true : noItemsInWishList = false;

        } else {
          await wishListRef?.doc(_userId).update({
            "productId": FieldValue.arrayUnion([product.id])
          });
          productIds.add(product.id);
          items.add(product);
          noItemsInWishList = false;

        }
      } else {
        await wishListRef?.doc(_userId).set(
          {
            "productId": [product.id]
          },
        );

        productIds.add(product.id);
        items.add(product);
        noItemsInWishList = false;
      }
      // log("After the function is called: ${productIds.toString()}");
      // log("wishData content?: ${wishData.toString()}");
      // log("wishData is empty?: ${wishData?["productId"].isEmpty}");
      // log("docSnapshot is null?: ${docSnapshot?["id"]}");
    } catch (error) {
      log("addWish error: ${error.toString()}");
    }
  }

//
// /// This function is used to fetch the wished items by give the items the data in List of Product
//   /// I think we can make this simple.
// fetchWishedItems(BuildContext context) {
//   /// Important to know that we don't listen to [ItemProvider], because there is no changes will happen, at least for now
//   final allItems = Provider.of<ItemProvider>(context, listen: false);
//
//   for (Product element in allItems.mainData) {
//     if (productIds.contains(element.id)) {
//       items.add(element);
//     }
//   }
//   // allItems.mainData.firstWhere((element) => element.id == productIds[0]);
//
// }

  get receivedWish => productIds;
}
