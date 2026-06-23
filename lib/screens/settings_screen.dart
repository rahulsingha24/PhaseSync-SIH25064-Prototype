import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/simulation_provider.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final simPro = Provider.of<SimulationProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App System Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 32),
            const Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: const Color(0xFF4B5563),
                  ),
                ),
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppTheme.primaryBlue,
                  onChanged: (val) => themeProvider.toggleTheme(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Threshold Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildSliderRow(
                    'Low Battery Warning',
                    '${(simPro.lowBatteryThreshold * 100).toInt()}%',
                    simPro.lowBatteryThreshold,
                    (val) => simPro.updateLowBatteryThreshold(val),
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildSliderRow(
                    'High Grid Import',
                    '${simPro.highGridImportThreshold.toStringAsFixed(1)} kW',
                    simPro.highGridImportThreshold / 10.0,
                    (val) => simPro.updateHighGridImportThreshold(val * 10.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildToggleRow(
                    'Push Notifications',
                    simPro.pushNotificationsEnabled,
                    Icons.notifications_active,
                    (val) => simPro.togglePushNotifications(val),
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildToggleRow(
                    'Daily Summary Email',
                    simPro.emailSummaryEnabled,
                    Icons.email,
                    (val) => simPro.toggleEmailSummary(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'System Management',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.errorRed, width: 1),
              ),
              color: AppTheme.errorRed.withAlpha(
                10,
              ), // Very light transparent red
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restore, color: AppTheme.errorRed),
                ),
                title: const Text(
                  'Reset Simulation Data',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.errorRed,
                  ),
                ),
                subtitle: const Text(
                  'Clears all logs and charts',
                  style: TextStyle(color: Color(0xFFDC2626)),
                ),
                onTap: () => _showResetDialog(context, simPro),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFD1D5DB),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 36, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alex Johnson',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Pro User',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.warningOrange.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: AppTheme.warningOrange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppTheme.primaryBlue,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: child,
      ),
    );
  }

  Widget _buildSliderRow(
    String title,
    String value,
    double sliderValue,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 20,
            child: Slider(
              value: sliderValue,
              activeColor: AppTheme.primaryBlue,
              inactiveColor: const Color(0xFFF3F4F6),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(
    String title,
    bool value,
    IconData icon,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF4B5563)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: Switch(
        value: value,
        activeThumbColor: Colors.white,
        activeTrackColor: AppTheme.primaryBlue,
        onChanged: onChanged,
      ),
    );
  }

  void _showResetDialog(BuildContext context, SimulationProvider simPro) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Simulation?'),
        content: const Text('This will clear all alerts and analytics data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              simPro.resetSimulation();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulation Reset Successful')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
