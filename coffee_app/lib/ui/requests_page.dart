import 'package:coffee_app/business/bloc/store/store_bloc.dart';
import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/business/model/store.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/ui/store_requests_page.dart';
import 'package:coffee_app/widgets/coffee_drawer.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:transparent_image/transparent_image.dart';

class RequestsPage extends StatefulWidget {
  RequestsPage({Key key}) : super(key: key);

  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  StoreBloc _storeBloc;

  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    //
    _storeBloc = coffeeGetIt<StoreBloc>();
    _userBloc = coffeeGetIt<UserBloc>();
    _listStoresByUser();
  }

  Future<void> _listStoresByUser() async {
    final authenticated = await _userBloc.getAuthenticated();
    _storeBloc.getByUser(authenticated.id);
  }

  Future<void> _openStore(String storeId) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StoreRequestsPage(storeId),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'requests.title')),
      ),
      drawer: CoffeeDrawer(pageIndex: 3),
      body: StreamBuilder<Iterable<Store>>(
          stream: _storeBloc.byUser,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return GeneralErrorDialog();
            }
            if (snapshot.hasData) {
              final stores = snapshot.data;
              return _buildStores(stores);
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                    backgroundColor: theme.primaryColor),
              ),
            );
          }),
    );
  }

  Widget _buildStores(Iterable<Store> stores) {
    if (stores.length == 0) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.close),
            SizedBox(width: 8),
            Text(
              FlutterI18n.translate(context, 'names.empty'),
            )
          ],
        ),
      );
    }
    //
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores.elementAt(index);
        return ListTile(
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
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
          title: Text(store.name),
          onTap: () => _openStore(store.id),
        );
      },
    );
  }
}
