import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_assets_mobile/views/home_view.dart';

import 'data/repositories/repositories.dart';
import 'data/services/api_service.dart';
import 'view_models/assets_view_model.dart';

void main() {
  final Dio dio = Dio();

  final apiService = ApiService(dio: dio);

  final AssetsRepository assetsRepository =
      AssetsRepositoryImpl(apiService: apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AssetsViewModel>(
          create: (_) => AssetsViewModel(assetsRepository: assetsRepository),
        ),
      ],
      child: const AppWidget(),
    ),
  );
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tractian Assets App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
    );
  }
}
