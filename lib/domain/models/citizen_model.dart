//! clase creada apartir de lo que se obtuvo como modelo de incident_model
//? para tener separado y ordenado los modelos a ser usado en el api_service
//? debe estar relacionado con incident_model.

class CitizenModel {
  CitizenModel({
    required this.nombres,
    required this.dni,
    required this.telefono,
  });

  String nombres;
  String dni;
  String telefono;

  factory CitizenModel.fromJson(Map<String, dynamic> json) => CitizenModel(
        nombres: json["nombres"],
        dni: json["dni"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "dni": dni,
        "telefono": telefono,
      };
}
