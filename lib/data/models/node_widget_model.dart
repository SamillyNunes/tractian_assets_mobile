class NodeModel {
  String? key;
  String title;
  List<NodeModel> children;

  NodeModel({this.key, required this.title, required this.children});
}
