class CityData {
  final String name;
  final double latitude;
  final double longitude;

  const CityData({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

const availableCities = [
  CityData(name: 'Nouakchott', latitude: 18.0735, longitude: -15.9582),
  CityData(name: 'Aleg', latitude: 17.058, longitude: -13.909),
  CityData(name: 'Rosso', latitude: 16.5138, longitude: -15.805),
  CityData(name: 'Nouadhibou', latitude: 20.9425, longitude: -17.0362),
];

CityData cityByName(String name) {
  return availableCities.firstWhere(
    (city) => city.name.toLowerCase() == name.toLowerCase(),
    orElse: () => availableCities.first,
  );
}
