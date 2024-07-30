import 'package:flutter/material.dart';
import 'package:tractian_assets_mobile/data/models/node_widget_model.dart';

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

  Future fetchLocations() async {
    isLoading = true;
    errorMsg = '';

    try {
      if (companySelected != null) {
        final allLocationsList =
            await assetsRepository.getAllLocations(companySelected!.id);

        final formatedLocations =
            AssetsUtils.formatLocationListWithSublocations(allLocationsList);

        locations = formatedLocations;
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

  Future fetchAssets({bool fetchDataAgain = true}) async {
    isLoading = true;
    errorMsg = '';
    // if (fetchDataAgain) {
    //   locations = [];
    // }

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

  List<NodeModel> _buildAssetsNodes(
      {required String parentId,
      required Map<String, List<AssetModel>> assetsMap}) {
    if (!assetsMap.containsKey(parentId)) return [];

    final list = assetsMap[parentId]!
        .map(
          (asset) => NodeModel(
            title: asset.name,
            // Passando o id desse asset para caso haja subassets
            children: _buildAssetsNodes(
              parentId: asset.id,
              assetsMap: assetsMap,
            ),
          ),
        )
        .toList();

    return list;
  }

  List<NodeModel> _buildLocationNodes({
    required String parentId,
    required Map<String, List<LocationModel>> locationMap,
    required Map<String, List<AssetModel>> assetsMap,
  }) {
    if (!locationMap.containsKey(parentId)) return [];

    final list = locationMap[parentId]!
        .map(
          (local) => NodeModel(
            key: local.id,
            title: local.name,
            children: [
              ..._buildLocationNodes(
                parentId: local.id,
                locationMap: locationMap,
                assetsMap: assetsMap,
              ),
              ..._buildAssetsNodes(parentId: local.id, assetsMap: assetsMap)
            ],
          ),
        )
        .toList();

    return list;
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
      final localNodes = _buildLocationNodes(
        parentId: '',
        locationMap: locationsMap,
        assetsMap: assetsMap,
      );

      nodes = localNodes;
    } catch (e) {
      errorMsg = 'Something got wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
