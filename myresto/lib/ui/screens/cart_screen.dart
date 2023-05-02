import 'package:flutter/material.dart';
import 'package:myresto/core/models/cart_mdl.dart';
import 'package:myresto/core/models/history_mdl.dart';
import 'package:myresto/core/services/cart_service.dart';
import 'package:myresto/core/services/history_service.dart';
import 'package:myresto/core/utils/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Cart",
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
      body: CartBody(),
    );
  }
}

class CartBody extends StatefulWidget {
  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  List<CartModel> cartList = [];
  List<TextEditingController> controller;
  int totalPrice = 0;
  String idUser = '';
  String username, email, pathPhoto;

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
      email = pref.getString('email');
      pathPhoto = pref.getString('foto');
    });

    if (username == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/login", (Route<dynamic> routes) => false);
    } else {
      initData();
    }
  }

  //menghitung total harga
  void calculateTotal() {
    setState(() {
      totalPrice = 0;
    });
    if (cartList != null) {
      // add null check
      for (int i = 0; i < cartList.length; i++) {
        int quantity = int.parse(controller[i].text);
        setState(() {
          totalPrice += cartList[i].price * quantity;
        });
      }
    }
  }

  void _deleteCartItem(String id) async {
    try {
      await CartServices.deleteCart(id.toString());
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/carts", (Route<dynamic> routes) => false);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _updateToCart(int quantitys, String id) async {
    print(quantitys);

    try {
      CartRequest cartRequest = CartRequest(
        quantity: quantitys,
      );

      CartResponse response = await CartServices.updateCart(cartRequest, id);
      if (response != null) {
        setState(() {
          // jika update cart berhasil, ubah state quantity menjadi quantity yang baru
          cartList
              .firstWhere((cartItem) => cartItem.idFood.toString() == id)
              .quantity = quantitys;
        });
      } else {
        print("Update cart failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

// mengurangi quantity
  void decreaseQuantity(int index) async {
    int oldValue = int.parse(controller[index].text);

    //jika jumlah quantity 0 tidak bisa dikurangi
    if (oldValue > 0) {
      setState(() {
        controller[index].text = (oldValue - 1).toString();
        cartList[index].quantity -= 1;
      });
      _updateToCart(cartList[index].quantity, cartList[index].id.toString());
    }
    if (cartList[index].quantity == 0) {
      _deleteCartItem(cartList[index].id.toString());
      cartList.removeAt(index);
      controller.removeAt(index);
    }

    if (cartList[index].quantity == 0) {
      if (index >= 0 && index < cartList.length && index < controller.length) {
        _deleteCartItem(cartList[index].id.toString());
        cartList.removeAt(index);
        controller.removeAt(index);
      }
    }

    calculateTotal();
  }

// menambah quantity
  void increaseQuantity(int index) async {
    int oldValue = int.parse(controller[index].text);

    setState(() {
      controller[index].text = (oldValue + 1).toString();
      cartList[index].quantity += 1;
    });

    _updateToCart(cartList[index].quantity, cartList[index].id.toString());

    calculateTotal();
  }

  //inisialisasi controller list
  void initController() {
    controller = new List<TextEditingController>();
    if (cartList != null) {
      for (int i = 0; i < cartList.length; i++) {
        controller.add(TextEditingController());
        controller[i].text = cartList[i].quantity.toString();
      }
    }
  }

  void initData() async {
    try {
      cartList = await CartServices.getAll(
          idUser.toString()); // replace 1 with user ID
      initController();
      calculateTotal();
    } catch (e) {
      print(e.toString());
    }
  }

  void _addHistory(
      String foodId, String userId, int total, int count, int index) async {
    print("${foodId}, ${userId}, ${total}, ${count}");
    HistoryRequest historyRequest = HistoryRequest(
        count: count,
        foodId: int.parse(foodId),
        userId: int.parse(userId),
        totalPrice: total);
    HistoryResponse response = await HistoryService.addHistory(historyRequest);
    if (response.status == 201) {
      ToastUtils.show(response.message);
      _deleteCartItem(cartList[index].id.toString());
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/history", (Route<dynamic> routes) => false);
      });
    } else {
      ToastUtils.show(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total Harga",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp ${totalPrice.toString()}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _itemList(),
        ],
      ),
    );
  }

  Widget _itemList() {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        ListView.builder(
          itemCount: cartList?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var cart = cartList[index];
            return Column(
              children: <Widget>[
                Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 64,
                                height: 64,
                                child: Image.network(
                                  cart.photoFood,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    cart.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "${cart.quantity.toString()} x Rp ${cart.price.toString()}",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black54),
                                  )
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(height: 45),
                              Text(
                                "Rp ${(cart.price * cart.quantity).toString()}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 32,
                                    height: 20,
                                    child: RaisedButton(
                                      color: Colors.red,
                                      onPressed: () => decreaseQuantity(index),
                                      padding: EdgeInsets.all(0),
                                      child: Icon(
                                        Icons.minimize,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    width: 32,
                                    height: 20,
                                    child: TextField(
                                      readOnly: true,
                                      controller: controller[index],
                                      textInputAction: TextInputAction.go,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          hintText: "0",
                                          contentPadding:
                                              EdgeInsets.only(bottom: 10)),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    width: 32,
                                    height: 20,
                                    child: RaisedButton(
                                      color: Colors.green,
                                      onPressed: () => increaseQuantity(index),
                                      padding: EdgeInsets.all(0),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      10), // tambahan untuk memberikan jarak antara dua widget
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => _addHistory(cart.idFood, idUser,
                        (cart.price * cart.quantity), cart.quantity, index),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Checkout Rp:',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          (cart.price * cart.quantity).toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ]),
    );
  }
}
