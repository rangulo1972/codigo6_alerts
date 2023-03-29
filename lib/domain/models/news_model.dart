//! creación de la clase del tipo NewsModel para poder trabajar con ello
//! aprovechando el uso de los formatos .fromJson y toJson
//! Este modelo será usado en api_service.dart para interactuar con el server
class NewsModel {
  NewsModel({
    required this.id,
    required this.link,
    required this.titulo,
    required this.fecha,
    required this.imagen,
  });

  int id;
  String link;
  String titulo;
  String fecha;
  String imagen;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        link: json["link"],
        titulo: json["titulo"],
        fecha: json["fecha"],
        imagen: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "titulo": titulo,
        "fecha": fecha,
        "imagen": imagen,
      };
}
