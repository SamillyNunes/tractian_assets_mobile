import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/assets_view_model.dart';
import 'assets_view.dart';
import 'widgets/company_button.dart';
import 'widgets/custom_appbar.dart';

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
      appBar: const CustomAppbar(
        label: 'TRACTIAN',
        hasStrongTitle: true,
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
              child: Column(
                children: viewModel.companies
                    .map(
                      (company) => Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: CompanyButton(
                          label: company.name,
                          onPressed: () {
                            viewModel.selectCompany(company: company);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AssetsView(),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
