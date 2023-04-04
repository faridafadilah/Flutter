import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myresto/core/models/foods_mdl.dart';
import 'package:myresto/core/services/food_services.dart';
import 'package:myresto/core/utils/toast_utils.dart';
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
  var fullDescriptionController = TextEditingController();
  var priceController = TextEditingController();

  void imagePick() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = File(_image.path);
      });
    }
  }

  void updateMakanan() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        fullDescriptionController.text.isNotEmpty) {
      FoodModel foodModel = FoodModel(
          title: titleController.text,
          description: descriptionController.text,
          price: int.parse(priceController.text),
          fullDescription: fullDescriptionController.text,
          imageFile:
              image != null ? await MultipartFile.fromFile(image.path) : null);

      FoodResponse response =
          await FoodsServices.updateFood(foodModel, widget.foodModel.id);
      if (response.status == 200) {
        ToastUtils.show(response.message);
        Navigator.pushNamedAndRemoveUntil(
            context, "/dashboard", (Route<dynamic> routes) => false);
      } else {
        ToastUtils.show(response.message);
      }
    } else {
      ToastUtils.show("Field not empty!");
    }
  }

  void loadFoods() {
    setState(() {
      titleController.text = widget.foodModel.title;
      descriptionController.text = widget.foodModel.description;
      fullDescriptionController.text = widget.foodModel.fullDescription;
      priceController.text = widget.foodModel.price.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    var imageProvider =
        image != null ? FileImage(image) : NetworkImage(widget.foodModel.image);
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
                        image: imageProvider,
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
                controller: fullDescriptionController,
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
