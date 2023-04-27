import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myresto/core/models/history_mdl.dart';
import 'package:myresto/core/models/ulasan_mdl.dart';
import 'package:myresto/core/services/history_service.dart';
import 'package:myresto/core/services/ulasan_service.dart';
import 'package:myresto/core/utils/toast_utils.dart';
import 'package:myresto/ui/screens/history/add_ulasan_screen.dart';

class DetailHistoryScreen extends StatefulWidget {
  String historyId;
  DetailHistoryScreen({this.historyId});

  @override
  _DetailHistoryScreenState createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  void deleteHistory() async {
    print(widget.historyId.toString());
    bool response =
        await HistoryService.deleteHistory(widget.historyId.toString());
    if (response == true) {
      ToastUtils.show("History deleted!");
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/history", (Route<dynamic> routes) => false);
      });
    } else {
      ToastUtils.show("History Failed Delete!");
    }
  }

  HistoryModel historyModel;
  UlasanModel ulasanModel;

  @override
  void initState() {
    super.initState();
    initData();
    dataUlasan();
  }

  initData() async {
    HistoryModel response = await HistoryService.getById(widget.historyId);
    setState(() {
      historyModel = response;
    });
  }

  dataUlasan() async {
    UlasanModel response = await UlasanService.getById(widget.historyId);
    if (response != null) {
      setState(() {
        ulasanModel = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(historyModel?.title ?? ''),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => deleteHistory(),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: DetailHistory(
        histories: historyModel,
        ulasanModel: ulasanModel,
      ),
    );
  }
}

class DetailHistory extends StatefulWidget {
  HistoryModel histories;
  UlasanModel ulasanModel;
  DetailHistory({this.histories, this.ulasanModel});

  @override
  _DetailHistorysState createState() => _DetailHistorysState();
}

class _DetailHistorysState extends State<DetailHistory> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //bagian untuk meload gambar
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
                child: Image.network(
                  widget.histories?.image ??
                      "", // use the null-conditional operator to check if widget.foodModel is null
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Transaction",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 13),
                          Visibility(
                              visible: widget.histories?.tanggal != null,
                              child: Text(
                                "Tanggal Pesanan: " +
                                        widget.histories?.tanggal.toString() ??
                                    '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              )),
                          SizedBox(height: 8),
                          Visibility(
                              visible: widget.histories?.title != null,
                              child: Text(
                                "Nama Makanan: " +
                                        widget.histories?.title.toString() ??
                                    '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              )),
                          SizedBox(height: 8),
                          Visibility(
                              visible: widget.histories?.count != null,
                              child: Text(
                                "Count: " +
                                        widget.histories?.count.toString() ??
                                    '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              )),
                          SizedBox(height: 8),
                          Visibility(
                              visible: widget.histories?.price != null,
                              child: Text(
                                "Harga: " +
                                        widget.histories?.price.toString() ??
                                    '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              )),
                          SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Total Bayar: Rp ${widget.histories?.totalPrice.toString() ?? 0}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          widget.ulasanModel != null &&
                  widget.ulasanModel.rating != null &&
                  widget.ulasanModel.comment != null
              ? Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        "Review Anda",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                      Card(
                        elevation: 2,
                        child: RatingBar.builder(
                          initialRating: widget.ulasanModel?.rating ?? 0.0,
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
                      ),
                      SizedBox(height: 8),
                      Text(widget.ulasanModel?.comment ?? '')
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUlasanScreen(
                              foodId: widget.histories.foodId,
                              userId: widget.histories.userId,
                              historyId: widget.histories.id),
                        ),
                      );
                    },
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
                          'Review Makanan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
