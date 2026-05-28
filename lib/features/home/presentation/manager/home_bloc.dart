import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/home/data/repository/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._homeRepo) : super(const HomeState()) {
    on<FetchDataEvent>(fetchData);
    on<GetCategoriesEvent>(getCategories);
    on<GetCategoryProductsEvent>(categoryProducts);

    add(FetchDataEvent());
    add(GetCategoriesEvent());
  }

  final HomeRepo _homeRepo;

  void fetchData(FetchDataEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      status: HomeStatus.loading,
    ));

    final fetchedData = await _homeRepo.getData();
    fetchedData.fold((error) {
      emit(state.copyWith(
          errorMessage: error.errorMessage, status: HomeStatus.failure));
    }, (value) {
      if (value != state.receivedData) {
        emit(state.copyWith(receivedData: value, status: HomeStatus.success));
      }
    });
  }

  void getCategories(GetCategoriesEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      status: HomeStatus.loading,
    ));

    final categories = await _homeRepo.getCategories();
    categories.fold((error) {
      emit(state.copyWith(
          errorMessage: error.errorMessage, status: HomeStatus.failure));
    }, (value) {
      emit(state.copyWith(
        categoryList: value,
        status: HomeStatus.success,
      ));
    });
  }

  void categoryProducts(
      GetCategoryProductsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      status: HomeStatus.loading,
    ));

    final value = await _homeRepo.categoryProducts(category: event.category);
    value.fold((error) {
      emit(state.copyWith(
          errorMessage: error.errorMessage, status: HomeStatus.failure));
    }, (value) {
      emit(state.copyWith(
        productCategoryList: value,
        status: HomeStatus.success,
      ));
    });
  }
}
