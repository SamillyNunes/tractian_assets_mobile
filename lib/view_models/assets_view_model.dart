import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../data/repositories/assets_repository.dart';
import '../data/types/types.dart';
import '../utils/assets_utils.dart';

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
  String searchingText = '';

  bool isLoading = false;
  String? errorMsg;

  selectCompany({required CompanyModel company}) {
    companySelected = company;
  }

  setSensorFilterStatus(bool status) {
    sensorFilterIsPressed = status;
    fetchAssets(fetchDataAgain: false);
    notifyListeners();
  }

  setCriticalSensorStatus(bool status) {
    criticalFilterIsPressed = status;
    fetchAssets(fetchDataAgain: false);
    notifyListeners();
  }

  changeSearchingText(String value) {
    searchingText = value;
    notifyListeners();
  }

  submitSearchedText(String value) {
    locations = [];
    notifyListeners();
    fetchAssets();
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

        final formatedLocations =
            AssetsUtils.formatLocationListWithSublocations(allLocationsList);

        return formatedLocations;
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

  Future fetchAssets({bool fetchDataAgain = true}) async {
    isLoading = true;
    errorMsg = '';
    if (fetchDataAgain) {
      locations = [];
    }

    try {
      if (companySelected != null) {
        final localsCopy = fetchDataAgain ? await _fetchLocations() : locations;

        final allAssets =
            await assetsRepository.getAllAssets(companySelected!.id);

        assets = allAssets;

        List<AssetModel> tempAssets = [];

        if (searchingText.isNotEmpty) {
          tempAssets = allAssets
              .where((a) =>
                  a.name.toLowerCase().contains(searchingText.toLowerCase()))
              .toList();
        }

        if (criticalFilterIsPressed || sensorFilterIsPressed) {
          tempAssets =
              _filterAssets(tempAssets.isNotEmpty ? tempAssets : allAssets);
        }

        if (tempAssets.isEmpty) {
          tempAssets = allAssets;
        }

        final formatedAssetsMap =
            AssetsUtils.formatAssetsListWithSubassets(tempAssets);

        if (formatedAssetsMap.containsKey('unlinked')) {
          unlinkedAssets = formatedAssetsMap['unlinked']!;
        }

        final sortedAssets = AssetsUtils.sortAssetsList(
            formatedAssetsMap.containsKey('assets')
                ? formatedAssetsMap['assets']!
                : []);

        final formatedLocations =
            AssetsUtils.joinAssetsWithLocations(localsCopy, sortedAssets);

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

  _filterAssets(List<AssetModel> allAssets) {
    final filteredAssets = allAssets.where((a) {
      bool condition1 = true;
      bool condition2 = true;

      if (sensorFilterIsPressed) {
        condition1 = a.sensorType == SensorType.energy || a.sensorType == null;
      }

      if (criticalFilterIsPressed) {
        condition2 = a.status == AssetStatusType.alert || a.status == null;
      }

      return condition1 && condition2;
    }).toList();

    return filteredAssets;
  }
}
