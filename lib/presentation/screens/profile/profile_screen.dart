import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/report.dart';
import '../widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  final Report report;

  const ProfileScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(report.fullName, // Show full name on profile
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.secondary), // Placeholder for image
                  if (report.evidenceUrls.isNotEmpty)
                    Image.network(report.evidenceUrls.first, fit: BoxFit.cover,
                      errorBuilder: (c,e,s) => Container(color: AppColors.secondary)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, AppColors.background],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildBadge(
                            'Riesgo: ${report.riskLevel}/5',
                            report.riskLevel > 3 ? AppColors.riskHigh : AppColors.riskMedium),
                        const SizedBox(width: 8),
                        if (report.isVerified)
                          _buildBadge('Verificado', Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Información Personal'),
                    _buildInfoRow('Edad', '${report.age} años'),
                    _buildInfoRow('Género', report.gender),
                    _buildInfoRow('Ubicación', '${report.city}, ${report.district}, ${report.country}'),

                    if (report.socialMedia != null) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle('Redes Sociales'),
                      Row(
                        children: report.socialMedia!.entries.map((e) =>
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ActionChip(
                              label: Text(e.key),
                              avatar: const Icon(Icons.link, size: 16),
                              onPressed: () {
                                // launchUrl(Uri.parse(e.value)); // Would need valid URL logic
                              },
                            ),
                          )
                        ).toList(),
                      ),
                    ],

                    const SizedBox(height: 24),
                    _buildSectionTitle('Detalles del Reporte'),
                    Text(
                      'Categoría: ${report.category}',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.description,
                      style: const TextStyle(color: AppColors.textPrimary, height: 1.5),
                    ),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Votación Comunitaria'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildVoteButton(
                            icon: Icons.thumb_up,
                            label: 'Es Real (${report.votesReal})',
                            color: Colors.green,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildVoteButton(
                            icon: Icons.thumb_down,
                            label: 'Es Falso (${report.votesFake})',
                            color: Colors.red,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '¿Eres tú?',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Si crees que esta información es falsa o difamatoria, puedes ejercer tu derecho a réplica.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'ESTE SOY YO - DEFENDERME',
                            backgroundColor: Colors.transparent,
                            textColor: AppColors.primary,
                            onPressed: () {
                              // Navigate to Defense Form
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildVoteButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
