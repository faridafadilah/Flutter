import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myresto/core/models/ulasan_mdl.dart';
import 'package:myresto/core/services/ulasan_service.dart';
import 'package:myresto/core/utils/toast_utils.dart';

class AddUlasanScreen extends StatelessWidget {
  String foodId, userId, historyId;
  AddUlasanScreen({this.foodId, this.userId, this.historyId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Add Ulasan"),
      ),
      body: AddUlasanBody(
        foodId: foodId,
        userId: userId,
        historyId: historyId,
      ),
    );
  }
}

class AddUlasanBody extends StatefulWidget {
  final String foodId;
  final String userId;
  final String historyId;
  AddUlasanBody({this.foodId, this.userId, this.historyId});

  @override
  _AddBodyUlasanState createState() => _AddBodyUlasanState();
}

class _AddBodyUlasanState extends State<AddUlasanBody> {
  double _rating = 0.0;
  String _comment = '';
  final _formKey = GlobalKey<FormState>();

  void addUlasan(String comment, double rating) async {
    print(
        "${comment}, ${rating}, ${widget.foodId}, ${widget.userId}, ${widget.historyId}");
    if (rating != null && comment != null) {
      UlasanRequest ulasanModel = UlasanRequest(
          comment: comment,
          rating: rating,
          foodId: int.parse(widget.foodId.toString()),
          userId: int.parse(widget.userId.toString()),
          historyId: int.parse(widget.historyId.toString()));

      UlasanResponse response = await UlasanService.addUlasan(ulasanModel);
      if (response.status == 201) {
        ToastUtils.show(response.message);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/history", (Route<dynamic> routes) => false);
        });
      } else {
        ToastUtils.show(response.message);
      }
    } else {
      ToastUtils.show("Field not empty!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Masukkan ulasan makanan Anda ${_rating}',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Harap isi ulasan makanan Anda';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => addUlasan(_comment, _rating),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Ulasan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
