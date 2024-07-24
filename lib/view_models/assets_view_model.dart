import 'package:flutter/material.dart';
import 'package:tractian_assets_mobile/data/types/types.dart';
import 'package:tractian_assets_mobile/utils/assets_utils.dart';

import '../data/models/models.dart';
import '../data/repositories/assets_repository.dart';

class AssetsViewModel extends ChangeNotifier {
  final AssetsRepository assetsRepository;

  AssetsViewModel({required this.assetsRepository});

  List<CompanyModel> companies = [];
  List<LocationModel> locations = [];
  List<AssetModel> unlinkedAssets = [];
  List<AssetModel> assets = [];

  CompanyModel? companySelected;
  bool sensorFilterIsPressed = false;
  bool criticalFilterIsPressed = false;

  bool isLoading = false;
  String? errorMsg;

  selectCompany({required CompanyModel company}) {
    companySelected = company;
  }

  setSensorFilterStatus(bool status) {
    sensorFilterIsPressed = status;
    fetchAssetsWithFilter();
    notifyListeners();
  }

  setCriticalSensorStatus(bool status) {
    criticalFilterIsPressed = status;
    fetchAssetsWithFilter();
    notifyListeners();
  }

  Future fetchCompanies() async {
    isLoading = true;
    errorMsg = '';

    try {
      companies = await assetsRepository.getAllCompanies();
    } catch (e) {
      errorMsg = 'Failed to get companies';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<LocationModel>> _fetchLocations() async {
    isLoading = true;
    errorMsg = '';

    try {
      if (companySelected != null) {
        final allLocationsList =
            await assetsRepository.getAllLocations(companySelected!.id);

        final rootLocations = <LocationModel>[];
        final waitingSublocations = <LocationModel>[];

        for (var local in allLocationsList) {
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
      } else {
        errorMsg = 'Select a company';
        return [];
      }
    } catch (e) {
      errorMsg = 'Failed to get locations';
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<AssetModel> _getSubAssets(List<AssetModel> allAssets) {
    final assetsTemp = allAssets;
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
        _getSubAssets(subAssets);
      }
    }

    unlinkedAssets = unlinked;

    return assetsTemp;
  }

  List<LocationModel> _getAssetsFromLocal(
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

  Future fetchAssets() async {
    isLoading = true;
    errorMsg = '';

    try {
      if (companySelected != null) {
        final localsCopy = await _fetchLocations();

        final allAssets =
            await assetsRepository.getAllAssets(companySelected!.id);

        final formatedAssets = _getSubAssets(allAssets);

        final sortedAssets = AssetsUtils.sortAssetsList(formatedAssets);

        assets = sortedAssets;

        final formatedLocations = _getAssetsFromLocal(localsCopy, sortedAssets);

        final sortedLocations = AssetsUtils.sortLocationList(formatedLocations);

        locations = sortedLocations;
      } else {
        errorMsg = 'Select a company';
      }
    } catch (e) {
      errorMsg = 'Failed to get assets';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future fetchAssetsWithFilter() async {
    try {
      isLoading = true;
      final filteredAssets = assets.where((a) {
        bool condition1 = true;
        bool condition2 = true;

        if (sensorFilterIsPressed) {
          condition1 =
              a.sensorType == SensorType.energy || a.sensorType == null;
        }

        if (criticalFilterIsPressed) {
          condition2 = a.status == AssetStatusType.alert || a.status == null;
        }

        return condition1 && condition2;
      }).toList();

      final filteredSubassets = _getSubAssets(filteredAssets);

      locations = [];

      final localsCopy = await _fetchLocations();

      final formatedLocations =
          _getAssetsFromLocal(localsCopy, filteredSubassets);

      final sortedLocations = AssetsUtils.sortLocationList(formatedLocations);

      locations = sortedLocations;
    } catch (e) {
      errorMsg = 'Failed to fetch';
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
