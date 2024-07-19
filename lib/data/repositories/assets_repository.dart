import 'package:tractian_assets_mobile/data/models/models.dart';

abstract class AssetsRepository {
  Future<List<CompanyModel>> getAllCompanies();
  Future<List<LocationModel>> getAllLocations(String companyId);
  Future<List<AssetModel>> getAllAssets(String companyId);
}
