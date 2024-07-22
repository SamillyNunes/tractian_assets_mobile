import 'package:flutter/material.dart';
import 'package:tractian_assets_mobile/core/app_icons.dart';

import '../../data/models/asset_model.dart';
import '../../data/models/location_model.dart';

class AssetItem extends StatefulWidget {
  final LocationModel? location;
  final AssetModel? asset;
  final String iconUrl;

  const AssetItem({
    super.key,
    required this.iconUrl,
    this.location,
    this.asset,
  }) : assert(location == null || asset == null);

  @override
  State<AssetItem> createState() => _AssetItemState();
}

class _AssetItemState extends State<AssetItem> {
  bool isOpened = false;

  List? assetsOrLocationsList;
  List? assetsList;
  bool assetsListHasLocations = false;

  @override
  void initState() {
    super.initState();

    assetsOrLocationsList =
        widget.location?.subLocations ?? widget.asset?.childAssets;
    assetsListHasLocations = widget.location != null;

    if (assetsListHasLocations) {
      print('locations: ${widget.location} ');
      assetsList = widget.location?.assets;
    }
  }

  List<Widget> transformListIntoAssetItem(
      {required List assets, bool isAssetOrComponent = false}) {
    return [
      ...assets.map(
        (obj) => Row(
          children: [
            Container(
              height: 40,
              width: 0.5,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: Colors.grey.shade400,
            ),
            AssetItem(
              iconUrl: isAssetOrComponent
                  ? AppIcons.assetIcon
                  : AppIcons.locationIcon,
              location: isAssetOrComponent ? null : obj,
              asset: isAssetOrComponent ? obj : null,
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                ((assetsOrLocationsList?.isNotEmpty ?? false) ||
                        (assetsList?.isNotEmpty ?? false))
                    ? const Icon(
                        Icons.keyboard_arrow_down,
                        size: 25,
                      )
                    : const SizedBox(width: 25),
                Image.asset(
                  widget.iconUrl,
                  height: 25,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.location?.name ?? widget.asset?.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if ((assetsOrLocationsList?.isNotEmpty ?? false) && isOpened)
            ...transformListIntoAssetItem(assets: assetsOrLocationsList!),
          if ((assetsList?.isNotEmpty ?? false) && isOpened)
            ...transformListIntoAssetItem(
              assets: assetsList!,
              isAssetOrComponent: true,
            ),
        ],
      ),
    );
  }
}
