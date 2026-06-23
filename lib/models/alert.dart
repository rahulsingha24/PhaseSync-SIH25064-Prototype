enum AlertType { info, warning, error, resolved }

class Alert {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final AlertType type;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}
