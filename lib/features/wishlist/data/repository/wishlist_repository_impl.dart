import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firestore_failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/wishlist/data/repository/wishlist_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WishListRepository)
class WishListRepositoryImpl implements WishListRepository {
  final FirebaseService firebaseService;

  WishListRepositoryImpl(this.firebaseService);

  @override
  Future<Either<Failure, List<Product>>> loadWishlist() async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) return Left(FirestoreFailure("User not logged in"));

    final mainListRef = firebaseService.firestore.collection("mainData");
    final wishListRef = firebaseService.firestore.collection("wishList");

    try {
      final wishDoc = await wishListRef.doc(userId).get();
      final wishData = wishDoc.data();

      final List productIds = wishData?["productId"] ?? [];

      if (productIds.isEmpty) {
        return const Right([]);
      }

      // Firestore whereIn has a limit of 10. For production, chunking is needed if > 10.
      List<Product> fetchedItems = [];

      // Basic chunking to bypass 10-item limit
      for (var i = 0; i < productIds.length; i += 10) {
        final end = (i + 10 < productIds.length) ? i + 10 : productIds.length;
        final chunk = productIds.sublist(i, end);

        final docSnapshot = await mainListRef.where("id", whereIn: chunk).get();
        if (docSnapshot.docs.isNotEmpty) {
          fetchedItems.addAll(docSnapshot.docs
              .map((element) => Product.fromJson(element.data().toString())));
        }
      }

      return Right(fetchedItems);
    } on FirebaseException catch (error) {
      log("Error loadWishlist: $error");
      return Left(FirestoreFailure.fromFirestoreException(error));
    } catch (error) {
      log("Error loadWishlist: $error");
      return Left(FirestoreFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addWish(Product product) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) return Left(FirestoreFailure("User not logged in"));

    final wishListRef = firebaseService.firestore.collection("wishList");

    try {
      log("Adding product ${product.id} to wishlist for user $userId");
      final wishDoc = await wishListRef.doc(userId).get();
      if (!wishDoc.exists) {
        await wishListRef.doc(userId).set({
          "productId": [product.id]
        });
        log("Created wishlist and added product ${product.id}");
      } else {
        await wishListRef.doc(userId).update({
          "productId": FieldValue.arrayUnion([product.id])
        });
        log("Added product ${product.id} to existing wishlist");
      }

      return const Right(null); // Return void on success
    } on FirebaseException catch (error) {
      log("Error addWish: $error");
      return Left(FirestoreFailure.fromFirestoreException(error));
    } catch (error) {
      log("Error addWish: $error");
      return Left(FirestoreFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeWish(Product product) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) return Left(FirestoreFailure("User not logged in"));

    final wishListRef = firebaseService.firestore.collection("wishList");

    try {
      log("Removing product ${product.id} from wishlist for user $userId");
      final wishDoc = await wishListRef.doc(userId).get();
      if (wishDoc.exists) {
        await wishListRef.doc(userId).update({
          "productId": FieldValue.arrayRemove([product.id])
        });
        log("Removed product ${product.id} from wishlist");
      }
      return Right(null); // Return void on success
    } on FirebaseException catch (error) {
      log("Error removeWish: $error");
      return Left(FirestoreFailure.fromFirestoreException(error));
    } catch (error) {
      log("Error removeWish: $error");
      return Left(FirestoreFailure(error.toString()));
    }
  }
}
