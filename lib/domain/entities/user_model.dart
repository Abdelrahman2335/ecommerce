/// Note: abstract class is just a blueprint for a class.
enum Genders {
  male,
  female;

  String get string {
    switch (this) {
      case Genders.male:
        return "male";
      case Genders.female:
        return "female";
    }
  }
}

abstract class UserEntity {
  String? get name;

  String? get role;

  String? get phone;

  DateTime? get createdAt;

  String? get age;

  Genders? get gender;
}
