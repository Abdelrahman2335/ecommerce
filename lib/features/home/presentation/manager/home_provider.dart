import '../../../../../core/models/product_model/product.dart';
import 'package:ecommerce/features/home/data/repository/home_repo.dart';
import 'package:flutter/cupertino.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemRepository _itemRepository;
  List<Product> _mainData = [];
  List<Product> _productCategories = [];
  List<String> _categories = [];

  List<Product> get receivedData => _mainData;
  bool _isLoading = false;
  bool _removeAdd = false;
  String? errorMessage;

  bool get removeAdd => _removeAdd;

  bool get isLoading => _isLoading;

  bool get hasError => errorMessage != null;

  ItemViewModel(this._itemRepository) {
    Future.microtask(() => fetchData());

    /// Ensure data is fetched after the constructor is completed
  }

  void fetchData() async {
    _isLoading = true;
    notifyListeners();

    final fetchedData = await _itemRepository.getData();
    fetchedData.fold((error) {
      errorMessage = error.errorMessage;
      _isLoading = false;
      notifyListeners();
    }, (value) {
      if (value != _mainData) {
        _mainData = value;

        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void getCategories() async {
    _isLoading = true;
    _categories.clear;
    notifyListeners();

    final categories = await _itemRepository.getCategories();
    categories.fold((error) {
      errorMessage = error.errorMessage;
      _isLoading = false;
      notifyListeners();
    }, (value) {
      _categories = value;

      _isLoading = false;
      notifyListeners();
    });
  }

  void categoryProducts({required String category}) async {
    _isLoading = true;
    _productCategories.clear;
    notifyListeners();

    final value = await _itemRepository.categoryProducts(category: category);
    value.fold((error) {
      errorMessage = error.errorMessage;
      _isLoading = false;
      notifyListeners();
    }, (value) {
      _productCategories = value;

      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleRemoveAdd() {
    _removeAdd = true;
    notifyListeners();
  }
}
