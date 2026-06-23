import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';
import '../theme.dart';
import 'alerts_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final simPro = Provider.of<SimulationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PhaseSync',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Home Dashboard',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textLight.withAlpha(150),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlertsScreen(),
                      ),
                    );
                  },
                ),
                if (simPro.recentAlerts.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppTheme.errorRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            _buildSystemStatusCard(),
            const SizedBox(height: 20),
            _buildTriNodeDiagram(simPro),
            const SizedBox(height: 20),
            _buildSolarCard(simPro),
            const SizedBox(height: 16),
            _buildBatteryCard(simPro),
            const SizedBox(height: 16),
            _buildGridCard(simPro),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SYSTEM STATUS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Optimal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'All Systems Go',
                style: TextStyle(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriNodeDiagram(SimulationProvider simPro) {
    bool isExporting = simPro.gridPowerKw > 0;

    return Card(
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(24.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Connective Lines
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: TriNodeLinesPainter(
                solarActive: simPro.isDayLight,
                batteryActive:
                    simPro.isBatteryCharging ||
                    (!simPro.isBatteryCharging && simPro.batterySoc > 0),
                gridActive: simPro.gridPowerKw.abs() > 0,
                isExporting: isExporting,
              ),
            ),

            // Home Node (Center)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withAlpha(76),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.home, color: Colors.white, size: 36),
              ),
            ),
            // Solar Node (Top)
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.warningOrange.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wb_sunny,
                      color: AppTheme.warningOrange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Solar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            // Battery Node (Bottom Left)
            Align(
              alignment: const Alignment(-0.8, 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.battery_charging_full,
                      color: AppTheme.successGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Battery',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            // Grid Node (Bottom Right)
            Align(
              alignment: const Alignment(0.8, 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Color(0xFF6B7280),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Grid',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolarCard(SimulationProvider simPro) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.warningOrange.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_outlined,
                        color: AppTheme.warningOrange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Solar Generation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningOrange.withAlpha(26),
                    border: Border.all(
                      color: AppTheme.warningOrange.withAlpha(50),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    simPro.isDayLight ? 'Active' : 'Standby',
                    style: const TextStyle(
                      color: AppTheme.warningOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  simPro.solarGenerationKw.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'kW',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              simPro.isDayLight
                  ? 'Currently generating at peak efficiency.'
                  : 'Solar generation is paused.',
              style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryCard(SimulationProvider simPro) {
    Color getBatteryColor(double soc) {
      if (soc > 50) return AppTheme.successGreen;
      if (soc > 20) return AppTheme.warningOrange;
      return AppTheme.errorRed;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: AppTheme.successGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Battery Storage',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: simPro.isBatteryCharging
                        ? AppTheme.successGreen.withAlpha(26)
                        : AppTheme.warningOrange.withAlpha(26),
                    border: Border.all(
                      color: simPro.isBatteryCharging
                          ? AppTheme.successGreen.withAlpha(50)
                          : AppTheme.warningOrange.withAlpha(50),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        simPro.isBatteryCharging
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: simPro.isBatteryCharging
                            ? AppTheme.successGreen
                            : AppTheme.warningOrange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        simPro.isBatteryCharging ? 'Charging' : 'Discharging',
                        style: TextStyle(
                          color: simPro.isBatteryCharging
                              ? AppTheme.successGreen
                              : AppTheme.warningOrange,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      simPro.batterySoc.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Text(
                  '48V System',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: simPro.batterySoc / 100,
                minHeight: 12,
                backgroundColor: const Color(0xFFF3F4F6),
                color: getBatteryColor(simPro.batterySoc),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                simPro.isBatteryCharging
                    ? '~2h 15m to full charge'
                    : '~5h runtime remaining',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(SimulationProvider simPro) {
    bool isExporting = simPro.gridPowerKw > 0;
    double absGridPower = simPro.gridPowerKw.abs();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.electrical_services_rounded,
                        color: AppTheme.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Grid Interaction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withAlpha(26),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withAlpha(50),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isExporting ? 'Exporting' : 'Importing',
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  absGridPower.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'kW',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isExporting
                  ? 'Selling excess energy back to the grid.'
                  : 'Drawing supplemental power from grid.',
              style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class TriNodeLinesPainter extends CustomPainter {
  final bool solarActive;
  final bool batteryActive;
  final bool gridActive;
  final bool isExporting;

  TriNodeLinesPainter({
    required this.solarActive,
    required this.batteryActive,
    required this.gridActive,
    required this.isExporting,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint(Color color) => Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Center point (Home)
    final Offset center = Offset(size.width / 2, size.height / 2);
    // Node approximate centers based on Alignment coordinates in Stack
    final Offset solar = Offset(size.width / 2, 40);
    final Offset battery = Offset(size.width * 0.1, size.height * 0.9);
    final Offset grid = Offset(size.width * 0.9, size.height * 0.9);

    _drawDashedLine(
      canvas,
      center,
      solar,
      dashedPaint(
        solarActive ? AppTheme.warningOrange : const Color(0xFFD1D5DB),
      ),
    );
    _drawDashedLine(
      canvas,
      center,
      battery,
      dashedPaint(
        batteryActive ? AppTheme.successGreen : const Color(0xFFD1D5DB),
      ),
    );

    Color gridColor = const Color(0xFF6B7280);
    if (gridActive) {
      gridColor = isExporting ? AppTheme.successGreen : AppTheme.errorRed;
    }
    _drawDashedLine(canvas, center, grid, dashedPaint(gridColor));
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 6, dashSpace = 6;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;

    double drawn = 36; // Start slightly away from center home icon
    double endPadding = 40; // End slightly away from destination icon

    while (drawn < distance - endPadding) {
      canvas.drawLine(
        Offset(p1.dx + dx * drawn, p1.dy + dy * drawn),
        Offset(
          p1.dx + dx * (drawn + dashWidth),
          p1.dy + dy * (drawn + dashWidth),
        ),
        paint,
      );
      drawn += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
