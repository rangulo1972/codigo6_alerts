//! creación de la clase del tipo UserModel para poder trabajar con ello
//! aprovechando el uso de los formatos .fromJson y toJson
//! Este modelo será usado en api_service.dart para interactuar con el server
class UserModel {
  UserModel({
    required this.id,
    required this.nombreCompleto,
    required this.dni,
    required this.telefono,
    required this.direccion,
  });

  int id;
  String nombreCompleto;
  String dni;
  String telefono;
  String direccion;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nombreCompleto: json["nombreCompleto"],
        dni: json["dni"],
        telefono: json["telefono"],
        direccion: json["direccion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreCompleto": nombreCompleto,
        "dni": dni,
        "telefono": telefono,
        "direccion": direccion,
      };
}
