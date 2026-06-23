import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';
import '../models/load_appliance.dart';
import '../theme.dart';

class ControlPanelScreen extends StatelessWidget {
  const ControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final simPro = Provider.of<SimulationProvider>(context);

    // Calculate slider value (0.0 to 1.0) based on an assumed 10kW max house load
    double consumptionRatio = (simPro.totalLoadKw / 10.0).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Load Control Center',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 16.0,
              bottom: 180.0,
            ), // Padding for bottom block
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SYSTEM MODE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Active: ${simPro.systemMode}',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildModeSelector(context, simPro),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Load Management',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Manage Schedules coming soon...'),
                          ),
                        );
                      },
                      child: const Text(
                        'Manage Schedules',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...simPro.appliances.map(
                  (appliance) =>
                      _buildApplianceTile(context, simPro, appliance),
                ),
              ],
            ),
          ),

          // Fixed Bottom Consumption Block
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withAlpha(76),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Consumption',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                simPro.totalLoadKw.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'kW',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: consumptionRatio,
                      minHeight: 8,
                      backgroundColor: Colors.black.withAlpha(51),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Low Usage',
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'High Usage',
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(BuildContext context, SimulationProvider simPro) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFFF3F4F6,
        ), // Light gray background for the segmented control
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildSegmentButton(
            context,
            simPro,
            label: 'Auto',
            icon: Icons.flash_auto,
            modeValue: 'Auto',
            activeColor: AppTheme.primaryBlue,
          ),
          _buildSegmentButton(
            context,
            simPro,
            label: 'Battery',
            icon: Icons.battery_charging_full,
            modeValue: 'Battery Mode',
            activeColor: const Color(0xFF4B5563),
          ),
          _buildSegmentButton(
            context,
            simPro,
            label: 'Grid Only',
            icon: Icons.grid_view_rounded,
            modeValue: 'Grid Mode',
            activeColor: const Color(0xFF4B5563),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    BuildContext context,
    SimulationProvider simPro, {
    required String label,
    required IconData icon,
    required String modeValue,
    required Color activeColor,
  }) {
    bool isSelected = simPro.systemMode == modeValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => simPro.setSystemMode(modeValue),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? activeColor : const Color(0xFF6B7280),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? activeColor : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplianceTile(
    BuildContext context,
    SimulationProvider simPro,
    LoadAppliance appliance,
  ) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (appliance.id) {
      case 'ac':
        iconData = Icons.ac_unit;
        iconColor = AppTheme.primaryBlue;
        bgColor = AppTheme.primaryBlue.withAlpha(26);
        break;
      case 'wh':
        iconData = Icons.fireplace; // Matches mockup visual better
        iconColor = AppTheme.warningOrange;
        bgColor = AppTheme.warningOrange.withAlpha(26);
        break;
      case 'pp':
        iconData = Icons.pool;
        iconColor = const Color(0xFF06B6D4); // Cyan
        bgColor = const Color(0xFF06B6D4).withAlpha(26);
        break;
      case 'light':
        iconData = Icons.lightbulb;
        iconColor = AppTheme.warningOrange;
        bgColor = const Color(0xFFFEF3C7);
        break;
      default:
        iconData = Icons.power;
        iconColor = Colors.grey;
        bgColor = Colors.grey.withAlpha(26);
    }

    // Force inactive icon color to gray but keep background slightly tinted
    if (!appliance.isActive) {
      iconColor = const Color(0xFF9CA3AF);
      bgColor = const Color(0xFFF3F4F6);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(iconData, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appliance.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    appliance.description,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        size: 12,
                        color: appliance.isActive
                            ? AppTheme.primaryBlue
                            : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${appliance.powerRatingKw.toStringAsFixed(1)} kW',
                        style: TextStyle(
                          color: appliance.isActive
                              ? AppTheme.primaryBlue
                              : const Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: appliance.isActive,
              activeThumbColor: Colors.white,
              activeTrackColor: AppTheme.primaryBlue,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD1D5DB),
              onChanged: (val) {
                simPro.toggleAppliance(appliance.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
