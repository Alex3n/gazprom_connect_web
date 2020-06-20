import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gazpromconnectweb/themes/colors.dart';
import 'package:provider/provider.dart';

class MainCollapsingToolbar extends StatefulWidget {
  List <String> headers = ["1", "2,", "3"];
  double expandleHeight = 180.0;

  Widget imageHeader =  Image.asset("assets/teamwin.jpg",
      fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter);
  List <Widget> pages = [
    Text("111"),
    Text("222"),
    Text("333")
  ];
  String titleMain = "Название";
  Widget leadingWidget;

  bool centerTitile = true;

  MainCollapsingToolbar ({ Key key, this.headers, this.pages, this.titleMain,
  this.imageHeader, this.expandleHeight= 180.0, this.leadingWidget, this.centerTitile = true}) : super(key: key);
  @override
  _MainCollapsingToolbarState createState() => _MainCollapsingToolbarState();
}

class _MainCollapsingToolbarState extends State<MainCollapsingToolbar> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: widget.pages.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: widget.leadingWidget,
                expandedHeight: widget.expandleHeight,
                floating: false,
                pinned: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient (begin: Alignment.bottomLeft,end: Alignment.topRight,colors: <Color>[ gazprombanviolet,gazprombankazure])                  ),
                  child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: widget.centerTitile,
                      title: Text(widget.titleMain ,
                          style: Theme.of(context).textTheme.title),
                      background: widget.imageHeader),
                ),
              ),
              SliverPersistentHeader(
                delegate: widget.pages.length > 1 ? _SliverAppBarDelegate(
                  TabBar(
                    indicatorColor: Theme.of(context).accentColor ,
                    unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
                    labelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
                    tabs: stringToTabs(widget.headers),
                  ),
                ) : _SliverSingleTabDelegate(),
                pinned: true,

              ),
            ];
          },
          body:  TabBarView(
            children: widget.pages,
          ),
        ),
    );
  }

  List <Tab> stringToTabs(List <String> _headers) {
    List <Tab> list = List<Tab> ();
    for (var n in _headers) {
      list.add(Tab(text: n));
    }
    return list;
   }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _SliverSingleTabDelegate extends SliverPersistentHeaderDelegate {
  _SliverSingleTabDelegate();


  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: null,
    );
  }

  @override
  bool shouldRebuild(_SliverSingleTabDelegate oldDelegate) {
    return false;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 0;

  @override
  // TODO: implement minExtent
  double get minExtent => 0;
}

