import 'package:flutter/material.dart';
import 'package:myresto/core/models/foods_mdl.dart';
import 'package:myresto/core/models/history_mdl.dart';
import 'package:myresto/core/services/history_service.dart';
import 'package:myresto/ui/screens/history/detail_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "History",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, "/dashboard", (Route<dynamic> routes) => false),
        ),
      ),
      body: HistoryBody(),
    );
  }
}

class HistoryBody extends StatelessWidget {
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
                "History Transaction",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              //Widget daftar makanan
              ListHistory()
            ],
          ),
        ));
  }
}

class ListHistory extends StatefulWidget {
  @override
  _ListHistoryState createState() => _ListHistoryState();
}

class _ListHistoryState extends State<ListHistory> {
  final ScrollController _scrollController = ScrollController();
  List<HistoryModel> histories = [];
  int _page = 0;
  bool _error = false;
  bool _loading = true;
  int _limit = 6;
  bool _hasNextPage = true;

  String idUser = '';
  String username;

  @override
  void initState() {
    super.initState();
    getPref();
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

  void loadData() async {
    try {
      var _history =
          await HistoryService.getAll(idUser.toString(), _page, _limit);
      if (mounted) {
        setState(() {
          histories.addAll(_history);
          _page++;
          _loading = false;
          _hasNextPage = histories.length == _limit;
        });
      }
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
    if (histories == null && histories.isEmpty) {
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
            itemCount: histories.length + (_loading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == histories.length - _limit) {
                loadData();
              }
              if (index == histories.length) {
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
                            builder: (context) => DetailHistoryScreen(
                                  historyId: histories[index].id,
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
                              histories[index].image,
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
                                histories[index].title,
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
                                  histories[index].tanggal.toString(),
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
                                    "Rp ${histories[index].totalPrice.toString()}",
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
