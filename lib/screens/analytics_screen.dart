import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/simulation_provider.dart';
import '../theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedRange = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final simPro = Provider.of<SimulationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Energy Analytics',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRangeSelector(),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeInOutBack,
              switchOutCurve: Curves.easeOut,
              child: _buildEnergyOverviewChart(
                simPro,
                key: ValueKey(_selectedRange),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Solar Yield',
                    '142.5',
                    'kWh',
                    Icons.wb_sunny_outlined,
                    AppTheme.warningOrange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Peak Load',
                    '5.2',
                    'kW',
                    Icons.flash_on,
                    AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Detailed Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBreakdownItem(
              'Self-Sufficiency',
              '85%',
              AppTheme.successGreen,
            ),
            _buildBreakdownItem(
              'Grid Export',
              '24.1 kWh',
              AppTheme.primaryBlue,
            ),
            _buildBreakdownItem(
              'Grid Import',
              '12.4 kWh',
              AppTheme.warningOrange,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24), // Pill shape
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: ['Daily', 'Weekly', 'Monthly'].map((range) {
          bool isSelected = _selectedRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
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
                child: Center(
                  child: Text(
                    range,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.textLight
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyOverviewChart(SimulationProvider simPro, {Key? key}) {
    return Card(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Energy Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFF3F4F6),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                          );
                          String text = '';
                          if (value.toInt() % 5 == 0) {
                            text = '${(value.toInt() + 8) % 24}:00';
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            '${value.toInt()}kW',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _createLineBarData(
                      simPro.solarTrend,
                      AppTheme.warningOrange,
                    ),
                    _createLineBarData(simPro.loadTrend, AppTheme.primaryBlue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Solar Generation', AppTheme.warningOrange),
                const SizedBox(width: 24),
                _buildLegendItem('Consumption', AppTheme.primaryBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _createLineBarData(List<double> rawData, Color color) {
    List<FlSpot> spots = [];
    int maxPoints = 20;

    // Safety check and padding for empty data
    if (rawData.isEmpty) {
      spots = [const FlSpot(0, 0), const FlSpot(1, 0)];
    } else {
      int startIndex = rawData.length > maxPoints
          ? rawData.length - maxPoints
          : 0;
      for (int i = 0; i < maxPoints; i++) {
        if (startIndex + i < rawData.length) {
          spots.add(FlSpot(i.toDouble(), rawData[startIndex + i]));
        } else {
          // If less data than maxPoints, just pad with current/last value
          spots.add(FlSpot(i.toDouble(), rawData.last));
        }
      }
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withAlpha(26), // Very light area fill
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(String label, String value, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
