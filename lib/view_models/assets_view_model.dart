import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../data/repositories/assets_repository.dart';

class AssetsViewModel extends ChangeNotifier {
  final AssetsRepository assetsRepository;

  AssetsViewModel({required this.assetsRepository});

  List<CompanyModel> companies = [];
  List<LocationModel> locations = [];

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

  Future fetchLocations() async {
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

        locations = rootLocations;
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
}
