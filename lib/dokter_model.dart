// To parse this JSON data, do
//
//     final dokterModel = dokterModelFromJson(jsonString);

import 'dart:convert';

DokterModel dokterModelFromJson(String str) =>
    DokterModel.fromJson(json.decode(str));

String dokterModelToJson(DokterModel data) => json.encode(data.toJson());

class DokterModel {
  Meta meta;
  List<Datum> data;

  DokterModel({
    required this.meta,
    required this.data,
  });

  factory DokterModel.fromJson(Map<String, dynamic> json) => DokterModel(
        meta: Meta.fromJson(json["meta"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String nama;
  String spesialis;
  int noTelepon;
  String hariPraktik;
  dynamic awalJamPraktik;
  dynamic akhirJamPraktik;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.nama,
    required this.spesialis,
    required this.noTelepon,
    required this.hariPraktik,
    this.awalJamPraktik,
    this.akhirJamPraktik,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nama: json["nama"],
        spesialis: json["spesialis"],
        noTelepon: json["no_telepon"],
        hariPraktik: json["hari_praktik"],
        awalJamPraktik: json["awal_jam_praktik"],
        akhirJamPraktik: json["akhir_jam_praktik"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "spesialis": spesialis,
        "no_telepon": noTelepon,
        "hari_praktik": hariPraktik,
        "awal_jam_praktik": awalJamPraktik,
        "akhir_jam_praktik": akhirJamPraktik,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Meta {
  int code;
  String status;
  String message;

  Meta({
    required this.code,
    required this.status,
    required this.message,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        code: json["code"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
      };
}
