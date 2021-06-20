class ModelLocation {
  final String id;
  final String currentLocation;
  final String workLocation;
  final String homeLocation;
  String selectedLocation;

  ModelLocation(
      {this.workLocation, this.homeLocation, this.id, this.currentLocation});
}
