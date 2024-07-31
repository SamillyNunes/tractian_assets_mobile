import 'package:flutter/material.dart';

import '../../core/app_icons.dart';
import '../../data/models/node_model.dart';
import '../../data/types/node_type.dart';

class AssetItem extends StatefulWidget {
  final NodeModel node;
  // final String iconUrl;

  const AssetItem({
    super.key,
    // required this.iconUrl,
    required this.node,
  });

  @override
  State<AssetItem> createState() => _AssetItemState();
}

class _AssetItemState extends State<AssetItem> {
  bool isOpened = false;

  // List? assetsOrLocationsList;
  // List? assetsList;

  Widget transformListIntoAssetItem(
      {required List nodes, bool isAssetOrComponent = false}) {
    return ListView.builder(
      itemCount: nodes.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final n = nodes[index];

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AssetItem(
            node: n,
            // iconUrl: isAssetOrComponent
            //     ? (asset?.sensorType != null)
            //         ? AppIcons.componentIcon
            //         : AppIcons.assetIcon
            //     : AppIcons.locationIcon,
            // location: isAssetOrComponent ? null : asset,
            // asset: isAssetOrComponent ? asset : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // assetsOrLocationsList =
    //     widget.location?.subLocations ?? widget.asset?.childAssets;

    // if (widget.location != null) {
    //   assetsList = widget.location?.assets;
    // }

    // final status = widget.asset?.status != null
    //     ? (widget.asset!.status == AssetStatusType.operating ? true : false)
    //     : null;

    final node = widget.node;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isOpened = !isOpened;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                node.children.isNotEmpty
                    ? const Icon(
                        Icons.keyboard_arrow_down,
                        size: 25,
                      )
                    : const SizedBox(width: 25),
                Image.asset(
                  node.type == NodeType.location
                      ? AppIcons.locationIcon
                      : node.type == NodeType.asset
                          ? AppIcons.assetIcon
                          : AppIcons.componentIcon,
                  height: 25,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        node.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (node.hasCriticalStatus == true)
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 10,
                          ),
                        ),
                      if (node.isEnergySensor == true)
                        const Icon(
                          Icons.bolt,
                          color: Colors.green,
                          size: 15,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (node.children.isNotEmpty && isOpened)
            transformListIntoAssetItem(
              nodes: node.children,
              isAssetOrComponent: true, //TODO: ALTERAR
            ),
        ],
      ),
    );
  }
}
