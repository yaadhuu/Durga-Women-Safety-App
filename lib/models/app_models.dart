import 'dart:convert';

class Contact {
  final String id;
  final String name;
  final String phone;
  final String? relation;

  Contact({required this.id, required this.name, required this.phone, this.relation});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'relation': relation,
    };
  }
}

class SOSAlert {
  final String id;
  final bool isActive;
  final DateTime createdAt;

  SOSAlert({required this.id, required this.isActive, required this.createdAt});

  factory SOSAlert.fromJson(Map<String, dynamic> json) {
    return SOSAlert(
      id: json['id'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ThreatResponse {
  final String riskLevel;
  final String color;

  ThreatResponse({required this.riskLevel, required this.color});

  factory ThreatResponse.fromJson(Map<String, dynamic> json) {
    return ThreatResponse(
      riskLevel: json['risk_level'],
      color: json['color'],
    );
  }
}
