import 'package:flutter/material.dart';
import 'package:tractian_assets_mobile/utils/assets_utils.dart';

import '../data/models/models.dart';
import '../data/repositories/assets_repository.dart';

class AssetsViewModel extends ChangeNotifier {
  final AssetsRepository assetsRepository;

  AssetsViewModel({required this.assetsRepository});

  List<CompanyModel> companies = [];
  List<LocationModel> locations = [];
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
    notifyListeners();
  }

  setCriticalSensorStatus(bool status) {
    criticalFilterIsPressed = status;
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
    for (var asset in assetsTemp) {
      final subAssets =
          assetsTemp.where((a) => a.parentId == asset.id).toList();
      asset.childAssets = subAssets;

      // chamada recursiva para pegar as pecas filhas das outras subpecas
      if (subAssets.isNotEmpty) {
        _getSubAssets(subAssets);
      }
    }

    return assetsTemp;
  }

  List<LocationModel> _getAssetsFromLocal(
      List<LocationModel> allLocals, List<AssetModel> allAssets) {
    final locations = allLocals;
    for (var local in locations) {
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

    return locations;
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
}
