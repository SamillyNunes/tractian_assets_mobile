import '../data/models/models.dart';
import '../data/types/node_type.dart';

class AssetsUtils {
  static List<NodeModel> buildAssetsNodes(
      {required String parentId,
      required Map<String, List<AssetModel>> assetsMap}) {
    if (!assetsMap.containsKey(parentId)) return [];

    final list = assetsMap[parentId]!
        .map(
          (asset) => NodeModel(
            title: asset.name,
            type: asset.isComponent() ? NodeType.component : NodeType.asset,
            // Passando o id desse asset para caso haja subassets
            children: buildAssetsNodes(
              parentId: asset.id,
              assetsMap: assetsMap,
            ),
          ),
        )
        .toList();

    return list;
  }

  static List<NodeModel> buildLocationNodes({
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
            type: NodeType.location,
            children: [
              ...buildLocationNodes(
                parentId: local.id,
                locationMap: locationMap,
                assetsMap: assetsMap,
              ),
              ...buildAssetsNodes(parentId: local.id, assetsMap: assetsMap)
            ],
          ),
        )
        .toList();

    return list;
  }
}
