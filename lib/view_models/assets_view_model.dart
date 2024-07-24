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

  Future fetchAssets() async {
    isLoading = true;
    errorMsg = '';

    try {
      if (companySelected != null) {
        final localsCopy = await _fetchLocations();

        final allAssets =
            await assetsRepository.getAllAssets(companySelected!.id);

        final formatedAssetsMap =
            AssetsUtils.formatAssetsListWithSubassets(allAssets);

        if (formatedAssetsMap.containsKey('unlinked')) {
          unlinkedAssets = formatedAssetsMap['unlinked']!;
        }

        final sortedAssets = AssetsUtils.sortAssetsList(
            formatedAssetsMap.containsKey('assets')
                ? formatedAssetsMap['assets']!
                : []);

        assets = sortedAssets;

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

      final assetsMap =
          AssetsUtils.formatAssetsListWithSubassets(filteredAssets);

      unlinkedAssets =
          assetsMap.containsKey('unlinked') ? assetsMap['unlinked']! : [];

      final filteredSubassets = assetsMap.containsKey('assets')
          ? assetsMap['assets']!
          : <AssetModel>[];

      locations = [];

      final localsCopy = await _fetchLocations();

      final formatedLocations =
          AssetsUtils.joinAssetsWithLocations(localsCopy, filteredSubassets);

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
