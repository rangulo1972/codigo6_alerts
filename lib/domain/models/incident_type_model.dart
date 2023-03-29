//! clase creada apartir de lo que se obtuvo como modelo de incident_model
//? para tener separado y ordenado los modelos a ser usado en el api_service
//? debe estar relacionado con incident_model.
class IncidentTypeModel {
  IncidentTypeModel({
    required this.id,
    required this.value,
    required this.text,
    required this.titulo,
    required this.area,
    required this.nivel,
  });

  int id;
  int value;
  String text;
  String titulo;
  String area;
  String nivel;

  factory IncidentTypeModel.fromJson(Map<String, dynamic> json) =>
      IncidentTypeModel(
        id: json["id"],
        value: json["value"],
        text: json["text"],
        titulo: json["titulo"],
        area: json["area"],
        nivel: json["nivel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "text": text,
        "titulo": titulo,
        "area": area,
        "nivel": nivel,
      };
}
