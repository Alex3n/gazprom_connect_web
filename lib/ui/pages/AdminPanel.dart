import 'package:gazpromconnectweb/ui/pages/AdminDepartment.dart';
import 'package:gazpromconnectweb/ui/pages/AdminEmployees.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AdminNews.dart';

String currentId;
Map<String, Object> currentData = Map();
AdminContent adminContent = AdminContent.news;

enum AdminContent {
  news,
  departments,
  employees,
  editNews,
  addNews,
  addDepartment,
  editDepartment,
  addEmployee,
  editEmployee
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 2, child: _buildMenuColumn(context)),
            Expanded(flex: 7, child: _content(adminContent))
          ],
        ));
  }

  Widget _content(AdminContent content) {
    switch (content) {
      case AdminContent.departments:
        return AdminDepartmentPage();
        break;
      case AdminContent.employees:
        return AdminEmployeesPage();
        break;
      default:
        return AdminNewsPage();
    }
  }

  Widget _buildMenuColumn(BuildContext context) {
    EdgeInsets _padding = EdgeInsets.fromLTRB(10.0, 8, 10.0, 8);
    EdgeInsets _margin = EdgeInsets.fromLTRB(4, 2, 4, 2);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildMyCardWithPadding(Text("Редактор новостной ленты"),
              content: AdminContent.news,
              padding: _padding,
              context: context,
              margin: _margin),
          buildMyCardWithPadding(Text("Редактор отделов"),
              content: AdminContent.departments,
              padding: _padding,
              context: context,
              margin: _margin),
          buildMyCardWithPadding(Text("Редактор сотрудников"),
              content: AdminContent.employees,
              padding: _padding,
              context: context,
              margin: _margin),
        ],
      ),
    );
  }

  Widget buildMyCardWithPadding(Widget child,
      {EdgeInsets padding = const EdgeInsets.fromLTRB(23.0, 12.0, 23.0, 10.0),
      AdminContent content,
      BuildContext context,
      EdgeInsets margin = const EdgeInsets.all(4.0)}) {
    return Padding(
      padding: margin,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setState(() {
              adminContent = content;
            });
            print('Card tapped.');
          },
          child: Container(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
