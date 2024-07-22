import 'package:tractian_assets_mobile/data/models/asset_model.dart';

class LocationModel {
  String id;
  String name;
  String? parentId;
  List<LocationModel> subLocations = [];
  List<AssetModel> assets = [];

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

  void addLocationsList(List<LocationModel> list) {
    subLocations = list;
  }

  void adAssetsList(List<AssetModel> list) {
    assets = list;
  }
}
