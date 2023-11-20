import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../shared/navbar_page.dart';
import 'bloc/invoices_bloc.dart';
import 'pages/invoices_page.dart';

class InvoicesModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/',
        child: (context) => BlocProvider(
            create: (context) => InvoicesBloc(),
            child: const NavBarPage(initialPage: InvoicesPage.routeKey)));
  }
}
