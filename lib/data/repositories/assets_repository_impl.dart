import '../models/models.dart';
import '../services/api_service.dart';
import 'assets_repository.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  final ApiService apiService;

  AssetsRepositoryImpl({required this.apiService});

  @override
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      final data = await apiService.get(resource: 'companies');

      return data.map((json) => CompanyModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to get companies, error: $e');
    }
  }

  @override
  Future<List<LocationModel>> getAllLocations(String companyId) async {
    try {
      final data =
          await apiService.get(resource: 'companies/$companyId/locations');

      return data.map((json) => LocationModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to get locations, error: $e');
    }
  }

  @override
  Future<List<AssetModel>> getAllAssets(String companyId) async {
    try {
      final data =
          await apiService.get(resource: 'companies/$companyId/assets');

      return data.map((json) => AssetModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to get assets, error: $e');
    }
  }
}
