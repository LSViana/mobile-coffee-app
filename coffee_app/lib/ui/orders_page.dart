import 'package:coffee_app/business/bloc/cart/request_bloc.dart';
import 'package:coffee_app/business/model/request.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/widgets/coffee_drawer.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  RequestBloc _requestBloc;

  @override
  void initState() {
    super.initState();
    //
    _requestBloc = coffeeGetIt<RequestBloc>();
    _requestBloc.getMine();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'orders.title'),
        ),
      ),
      drawer: CoffeeDrawer(pageIndex: 1),
      body: StreamBuilder<Iterable<Request>>(
          stream: _requestBloc.mine,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final requests = snapshot.data;
              return _buildRequests(requests, theme);
            }
            if (snapshot.hasError) {
              return GeneralErrorDialog();
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: theme.primaryColor,
                ),
              ),
            );
          }),
    );
  }
}

Widget _buildRequests(Iterable<Request> requests, ThemeData theme) {
  return ListView.builder(
    itemCount: requests.length,
    itemBuilder: (context, index) {
      final request = requests.elementAt(index);
      return ListTile(
        title: Text(request.store.name),
        subtitle: Text(request.createdAt.toIso8601String()),
      );
    },
  );
}
