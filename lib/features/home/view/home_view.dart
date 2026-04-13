import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/features/home/view/sections/home_bottom_bar.dart';
import 'package:iced26/features/home/view/sections/home_categories_section.dart';
import 'package:iced26/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/features/home/view/sections/home_header_section.dart';
import 'package:iced26/features/home/view/sections/home_search_section.dart';
import 'package:iced26/features/home/view/sections/home_social_news_section.dart';
import 'package:iced26/features/home/viewmodel/home_viewmodel.dart';

/// Pantalla principal de la aplicación.
class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.data});

  final AppData data;

  @override
  Widget build(BuildContext context) {
    final vm = HomeViewModel(data);

    // Mostramos un layout general con scroll.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeaderSection(dayLabel: vm.firstDay?.date ?? ''),
              const SizedBox(height: 16),
              const HomeSearchSection(),
              const SizedBox(height: 16),
              HomeFeaturedSection(events: vm.featuredEvents),
              const SizedBox(height: 16),
              HomeCategoriesSection(items: vm.categoryLabels),
              const SizedBox(height: 16),
              const HomeSocialNewsSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomBar(),
    );
  }
}
