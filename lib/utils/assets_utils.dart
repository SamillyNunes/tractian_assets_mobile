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

  static List<LocationModel> formatLocationListWithSublocations(
      List<LocationModel> locations) {
    final rootLocations = <LocationModel>[];
    final waitingSublocations = <LocationModel>[];

    for (var local in locations) {
      if (local.isSubLocation()) {
        final rootList =
            rootLocations.where((l) => l.id == local.parentId).toList();

        if (rootList.isNotEmpty) {
          rootList[0].subLocations.add(local);
        } else {
          waitingSublocations.add(local);
        }
      } else {
        rootLocations.add(local);
      }
    }

    for (var sublocation in waitingSublocations) {
      final rootList =
          rootLocations.where((l) => l.id == sublocation.parentId).toList();

      if (rootList.isNotEmpty) {
        rootList[0].subLocations.add(sublocation);
      }
    }

    return rootLocations;
  }

  static Map<String, List<AssetModel>> formatAssetsListWithSubassets(
      List<AssetModel> assets) {
    final assetsTemp = assets;
    final unlinked = <AssetModel>[];
    for (var asset in assetsTemp) {
      if (asset.isUnliked()) {
        unlinked.add(asset);
        continue;
      }

      final subAssets =
          assetsTemp.where((a) => a.parentId == asset.id).toList();
      asset.childAssets = subAssets;

      // chamada recursiva para pegar as pecas filhas das outras subpecas
      if (subAssets.isNotEmpty) {
        AssetsUtils.formatAssetsListWithSubassets(subAssets);
      }
    }

    final map = {'unlinked': unlinked, 'assets': assetsTemp};

    return map;
  }

  static List<LocationModel> joinAssetsWithLocations(
      List<LocationModel> allLocals, List<AssetModel> allAssets) {
    final locals = allLocals;
    for (var local in locals) {
      // check assets for the sublocation
      for (var sublocation in local.subLocations) {
        final sublocationAssets =
            allAssets.where((a) => a.locationId == sublocation.id).toList();

        sublocation.assets = sublocationAssets;
      }

      // check this location assets
      final assetsFromLocal =
          allAssets.where((asset) => asset.locationId == local.id).toList();

      local.assets = assetsFromLocal;
    }

    return locals;
  }
}
