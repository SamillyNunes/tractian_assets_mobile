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

  List? assetsList;
  bool assetsListHasLocations = false;

  @override
  void initState() {
    super.initState();

    assetsList = widget.location?.subLocations ?? widget.asset?.childAssets;
    assetsListHasLocations = widget.location != null;
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
                (assetsList?.isNotEmpty ?? false)
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
                  widget.location?.name ?? widget.location?.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if ((assetsList?.isNotEmpty ?? false) && isOpened) ...[
            // const SizedBox(height: 5),
            ...assetsList!.map(
              (obj) => Row(
                children: [
                  Container(
                    height: 40,
                    width: 0.5,
                    margin: const EdgeInsets.symmetric(horizontal: 13),
                    color: Colors.grey.shade400,
                  ),
                  AssetItem(
                    iconUrl: assetsListHasLocations
                        ? AppIcons.locationIcon
                        : AppIcons.assetIcon,
                    location: assetsListHasLocations ? obj : null,
                    asset: assetsListHasLocations ? null : obj,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
