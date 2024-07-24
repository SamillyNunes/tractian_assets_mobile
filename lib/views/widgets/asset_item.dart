import 'package:flutter/material.dart';

import '../../core/app_icons.dart';
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
      assetsList = widget.location?.assets;
    }
  }

  Widget transformListIntoAssetItem(
      {required List assets, bool isAssetOrComponent = false}) {
    return ListView.builder(
      itemCount: assets.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final asset = assets[index];

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AssetItem(
            iconUrl: isAssetOrComponent
                ? (asset?.sensorType != null)
                    ? AppIcons.componentIcon
                    : AppIcons.assetIcon
                : AppIcons.locationIcon,
            location: isAssetOrComponent ? null : asset,
            asset: isAssetOrComponent ? asset : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.asset?.status != null
        ? (widget.asset!.status!.toLowerCase() == 'operating' ? true : false)
        : null;

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
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        widget.location?.name ?? widget.asset?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (status != null)
                        status
                            ? const Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size: 10,
                                ),
                              )
                            : const Icon(
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
          if ((assetsOrLocationsList?.isNotEmpty ?? false) && isOpened)
            transformListIntoAssetItem(
              assets: assetsOrLocationsList!,
              isAssetOrComponent: widget.asset != null,
            ),
          if ((assetsList?.isNotEmpty ?? false) && isOpened)
            transformListIntoAssetItem(
              assets: assetsList!,
              isAssetOrComponent: true,
            ),
        ],
      ),
    );
  }
}
