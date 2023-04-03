import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myresto/core/models/foods_mdl.dart';
import 'package:myresto/core/services/food_services.dart';
import 'package:myresto/ui/widgets/custom_textfield.dart';

class UpdateScreen extends StatelessWidget {
  FoodModel foodModel;
  UpdateScreen({this.foodModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Update Food"),
      ),
      body: UpdateFood(foodModel: foodModel),
    );
  }
}

class UpdateFood extends StatefulWidget {
  FoodModel foodModel;
  UpdateFood({this.foodModel});

  @override
  _UpdateFoodState createState() => _UpdateFoodState();
}

class _UpdateFoodState extends State<UpdateFood> {
  File image;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var fullDescriptionControlelr = TextEditingController();
  var priceController = TextEditingController();

  void imagePick() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = _image;
      });
    }
  }

  void updateMakanan() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        fullDescriptionControlelr.text.isNotEmpty) {
      FoodModel foodModel = FoodModel(
        title: titleController.text,
        description: descriptionController.text,
        price: int.parse(priceController.text),
        fullDescription: fullDescriptionControlelr.text,
        image: image != null
            ? base64Encode(image.readAsBytesSync())
            : widget.foodModel.image,
      );

      var result = await FoodsServices.update(foodModel, widget.foodModel.id);

      if (result) {
        Fluttertoast.showToast(
            msg: "Successfully! update food.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> routes) => false);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed! update food.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Field not empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void loadFood() {
    setState(() {
      titleController.text = widget.foodModel.title;
      descriptionController.text = widget.foodModel.description;
      fullDescriptionControlelr.text = widget.foodModel.fullDescription;
      priceController.text = widget.foodModel.price.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadFood();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                child: InkWell(
                  onTap: () => imagePick(),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: image != null
                            ? FileImage(image)
                            : MemoryImage(base64Decode(widget.foodModel.image)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: image == null
                        ? Icon(Icons.add_photo_alternate,
                            color: Colors.pinkAccent, size: 40)
                        : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: titleController,
                hinText: 'Nama Makanan'),
            SizedBox(height: 10),
            CustomTextField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: descriptionController,
                hinText: 'Deskripsi'),
            SizedBox(height: 10),
            CustomTextField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: fullDescriptionControlelr,
                hinText: 'Full Deskripsi'),
            SizedBox(height: 10),
            CustomTextField(
                action: TextInputAction.done,
                type: TextInputType.number,
                controller: priceController,
                hinText: 'Harga'),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () => updateMakanan(),
                color: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Add Foods',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
