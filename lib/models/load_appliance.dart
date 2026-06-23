class LoadAppliance {
  final String id;
  final String name;
  final String description;
  final double powerRatingKw;
  bool isActive;

  LoadAppliance({
    required this.id,
    required this.name,
    required this.description,
    required this.powerRatingKw,
    this.isActive = false,
  });
}
