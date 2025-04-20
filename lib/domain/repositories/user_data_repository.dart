
import '../../data/models/address_model.dart';

abstract class UserDataRepository {
  Future<void> personalInfo(String name, String phone, String? selectedGender, String age);

  Future<void> addressInfo(AddressModel address);

}
