import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../data/repositories/assets_repository.dart';

class AssetsViewModel extends ChangeNotifier {
  final AssetsRepository assetsRepository;

  AssetsViewModel({required this.assetsRepository});

  List<CompanyModel> companies = [];
  bool isLoading = false;
  String? errorMsg;

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
}
