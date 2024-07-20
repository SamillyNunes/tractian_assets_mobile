import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../data/repositories/assets_repository.dart';

class AssetsViewModel extends ChangeNotifier {
  final AssetsRepository assetsRepository;

  AssetsViewModel({required this.assetsRepository});

  List<CompanyModel> companies = [];
  List<LocationModel> locations = [];
  CompanyModel? companySelected;

  bool isLoading = false;
  String? errorMsg;

  selectCompany({required CompanyModel company}) {
    companySelected = company;
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
        locations = await assetsRepository.getAllLocations(companySelected!.id);
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
