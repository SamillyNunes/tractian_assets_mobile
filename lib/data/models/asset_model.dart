class AssetModel {
  String id;
  String name;
  String? parentId;
  String? sensorId;
  String? sensorType;
  String? status;
  String? gatewayId;
  String? locationId;
  List<AssetModel> childAssets = [];

  AssetModel({
    required this.id,
    required this.name,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
    this.gatewayId,
    this.locationId,
  });

  factory AssetModel.fromMap(Map map) {
    return AssetModel(
      id: map["id"],
      name: map["name"],
      parentId: map["parentId"],
      sensorId: map["sensorId"],
      sensorType: map["sensorType"],
      status: map["status"],
      gatewayId: map["gatewayId"],
      locationId: map["locationId"],
    );
  }

  bool isComponent() {
    return sensorType != null;
  }

  bool isUnliked() {
    return locationId == null && parentId == null;
  }

  bool hasLocationAsParent() {
    return locationId != null && sensorId == null;
  }

  bool isSubAsset() {
    return parentId != null && sensorId == null;
  }
}
