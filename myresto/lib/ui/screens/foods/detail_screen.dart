import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myresto/core/models/cart_mdl.dart';
import 'package:myresto/core/models/foods_mdl.dart';
import 'package:myresto/core/models/ulasan_mdl.dart';
import 'package:myresto/core/services/cart_service.dart';
import 'package:myresto/core/services/food_services.dart';
import 'package:myresto/core/services/ulasan_service.dart';
import 'package:myresto/core/utils/toast_utils.dart';
import 'package:myresto/ui/screens/foods/update_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  String foodId;
  DetailScreen({this.foodId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void deleteFood(BuildContext context) async {
    FoodResponse response = await FoodsServices.deleteFood(widget.foodId);
    if (response.status == 200) {
      ToastUtils.show(response.message);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (Route<dynamic> routes) => false);
      });
    } else {
      ToastUtils.show(response.message);
    }
  }

  FoodModel foodModel;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    FoodModel response = await FoodsServices.getById(widget.foodId);
    if (response != null) {
      setState(() {
        foodModel = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(foodModel?.title ?? ''),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateScreen(foodModel: foodModel),
                  )),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () => deleteFood(context),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: DetailBody(foodModel: foodModel),
    );
  }
}

class DetailBody extends StatefulWidget {
  FoodModel foodModel;
  DetailBody({this.foodModel});

  @override
  _DetailBodyState createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  int _quantity = 1;
  String id = '';
  String username, email, pathPhoto;
  List<UlasanModel> ulasan = [];
  double totalRating = 0.0;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      id = pref.getString('id');
      username = pref.getString('username');
      email = pref.getString('email');
      pathPhoto = pref.getString('foto');
    });

    if (username == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/login", (Route<dynamic> routes) => false);
    }
  }

  void _addToCart() async {
    CartRequest cartRequest = CartRequest(
        quantity: _quantity,
        foodId: int.parse(widget.foodModel.id.toString()),
        userId: int.parse(id.toString()));

    CartResponse response = await CartServices.createCart(cartRequest);

    if (response.status == 200) {
      ToastUtils.show(response.message);
    } else {
      ToastUtils.show(response.message);
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getData(String idFood) async {
    if (widget.foodModel != null) {
      var _ulasan = await UlasanService.getAll(idFood);
      setState(() {
        ulasan = _ulasan;
      });
    }
    getAverageRating();
  }

  void getAverageRating() {
    for (var review in ulasan) {
      totalRating += review.rating;
    }
    double averageRating = totalRating / ulasan.length;
    print('Average rating: $averageRating');
    setState(() {
      totalRating = averageRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //bagian untuk meload gambar
          new Stack(
            children: <Widget>[
              new ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
                child: Image.network(
                  widget.foodModel?.image ??
                      "https://media.istockphoto.com/id/1258873084/id/vektor/logo-abstrak-kafe-atau-restoran-sendok-dan-garpu-di-piring-desain-logo-makanan-ilustrasi.jpg?s=1024x1024&w=is&k=20&c=A0qVF4lfjFu60grnEbni7iBaDUdK5Z--h84sUVXBpFI=", // use the null-conditional operator to check if widget.foodModel is null
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.cover,
                ),
              ),
              new Positioned(
                bottom: 20,
                right: 15,
                child: Container(
                  width: 300,
                  color: Colors.black38,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        widget.foodModel?.title ?? '',
                        style: TextStyle(fontSize: 26, color: Colors.white),
                      ),
                      Text(
                        "Harga: Rp ${widget.foodModel?.price ?? ''}",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                      RatingBar.builder(
                        initialRating: totalRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          new SizedBox(
            height: 4,
          ),
          new Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      new Icon(Icons.assignment, size: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: new Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Text(
                    widget.foodModel?.fullDescription ?? '',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: ElevatedButton(
              onPressed: () => _addToCart(),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Tambah',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: ElevatedButton(
              onPressed: () => getData(widget.foodModel.id.toString()),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.reviews, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Lihat Review',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          ulasan.length > 0
              ? Text(
                  "Tampilan Review",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                )
              : Text(
                  " ",
                ),
          SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            itemCount: ulasan.length,
            itemBuilder: (context, index) {
              var review = ulasan != null ? ulasan[index] : [];
              return ListTile(
                title: Text(ulasan[index].username),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar.builder(
                      initialRating: ulasan[index].rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 16,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: null,
                    ),
                    SizedBox(height: 8),
                    Text(ulasan[index].comment),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
