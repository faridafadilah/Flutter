import 'package:flutter/material.dart';
import 'package:myresto/data/food_data.dart';
import 'package:myresto/detail.dart';
import 'package:myresto/model/food.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyResto'),
        backgroundColor: Colors.pinkAccent,
        leading: Icon(
          Icons.fastfood,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(child: HomeBody()),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Daftar Makanan dan Minuman',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ListFood()
        ],
      ),
    );
  }
}

class ListFood extends StatefulWidget {
  @override
  _ListFoodState createState() => _ListFoodState();
}

class _ListFoodState extends State<ListFood> {
  //Membuat object list food
  late List<Food> foods;

  @override
  void initState() {
    super.initState();
    foods = FoodData.getFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Detail(listFood: foods[index])));
              },
              child: Card(
                  elevation: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 64,
                          height: 64,
                          child: Image.asset(
                            "images/${foods[index].image}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                foods[index].name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  foods[index].description,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black45),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}
