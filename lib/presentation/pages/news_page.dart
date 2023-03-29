import 'package:alerts/data/services/api_service.dart';
import 'package:alerts/domain/models/news_model.dart';
import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/pages/news_form_page.dart';
import 'package:flutter/material.dart';
import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/widgets/general_widget.dart';

class NewsPage extends StatefulWidget {
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  //! instanciamos objeto del tipo ApiService para poder llamar
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBrandPrimaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsFormPage(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                H2(
                  text: "Noticias",
                ),
                spacing12Height,
                FutureBuilder(
                  future: apiService.getNews(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      //! capturamos los datos que nos trae el FutureBuilder
                      //! que es una lista del tipo NewsModel
                      List<NewsModel> news = snapshot.data;
                      //? para que se muestren las noticias desde el último ingresado
                      news = news.reversed.toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: news.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12,
                                    color: Colors.black.withOpacity(0.06),
                                    offset: const Offset(4, 4),
                                  ),
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    news[index].imagen,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                spacing12Width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      H5(
                                        text: news[index].titulo,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 2,
                                        textOverFlow: TextOverflow.ellipsis,
                                      ),
                                      H5(
                                        text: news[index].fecha.toString(),
                                        fontWeight: FontWeight.w500,
                                        textOverFlow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return H5(
                        text: snapshot.error.toString(),
                      );
                    }
                    return loadingWidget;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
