import 'package:flutter_modular/flutter_modular.dart';

import 'pages/auth_page.dart';

class AuthModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthPage());
  }
}
