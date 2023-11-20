import 'package:flutter_modular/flutter_modular.dart';

import 'modules/auth/auth_module.dart';
import 'modules/auth/auth_service.dart';
import 'modules/details/details_module.dart';
import 'modules/invoices/invoices_service.dart';
import 'modules/auth/bloc/auth_bloc.dart';
import 'modules/invoices/invoices_module.dart';
import 'modules/splash/splash_page.dart';

class MainModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(AuthService.new);
    i.addSingleton(AuthBloc.new);
    i.addSingleton(InvoicesService.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/auth', module: AuthModule());
    r.module('/invoices', module: InvoicesModule());
    r.module('/details', module: DetailsModule());
  }
}
