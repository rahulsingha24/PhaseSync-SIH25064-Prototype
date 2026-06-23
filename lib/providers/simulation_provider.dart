import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import '../models/alert.dart';
import '../models/load_appliance.dart';

class SimulationProvider with ChangeNotifier {
  // Time and Modes
  bool isDayLight = true;
  String systemMode = 'Auto'; // Auto, Battery Mode, Grid Mode

  // Power Generation & Storage
  double solarGenerationKw = 0.0;
  double batterySoc = 50.0; // 0 to 100%
  double batteryVoltage = 50.4;
  bool isBatteryCharging = false;
  double gridPowerKw = 0.0; // Positive = Export, Negative = Import

  // Loads
  List<LoadAppliance> appliances = [
    LoadAppliance(
      id: 'ac',
      name: 'Air Conditioner',
      description: 'Main Hall AC',
      powerRatingKw: 2.0,
    ),
    LoadAppliance(
      id: 'wh',
      name: 'Water Heater',
      description: 'Bathroom Heater',
      powerRatingKw: 3.5,
    ),
    LoadAppliance(
      id: 'pp',
      name: 'Pool Pump',
      description: 'Outdoor',
      powerRatingKw: 1.5,
    ),
    LoadAppliance(
      id: 'light',
      name: 'Lighting',
      description: 'All Rooms',
      powerRatingKw: 0.5,
    ),
  ];

  // Alerts
  List<Alert> alerts = [];

  List<Alert> get recentAlerts {
    return alerts
        .where((a) => DateTime.now().difference(a.timestamp).inHours < 24)
        .toList();
  }

  // Analytics (simple lists for now, to be consumed by charts)
  List<double> solarTrend = [];
  List<double> batteryTrend = [];
  List<double> loadTrend = [];

  // Settings / Preferences
  double lowBatteryThreshold = 0.2; // 20%
  double highGridImportThreshold = 5.0; // 5.0 kW
  bool pushNotificationsEnabled = true;
  bool emailSummaryEnabled = false;

  Timer? _simulationTimer;
  final Random _random = Random();

  SimulationProvider() {
    _startSimulation();
  }

  double get totalLoadKw {
    return appliances
        .where((a) => a.isActive)
        .fold(0.0, (sum, a) => sum + a.powerRatingKw);
  }

  void _startSimulation() {
    _calculateTick(); // Initial tick
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _calculateTick();
    });
  }

  void toggleDayNight() {
    isDayLight = !isDayLight;
    notifyListeners();
    // Simulating sudden change, immediate effect
    _calculateTick();
  }

  void setSystemMode(String mode) {
    systemMode = mode;
    notifyListeners();
    _calculateTick();
  }

  void toggleAppliance(String id) {
    final index = appliances.indexWhere((a) => a.id == id);
    if (index != -1) {
      appliances[index].isActive = !appliances[index].isActive;
      notifyListeners();
      _calculateTick();
    }
  }

  void addAlert(String title, String desc, AlertType type) {
    if (!pushNotificationsEnabled &&
        (type == AlertType.info || type == AlertType.resolved)) {
      return;
    }
    final newAlert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: desc,
      timestamp: DateTime.now(),
      type: type,
    );
    alerts.insert(0, newAlert);
    if (alerts.length > 50) alerts.removeLast(); // Limit alert history
    notifyListeners();
  }

  void updateLowBatteryThreshold(double value) {
    lowBatteryThreshold = value;
    notifyListeners();
  }

  void updateHighGridImportThreshold(double value) {
    highGridImportThreshold = value;
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    pushNotificationsEnabled = value;
    notifyListeners();
  }

  void toggleEmailSummary(bool value) {
    emailSummaryEnabled = value;
    notifyListeners();
  }

  void _calculateTick() {
    // 1. Calculate Solar
    if (isDayLight) {
      // Simulate random generation between 2.0 and 6.0 kW
      solarGenerationKw = 2.0 + _random.nextDouble() * 4.0;
      // Add slight occasional dropout
      if (_random.nextDouble() > 0.95) {
        addAlert(
          "Solar Drop",
          "Unexpected dip in solar generation.",
          AlertType.info,
        );
        solarGenerationKw = 0.5;
      }
    } else {
      solarGenerationKw = 0.0;
    }

    // 2. Calculate Load
    double currentLoadKw = totalLoadKw;

    // 3. Energy Balance Logic
    double netPower = solarGenerationKw - currentLoadKw;

    if (netPower > 0) {
      // Excess solar
      if (batterySoc < 100.0) {
        // Charge battery
        isBatteryCharging = true;
        // Let's assume netPower kW adds some % every 3 seconds for simulation speed
        batterySoc += netPower * 0.2;
        if (batterySoc >= 100.0) {
          batterySoc = 100.0;
          gridPowerKw = netPower; // Export excess
        } else {
          gridPowerKw = 0.0;
        }
      } else {
        isBatteryCharging = false;
        gridPowerKw = netPower; // Export
      }
    } else {
      // Deficit
      isBatteryCharging = false;
      double deficit = -netPower;

      if (batterySoc > 5.0 &&
          (systemMode == 'Auto' || systemMode == 'Battery Mode')) {
        // Discharge battery
        batterySoc -= deficit * 0.2;
        gridPowerKw = 0.0;
        if (batterySoc <= 5.0) {
          batterySoc = 5.0; // Empty
        }
      } else {
        // Import from Grid
        gridPowerKw = -deficit;
      }
    }

    // Update Battery Voltage (simulated relationship with SOC)
    batteryVoltage = 48.0 + (batterySoc / 100.0) * 6.0;

    // Alert Checks
    if (batterySoc < 20.0 &&
        !alerts.any(
          (a) =>
              a.title == "Low Battery" &&
              DateTime.now().difference(a.timestamp).inMinutes < 1,
        )) {
      addAlert("Low Battery", "Battery SOC is below 20%.", AlertType.warning);
    }

    // Auto-mode simulation magic
    if (systemMode == 'Auto' &&
        currentLoadKw > solarGenerationKw &&
        batterySoc < 30.0) {
      // If running out of juice and in auto mode, forcefully turn off heavy load
      final heavyLoad = appliances
          .where((a) => a.isActive && a.powerRatingKw >= 2.0)
          .firstOrNull;
      if (heavyLoad != null) {
        heavyLoad.isActive = false;
        addAlert(
          "Load Optimized",
          "Turned off ${heavyLoad.name} to preserve power.",
          AlertType.resolved,
        );
      }
    }

    // Update Analytics data
    solarTrend.add(solarGenerationKw);
    batteryTrend.add(batterySoc);
    loadTrend.add(currentLoadKw);

    // Keep trends limited for demo to avoid memory leaks
    if (solarTrend.length > 100) solarTrend.removeAt(0);
    if (batteryTrend.length > 100) batteryTrend.removeAt(0);
    if (loadTrend.length > 100) loadTrend.removeAt(0);

    notifyListeners();
  }

  void resetSimulation() {
    alerts.clear();
    solarTrend.clear();
    batteryTrend.clear();
    loadTrend.clear();
    // Reset basic state optionally
    batterySoc = 50.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
