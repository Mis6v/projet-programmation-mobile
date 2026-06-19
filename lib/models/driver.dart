class Driver {
  final String id;
  final String fullName;
  final String phone;
  final String licenseNumber;
  final String vehicleName;
  final String vehiclePlate;
  final bool available;

  const Driver({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.licenseNumber,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.available,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
      vehicleName: json['vehicleName']?.toString() ?? '',
      vehiclePlate: json['vehiclePlate']?.toString() ?? '',
      available: json['available'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'vehicleName': vehicleName,
      'vehiclePlate': vehiclePlate,
      'available': available,
    };
  }
}

class DriverRequest {
  final String fullName;
  final String phone;
  final String licenseNumber;
  final String vehicleName;
  final String vehiclePlate;
  final bool available;

  const DriverRequest({
    required this.fullName,
    required this.phone,
    required this.licenseNumber,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.available,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'vehicleName': vehicleName,
      'vehiclePlate': vehiclePlate,
      'available': available,
    };
  }
}
