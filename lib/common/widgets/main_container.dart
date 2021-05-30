import 'package:flutter/material.dart';
import 'package:odoo_common_code_latest/common/config/app_fonts.dart';

class MainContainer extends StatelessWidget {
  String? appBarTitle;
  Widget child;
  List<Widget>? actions = [];
  bool isAppBar = true;
  Widget? leading;
  Color? backgroundColor;
  Widget? floatingActionButton;
  double? padding, elevation;
  Widget? bottomNavigationBar;

  MainContainer(
      {required this.child,
      this.backgroundColor,
      this.appBarTitle,
      this.isAppBar = true,
      this.actions,
      this.floatingActionButton,
      this.padding,
      this.elevation,
      this.leading,
      this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton ?? null,
      appBar: isAppBar == true
          ? AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              leading: leading ?? null,
              elevation: elevation ?? 0.0,
              centerTitle: true,
              actions: actions,
              title: Text(appBarTitle ?? '',
                  style: AppFont.Title_H6_Medium(color: Colors.white)),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding ?? 0.0),
          child: child,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar ?? null,
    );
  }
}
