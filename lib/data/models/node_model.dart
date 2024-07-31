import 'package:tractian_assets_mobile/data/types/node_type.dart';

class NodeModel {
  String? key;
  String title;
  NodeType type;
  List<NodeModel> children;
  bool? hasCriticalStatus;
  bool? isEnergySensor;

  NodeModel({
    this.key,
    required this.title,
    required this.children,
    required this.type,
    this.hasCriticalStatus,
    this.isEnergySensor,
  });
}
