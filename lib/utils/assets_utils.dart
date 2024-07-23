import '../data/models/models.dart';

class AssetsUtils {
  static List<LocationModel> sortLocationList(List<LocationModel> allLocals) {
    final emptyLocations = allLocals
        .where((local) => local.subLocations.isEmpty && local.assets.isEmpty)
        .toList();

    allLocals.removeWhere((l) => emptyLocations.contains(l));

    allLocals.addAll(emptyLocations);

    return allLocals;
  }

  static List<AssetModel> sortAssetsList(List<AssetModel> allAssets) {
    final emptyAssets =
        allAssets.where((asset) => asset.childAssets.isEmpty).toList();

    allAssets.removeWhere((a) => emptyAssets.contains(a));

    allAssets.addAll(emptyAssets);

    return allAssets;
  }
}
