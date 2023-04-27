import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myresto/core/models/favorite_mdl.dart';
import 'package:myresto/core/models/foods_mdl.dart';
import 'package:myresto/core/services/favorite_service.dart';
import 'package:myresto/core/services/food_services.dart';
import 'package:myresto/ui/screens/foods/add_screen.dart';
import 'package:myresto/ui/screens/foods/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Restofood"),
        leading: Icon(
          Icons.fastfood,
          color: Colors.white,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddScreen())),
                child: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
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
                "Daftar Makanan & Minuman",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              //Widget daftar makanan
              ListFood(),
            ],
          ),
        ));
  }
}

class ListFood extends StatefulWidget {
  @override
  _ListFoodState createState() => _ListFoodState();
}

class _ListFoodState extends State<ListFood> {
  final ScrollController _scrollController = ScrollController();
  //Instance data foods
  List<FoodModel> foods = [];
  List<FoodModel> searchResult = [];
  TextEditingController searchController = TextEditingController();
  double _currentSliderValue = 5.0;
  double _currentSliderMinValue = 1.0;
  double _currentMinPriceValue = 10000;
  double _currentMaxPriceValue = 100000;
  bool _isFavorite = false;
  bool _showMoreFilters = false;

  int _page = 0;
  bool _error = false;
  bool _loading = true;
  int _limit = 5;
  bool _hasNextPage = true;

  String idUser = '';
  String username;

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
      _scrollController.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        _hasNextPage) {
      loadData();
    }
  }

  //Function load data
  void loadData() async {
    try {
      var _foods = await FoodsServices.getAll(
          _page,
          _limit,
          _currentMinPriceValue,
          _currentMaxPriceValue,
          _isFavorite,
          _currentSliderMinValue,
          _currentSliderValue,
          searchController.text);
      setState(() {
        foods = _foods;
        _loading = false;
      });
      // if (mounted) {
      //   setState(() {
      //     foods.addAll(_foods);
      //     _page++;
      //     _loading = false;
      //     _hasNextPage = foods.length == _limit;
      //   });
      // }
    } catch (e) {
      print("error --> $e");
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to load history'),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Widget errorDialog({double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          FlatButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  loadData();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (foods == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Visibility(
            visible: _showMoreFilters,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search Food",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      loadData();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Filter by rating',
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.star, color: Colors.black87),
                        ],
                      ),
                      RangeSlider(
                        values: RangeValues(
                            _currentSliderMinValue, _currentSliderValue),
                        min: 1.0,
                        max: 5.0,
                        divisions: 10,
                        labels: RangeLabels(
                          _currentSliderMinValue.toString(),
                          _currentSliderValue.toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentSliderMinValue = values.start;
                            _currentSliderValue = values.end;
                          });
                          loadData();
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Filter by Price'),
                      Text(
                          'Rp. $_currentMinPriceValue - Rp. $_currentMaxPriceValue'),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(
                        _currentMinPriceValue, _currentMaxPriceValue),
                    min: 10000,
                    max: 100000,
                    divisions: 10,
                    labels: RangeLabels(
                      _currentMinPriceValue.toString(),
                      _currentMaxPriceValue.toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentMinPriceValue = values.start;
                        _currentMaxPriceValue = values.end;
                      });
                      loadData();
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Show only favorites'),
                    value: _isFavorite,
                    onChanged: (bool value) {
                      setState(() {
                        _isFavorite = value;
                      });
                      loadData();
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showMoreFilters = !_showMoreFilters;
                    });
                  },
                  child: _showMoreFilters
                      ? Text("Back")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'Filter Pencarian',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: foods.length + (_loading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == foods.length) {
                if (_error) {
                  return Center(child: errorDialog(size: 15));
                } else {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ));
                }
              }
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
                                  foodId: foods[index].id,
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
                              foods[index].image,
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
                                foods[index].title,
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
                                  foods[index].description,
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
                                    "Rp ${foods[index].price.toString()}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: foods[index].favorite == 'true'
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.favorite,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                    onPressed: () async {
                                      String foodId =
                                          foods[index].id.toString();
                                      String userId = idUser;
                                      bool favorite =
                                          foods[index].favorite == 'true'
                                              ? false
                                              : true;
                                      FavRequest favModel = FavRequest(
                                        userId: int.parse(userId),
                                        foodId: int.parse(foodId),
                                        favorite: favorite,
                                      );
                                      try {
                                        List<FavoriteModel> favs =
                                            await FavoriteService.getAllFav(
                                                userId);
                                        FavoriteModel fav = favs.firstWhere(
                                            (fav) => fav.foodId == foodId,
                                            orElse: () => null);
                                        if (fav != null) {
                                          String favId =
                                              fav.idFavorite.toString();
                                          await FavoriteService.updateCart(
                                              favModel, favId);
                                        }
                                        setState(() {
                                          foods[index].favorite =
                                              favorite.toString();
                                        });
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
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
