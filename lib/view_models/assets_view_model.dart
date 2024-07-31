import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../data/repositories/assets_repository.dart';
import '../utils/assets_utils.dart';

class AssetsViewModel extends ChangeNotifier {
  final AssetsRepository assetsRepository;

  AssetsViewModel({required this.assetsRepository});

  List<CompanyModel> companies = [];
  List<LocationModel> locations = [];
  List<AssetModel> unlinkedAssets = [];
  List<AssetModel> assets = [];
  List<NodeModel> nodes = [];

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
    // fetchAssets();
    notifyListeners();
  }

  setCriticalSensorStatus(bool status) {
    criticalFilterIsPressed = status;
    // fetchAssets();
    notifyListeners();
  }

  changeSearchingText(String value) {
    searchingText = value;
    notifyListeners();
  }

  submitSearchedText(String value) {
    locations = [];
    notifyListeners();
    // fetchAssets();
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

  Future fetchLocations() async {
    isLoading = true;
    errorMsg = '';

    try {
      if (companySelected != null) {
        final allLocationsList =
            await assetsRepository.getAllLocations(companySelected!.id);

        locations = allLocationsList;
      } else {
        errorMsg = 'Select a company';
      }
    } catch (e) {
      errorMsg = 'Failed to get locations';
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
        final allAssets =
            await assetsRepository.getAllAssets(companySelected!.id);

        assets = allAssets;
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

  Future buildNodes() async {
    isLoading = true;

    try {
      await fetchLocations();
      await fetchAssets();

      Map<String, List<LocationModel>> locationsMap = {};
      Map<String, List<AssetModel>> assetsMap = {};

      // Separando os locais dos setores por id
      for (var local in locations) {
        locationsMap.putIfAbsent(local.parentId ?? '', () => []).add(local);
      }

      for (var asset in assets) {
        // Verificando qual o "pai" do asset, se um local, outro asset, ou se eh solto
        final assetKey = asset.hasLocationAsParent()
            ? asset.locationId!
            : asset.isSubAsset()
                ? asset.parentId!
                : 'disliked';

        // Separando cada asset por "pai"
        assetsMap.putIfAbsent(assetKey, () => []).add(asset);
      }

      final localNodes = AssetsUtils.buildLocationNodes(
        parentId: '',
        locationMap: locationsMap,
        assetsMap: assetsMap,
      );

      final dislikedNodes = AssetsUtils.buildAssetsNodes(
        parentId: 'disliked',
        assetsMap: assetsMap,
      );

      nodes = [
        ...localNodes,
        ...dislikedNodes,
      ];
    } catch (e) {
      errorMsg = 'Something got wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
