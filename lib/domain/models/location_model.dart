class LocationModel {
  String id;
  String name;
  String? parentId;

  LocationModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory LocationModel.fromMap(Map map) {
    return LocationModel(
      id: map["id"],
      name: map["name"],
      parentId: map["parentId"],
    );
  }

  bool isSubLocation() {
    return parentId != null;
  }
}
