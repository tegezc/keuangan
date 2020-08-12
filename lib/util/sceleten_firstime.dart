import 'package:flutter/material.dart';

class TgzSkeletonCell extends StatefulWidget {
  final double height;

//  final double width;
  final Widget title;

  TgzSkeletonCell({Key key, this.height = 20, this.title}) : super(key: key);

  createState() => TgzSkeletonCellState();
}

class TgzSkeletonCellState extends State<TgzSkeletonCell>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.title,
      height: widget.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(gradientPosition.value, 0),
              end: Alignment(-1, 0),
              colors: [Colors.black12, Colors.black26, Colors.black12])),
    );
  }
}

class FirtimeSceleton extends StatefulWidget {
  @override
  _FirtimeSceletonState createState() => _FirtimeSceletonState();
}

Widget _cellSceletornTransaksi(){
  return Padding(
    padding: const EdgeInsets.only(right:8.0,left: 8.0),
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Row(
            children: <Widget>[
              TgzSkeletonCell(
                title: Text(
                  'Service Balkon Rumah',
                  style: TextStyle(fontSize: 12, color: Colors.transparent),
                ),
              ),
              Spacer(),
              TgzSkeletonCell(
                title: Text(
                  'Rp 50.000.000.000,-',
                  style: TextStyle(fontSize: 12, color: Colors.transparent),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          TgzSkeletonCell(
            title: Text(
              'Rumah Tangga',
              style: TextStyle(fontSize: 10, color: Colors.transparent),
            ),
          ),
        ],
      ),
    ),
  );
}

class _FirtimeSceletonState extends State<FirtimeSceleton> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Keuangan'),
        ),
        body: Container(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                TgzSkeletonCell(
                  height: 50,
                  title: Text(
                    'Rp 50.000.000.000,-',
                    style: TextStyle(fontSize: 24, color: Colors.transparent),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, left: 8.0, right: 8.0, bottom: 12.0),
                  child: Row(
                    children: <Widget>[
                      TgzSkeletonCell(
                        height: 50,
                        title: Text(
                          'Rp 50.000.000.000,-',
                          style: TextStyle(
                              fontSize: 16, color: Colors.transparent),
                        ),
                      ),
                      Spacer(),
                      TgzSkeletonCell(
                        height: 50,
                        title: Text(
                          'Rp 50.000.000.000,-',
                          style: TextStyle(
                              fontSize: 16, color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
                _cellSceletornTransaksi(),
                _cellSceletornTransaksi(),
                _cellSceletornTransaksi(),
                _cellSceletornTransaksi(),
                _cellSceletornTransaksi(),
              ],
            ),
          ),
        ));
  }
}
