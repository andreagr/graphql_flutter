class Mission {
  String? missionName;
  String? details;

  Mission(this.missionName, this.details);

  Mission.fromQuery(Map<String, dynamic> map) {
    this.missionName = map['mission_name'] ?? "No Name";
    this.details = map['details'] ?? "No details";
  }
}
