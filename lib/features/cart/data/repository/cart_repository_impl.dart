import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firestore_failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:injectable/injectable.dart';

import '../model/cart_model.dart';
import 'cart_repository.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._firebaseService);

  final FirebaseService _firebaseService;

  @override
  Future<Either<Failure, List<CartModel>>> initializeCart() async {
    final userId = _firebaseService.auth.currentUser?.uid;
    if (userId == null) {
      return Left(FirestoreFailure("User not logged in"));
    }

    final cartRef = _firebaseService.firestore.collection("cartData");

    try {
      final items = await _fetchItems(cartRef, userId);
      return Right(items);
    } on FirebaseException catch (error) {
      log("Error in the Cart: $error");
      return Left(FirestoreFailure.fromFirestoreException(error));
    } catch (error) {
      log("Error in the Cart: $error");
      return Left(FirestoreFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(Product product) async {
    final userId = _firebaseService.auth.currentUser?.uid;
    if (userId == null) {
      return Left(FirestoreFailure("User not logged in"));
    }
    final productId = product.id;
    if (productId == null) {
      return Left(FirestoreFailure("Product id missing"));
    }
    final cartRef = _firebaseService.firestore.collection("cartData");
    final docId = "${userId}_$productId";
    final docRef = cartRef.doc(docId);

    try {
      final existingDoc = await docRef.get();
      final itemExist = existingDoc.exists;

      log("itemExist: $itemExist");
      log("userId: $userId");
      log("productId: ${product.id}");
      log("Quantity for the main data: ${product.stock}");

      if (itemExist) {
        /// If the item is already in the cart, increment the quantity
        await docRef.update({
          "quantity": FieldValue.increment(1),
        });
      } else {
        await docRef
            .set(CartModel(userId: userId, product: product, quantity: 1).toJson());
      }

      return const Right(null);
    } on FirebaseException catch (error) {
      log("addToCart error: ${error.toString()}");
      return Left(FirestoreFailure.fromFirestoreException(error));
    } catch (error) {
      log("addToCart error: ${error.toString()}");
      return Left(FirestoreFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(Product product) async {
    final userId = _firebaseService.auth.currentUser?.uid;
    if (userId == null) {
      return Left(FirestoreFailure("User not logged in"));
    }
    final productId = product.id;
    if (productId == null) {
      return Left(FirestoreFailure("Product id missing"));
    }
    final cartRef = _firebaseService.firestore.collection("cartData");
    final docId = "${userId}_$productId";

    try {
      await cartRef.doc(docId).delete();
      return const Right(null);
    } on FirebaseException catch (error) {
      log("removeItem error: ${error.toString()}");
      return Left(FirestoreFailure.fromFirestoreException(error));
    } catch (error) {
      log("removeItem error: ${error.toString()}");
      return Left(FirestoreFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> decreaseItem(Product product) async {
    final userId = _firebaseService.auth.currentUser?.uid;
    if (userId == null) {
      return Left(FirestoreFailure("User not logged in"));
    }
    final productId = product.id;
    if (productId == null) {
      return Left(FirestoreFailure("Product id missing"));
    }
    final cartRef = _firebaseService.firestore.collection("cartData");
    final docId = "${userId}_$productId";

    try {
      final docRef = cartRef.doc(docId);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        log("decreaseItem skipped: cart item not found for $docId");
        return const Right(null);
      }

      final data = docSnapshot.data();
      if (data == null) {
        log("decreaseItem skipped: cart item data missing for $docId");
        return const Right(null);
      }

      final quantity = data["quantity"];
      if (quantity is! int) {
        log("decreaseItem error: invalid quantity for $docId");
        return Left(FirestoreFailure("Invalid cart item quantity"));
      }

      final currentQuantity = quantity;
      log("Current quantity: $currentQuantity");

      if (currentQuantity > 1) {
        await docRef.update({
          "quantity": FieldValue.increment(-1),
        });
      } else {
        await docRef.delete();
      }

      return const Right(null);
    } on FirebaseException catch (error) {
      log("decreaseItem error: ${error.toString()}");
      return Left(FirestoreFailure.fromFirestoreException(error));
    } catch (error) {
      log("decreaseItem error: ${error.toString()}");
      return Left(FirestoreFailure(error.toString()));
    }
  }

  Future<List<CartModel>> _fetchItems(
    CollectionReference<Map<String, dynamic>> cartRef,
    String userId,
  ) async {
    final cartData = await cartRef.where("userId", isEqualTo: userId).get();
    if (cartData.docs.isEmpty) {
      return [];
    }

    return cartData.docs
        .map((element) => CartModel.fromJson(element.data()))
        .toList();
  }

}
