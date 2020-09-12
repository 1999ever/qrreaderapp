// import 'dart:convert';

// ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

// String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {

  int id;
  String tipo;
  String valor;

  ScanModel({
    this.id,
    this.tipo,
    this.valor,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
    id   : json["id"],
    tipo : json["tipo"],
    valor: json["valor"],
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "tipo" : tipo,
    "valor": valor,
  };
  
}
