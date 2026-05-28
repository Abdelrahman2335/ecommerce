part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FetchDataEvent extends HomeEvent {}

class GetCategoriesEvent extends HomeEvent {}

class GetCategoryProductsEvent extends HomeEvent {
  final String category;

  GetCategoryProductsEvent(this.category);
}
