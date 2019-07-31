import 'package:coffee_app/business/model/user.dart';
import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/ui/login_page.dart';
import 'package:coffee_app/ui/requests_page.dart';
import 'package:coffee_app/ui/stores_page.dart';
import 'package:coffee_app/ui/orders_page.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:coffee_app/widgets/user_header_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class CoffeeDrawer extends StatefulWidget {
  final int pageIndex;
  CoffeeDrawer({Key key, @required this.pageIndex}) : super(key: key);

  @override
  _CoffeeDrawerState createState() => _CoffeeDrawerState();
}

class _CoffeeDrawerState extends State<CoffeeDrawer> {
  List<MenuItemData> _menuItems;
  UserBloc _userBloc;

  Future<void> _onDrawerItemTap(MenuItemData value) async {
    // Getting the next index to decide if it should show a new page or not
    final nextIndex = _menuItems.indexOf(value);
    Navigator.of(context).pop();
    // Changing pages with Navigator
    if (widget.pageIndex != nextIndex) {
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: value.pageBuilder,
      ));
    }
  }

  Future<void> _logout() async {
    await _userBloc.removeAuthenticated();
    Navigator.of(context).pop();
    await Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    //
    _userBloc = coffeeGetIt<UserBloc>();
    _userBloc.getCurrent();
    _menuItems = [
      MenuItemData(
          titleKey: 'stores.title',
          icon: Icons.store,
          pageBuilder: (context) => StoresPage()),
      MenuItemData(
          titleKey: 'orders.title',
          icon: Icons.account_balance_wallet,
          pageBuilder: (context) => OrdersPage()),
      MenuItemData(
          titleKey: 'favorites.title',
          icon: Icons.favorite,
          pageBuilder: (context) => StoresPage()),
      MenuItemData(
          titleKey: 'requests.title',
          icon: Icons.timeline,
          pageBuilder: (context) => RequestsPage()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return StreamBuilder<User>(
        stream: _userBloc.current,
        builder: (context, snapshot) {
          Widget drawerChild;
          if (snapshot.hasError) {
            drawerChild = GeneralErrorDialog();
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            drawerChild = ListView(
              shrinkWrap: true,
              children: <Widget>[
                UserHeaderInformation(user: user),
                ..._menuItems.map((value) => ListTile(
                      leading: Icon(value.icon),
                      title:
                          Text(FlutterI18n.translate(context, value.titleKey)),
                      onTap: () => _onDrawerItemTap(value),
                    )),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(FlutterI18n.translate(context, 'actions.exit')),
                  onTap: _logout,
                ),
              ],
            );
          } else {
            drawerChild = Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: theme.primaryColor,
                ),
              ),
            );
          }
          return Drawer(
            child: drawerChild,
          );
        });
  }
}

class MenuItemData {
  IconData icon;
  String titleKey;
  WidgetBuilder pageBuilder;

  MenuItemData({this.icon, this.titleKey, this.pageBuilder});
}
