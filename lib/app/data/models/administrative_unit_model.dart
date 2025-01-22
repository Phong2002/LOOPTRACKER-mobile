class AdministrativeUnit  {
  final int id;
  final String name;

  AdministrativeUnit ({required this.id, required this.name});
  // Phương thức từ JSON thành đối tượng Dart
  factory AdministrativeUnit .provinceFromJson(Map<String, dynamic> json) {
    return AdministrativeUnit (
      id: json['ProvinceID'] as int,
      name: json['ProvinceName'] as String,
    );
  }
}