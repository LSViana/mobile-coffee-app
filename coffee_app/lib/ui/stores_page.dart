import 'package:coffee_app/business/bloc/cart/cart_bloc.dart';
import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/business/model/store.dart';
import 'package:coffee_app/business/bloc/store/store_bloc.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/ui/store_products_page.dart';
import 'package:coffee_app/widgets/coffee_drawer.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:transparent_image/transparent_image.dart';

class StoresPage extends StatefulWidget {
  StoresPage({Key key}) : super(key: key);

  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  StoreBloc _storeBloc;
  UserBloc _userBloc;
  CartBloc _cartBloc;

  Future<void> _openStore(Store store, Cart cart) async {
    final theme = Theme.of(context);
    //
    if (cart != null &&
        (cart.storeId?.length ?? 0) > 0 &&
        cart.storeId != store.id &&
        (cart.items?.isNotEmpty ?? false)) {
      final restore = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            FlutterI18n.translate(context, 'cart.reset'),
            style: theme.textTheme.title.copyWith(color: theme.primaryColor),
          ),
          content: Text(
            FlutterI18n.translate(context, 'cart.resetDescription'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                FlutterI18n.translate(context, 'actions.cancel').toUpperCase(),
              ),
              textColor: theme.primaryColor,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text(
                FlutterI18n.translate(context, 'actions.reset').toUpperCase(),
              ),
              textColor: theme.primaryColor,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
      if (!restore) return;
    }
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StoreProductsPage(store: store),
    ));
  }

  @override
  void initState() {
    super.initState();
    //
    _storeBloc = coffeeGetIt<StoreBloc>();
    _cartBloc = coffeeGetIt<CartBloc>();
    _userBloc = coffeeGetIt<UserBloc>();
    _userBloc.getCurrent();
    _storeBloc.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'stores.title')),
      ),
      drawer: CoffeeDrawer(pageIndex: 0),
      body: Container(
        child: StreamBuilder(
          stream: _storeBloc.all,
          builder: _buildStores,
        ),
      ),
    );
  }

  Widget _buildStores(
      BuildContext context, AsyncSnapshot<Iterable<Store>> snapshot) {
    final theme = Theme.of(context);
    if (snapshot.hasError) {
      return Center(child: GeneralErrorDialog());
    } else if (snapshot.hasData) {
      final stores = snapshot.data;
      return StreamBuilder<Cart>(
          stream: _cartBloc.cart,
          builder: (context, snapshot) {
            final cart = snapshot.data;
            //
            return ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores.elementAt(index);
                return ListTile(
                  onTap: () => _openStore(store, cart),
                  title: Text(store.name),
                  subtitle: _buildStoreSubtitle(store.open),
                  leading: Container(
                    padding: const EdgeInsets.all(4),
                    width: 54,
                    height: 54,
                    child: Material(
                      elevation: 2,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: store.imageUrl,
                        fit: BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 300),
                      ),
                    ),
                  ),
                );
              },
            );
          });
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: theme.primaryColor,
        ),
      );
    }
  }

  Widget _buildStoreSubtitle(bool open) {
    return Text(
      FlutterI18n.translate(context, open ? 'stores.open' : 'stores.closed'),
    );
  }
}
