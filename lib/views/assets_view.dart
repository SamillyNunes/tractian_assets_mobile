import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_icons.dart';
import '../data/models/models.dart';
import '../view_models/assets_view_model.dart';
import 'widgets/asset_item.dart';
import 'widgets/search_input.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/filter_button.dart';

class AssetsView extends StatefulWidget {
  const AssetsView({super.key});

  @override
  State<AssetsView> createState() => _AssetsViewState();
}

class _AssetsViewState extends State<AssetsView> {
  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<AssetsViewModel>(
      context,
      listen: false,
    );
    // viewModel.fetchLocations();
    viewModel.buildNodes();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AssetsViewModel>(context);

    return PopScope(
      onPopInvoked: (v) {
        viewModel.setSensorFilterStatus(false);
        viewModel.setCriticalSensorStatus(false);
        viewModel.changeSearchingText('');
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          label: 'Assets',
          hasBackButton: true,
        ),
        body: Builder(
          builder: (context) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMsg?.isNotEmpty ?? false) {
              return Center(
                child: Text('${viewModel.errorMsg}'),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SearchInput(
                        onChange: viewModel.changeSearchingText,
                        value: viewModel.searchingText,
                        onSubmit: viewModel.submitSearchedText,
                      ),
                      Row(
                        children: [
                          FilterButton(
                            label: 'Sensor de Energia',
                            icon: Icons.bolt,
                            isPressed: viewModel.sensorFilterIsPressed,
                            onPressed: () {
                              final currentStatus =
                                  viewModel.sensorFilterIsPressed;
                              viewModel.setSensorFilterStatus(!currentStatus);
                            },
                          ),
                          const SizedBox(width: 10),
                          FilterButton(
                            label: 'Crítico',
                            icon: Icons.warning_amber_rounded,
                            isPressed: viewModel.criticalFilterIsPressed,
                            onPressed: () {
                              final currentStatus =
                                  viewModel.criticalFilterIsPressed;
                              viewModel.setCriticalSensorStatus(!currentStatus);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                Expanded(
                  child: ListView.separated(
                    itemCount: viewModel.nodes.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final locationsLenght = viewModel.locations.length;

                      // LocationModel? location;
                      // AssetModel? asset;

                      // if (index >= locationsLenght) {
                      //   final unlinkedIndex = index - locationsLenght;
                      //   asset = viewModel.unlinkedAssets[unlinkedIndex];
                      // } else {
                      //   location = viewModel.locations[index];
                      // }

                      return AssetItem(
                        node: viewModel.nodes[index],
                        // iconUrl: location != null
                        //     ? AppIcons.locationIcon
                        //     : AppIcons.componentIcon,
                        // location: location,
                        // asset: asset,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
