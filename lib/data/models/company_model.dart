class CompanyModel {
  String id;
  String name;

  CompanyModel({required this.id, required this.name});

  factory CompanyModel.fromMap(Map map) {
    return CompanyModel(id: map["id"], name: map["name"]);
  }
}
