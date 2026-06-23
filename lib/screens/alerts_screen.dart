import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';
import '../models/alert.dart';
import '../theme.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final simPro = Provider.of<SimulationProvider>(context);

    // Filter alerts based on selection
    List<Alert> displayedAlerts = simPro.alerts;
    if (_selectedFilter != 'All') {
      displayedAlerts = simPro.alerts.where((a) {
        if (_selectedFilter == 'Warnings' && a.type == AlertType.warning) {
          return true;
        }
        if (_selectedFilter == 'Errors' && a.type == AlertType.error) {
          return true;
        }
        if (_selectedFilter == 'Info' && a.type == AlertType.info) {
          return true;
        }
        if (_selectedFilter == 'Resolved' && a.type == AlertType.resolved) {
          return true;
        }
        return false;
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'System Alerts & Logs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: displayedAlerts.isEmpty
                ? const Center(
                    child: Text(
                      'No alerts found for this filter.',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: displayedAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = displayedAlerts[index];
                      // Different style for recent unresolved vs older logs
                      if (alert.type == AlertType.warning ||
                          alert.type == AlertType.error) {
                        return _buildActiveWarningCard(context, alert);
                      } else {
                        return _buildLogListTile(context, alert);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Warnings', 'Errors', 'Info', 'Resolved'];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              }
            },
            backgroundColor: Colors.white,
            selectedColor: AppTheme.primaryBlue.withAlpha(26),
            labelStyle: TextStyle(
              color: isSelected
                  ? AppTheme.primaryBlue
                  : const Color(0xFF4B5563),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.primaryBlue.withAlpha(76)
                    : const Color(0xFFD1D5DB),
              ),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildActiveWarningCard(BuildContext context, Alert alert) {
    Color alertColor = alert.type == AlertType.error
        ? AppTheme.errorRed
        : AppTheme.warningOrange;
    IconData icon = alert.type == AlertType.error
        ? Icons.error_outline
        : Icons.warning_amber_rounded;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior:
          Clip.antiAlias, // To ensure border radius applies to the side border
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color border indicator
            Container(width: 4, color: alertColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: alertColor, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          alert.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(alert.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      alert.description,
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Alert dismissed'),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF4B5563),
                              side: const BorderSide(color: Color(0xFFD1D5DB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Dismiss'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Action taken for alert'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Take Action'),
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
      ),
    );
  }

  Widget _buildLogListTile(BuildContext context, Alert alert) {
    Color iconColor;
    IconData iconData;
    Color bgColor;

    switch (alert.type) {
      case AlertType.info:
        iconColor = AppTheme.primaryBlue;
        iconData = Icons.info_outline;
        bgColor = AppTheme.primaryBlue.withAlpha(26);
        break;
      case AlertType.resolved:
        iconColor = AppTheme.successGreen;
        iconData = Icons.check_circle_outline;
        bgColor = AppTheme.successGreen.withAlpha(26);
        break;
      default:
        iconColor = const Color(0xFF6B7280);
        iconData = Icons.notifications_none;
        bgColor = const Color(0xFFF3F4F6);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _formatTime(alert.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(color: const Color(0xFFE5E7EB), height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    String period = time.hour >= 12 ? 'PM' : 'AM';
    int displayHour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    return '${displayHour.toString()}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
