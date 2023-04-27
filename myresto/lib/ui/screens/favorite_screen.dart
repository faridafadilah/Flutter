import 'package:flutter/material.dart';
import 'package:myresto/core/models/favorite_mdl.dart';
import 'package:myresto/core/models/foods_mdl.dart';
import 'package:myresto/core/services/favorite_service.dart';
import 'package:myresto/core/services/food_services.dart';
import 'package:myresto/ui/screens/foods/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Favorite",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FavoriteBody(),
    );
  }
}

class FavoriteBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Bagian ini untuk itemnya
              Text(
                "Daftar Makanan & Minuman yang disukai",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              //Widget daftar makanan
              ListFavorite()
            ],
          ),
        ));
  }
}

class ListFavorite extends StatefulWidget {
  @override
  _ListFavoriteState createState() => _ListFavoriteState();
}

class _ListFavoriteState extends State<ListFavorite> {
  //Instance data foods
  List<FavoriteModel> favorites = [];
  FoodModel foodModel;
  String idUser = '';
  String username;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      idUser = pref.getString('id');
      username = pref.getString('username');
    });

    if (username == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/login", (Route<dynamic> routes) => false);
    } else {
      loadData();
    }
  }

  //Function load data
  void loadData() async {
    var _favorites = await FavoriteService.getAll(idUser.toString());
    setState(() {
      favorites = _favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (favorites == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              //Menambahkan item list
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 1,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                  foodId: favorites[index].foodId,
                                ))),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Bagian ini tambahkan image, title dan description
                          Container(
                            width: 64,
                            height: 64,
                            child: Image.network(
                              favorites[index].photoFood,
                              fit: BoxFit.cover,
                            ),
                          ),

                          //Memberi jarak
                          SizedBox(width: 10),

                          //Bagian untuk title dan description
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //Title
                              Text(
                                favorites[index].title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),

                              //Memberi jarak
                              SizedBox(
                                height: 5,
                              ),

                              //Description
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  favorites[index].description,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              //Harga
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Rp ${favorites[index].price.toString()}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
