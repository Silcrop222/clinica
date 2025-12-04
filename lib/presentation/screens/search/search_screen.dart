import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/report_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/report_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: CustomTextField(
          label: 'Buscar nombre...',
          controller: _searchController,
          onChanged: (val) {
             // Simple debounce could be added here
             if (val.length > 2) {
                Provider.of<ReportProvider>(context, listen: false).search(val, city: _cityController.text.isNotEmpty ? _cityController.text : null);
             }
          },
        ),
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: const Text('Filtros Avanzados', style: TextStyle(color: AppColors.textSecondary)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomTextField(
                  label: 'Filtrar por Ciudad',
                  controller: _cityController,
                  onChanged: (val) {
                     if (_searchController.text.isNotEmpty) {
                       Provider.of<ReportProvider>(context, listen: false).search(_searchController.text, city: val);
                     }
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Consumer<ReportProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (provider.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text('Busca por nombre y apellido', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (ctx, i) => ReportCard(report: provider.searchResults[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
