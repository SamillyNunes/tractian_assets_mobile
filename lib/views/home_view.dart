import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_assets_mobile/core/app_colors.dart';
import 'package:tractian_assets_mobile/view_models/assets_view_model.dart';

import 'widgets/company_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<AssetsViewModel>(
      context,
      listen: false,
    );
    viewModel.fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final viewModel = Provider.of<AssetsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tractianBlue,
        title: const Center(
          child: Text(
            'TRACTIAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.07,
          vertical: size.height * .03,
        ),
        child: Builder(
          builder: (context) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMsg?.isNotEmpty ?? false) {
              return Center(
                child: Text(
                  viewModel.errorMsg!,
                ),
              );
            }

            return SingleChildScrollView(
              child: Expanded(
                child: Column(
                  children: viewModel.companies
                      .map(
                        (company) => Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: CompanyButton(
                            label: company.name,
                            onPressed: () {},
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
