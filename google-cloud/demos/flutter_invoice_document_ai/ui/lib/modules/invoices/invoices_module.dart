
import 'package:flutter_modular/flutter_modular.dart';

import 'pages/invoices_page.dart';

class InvoicesModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const InvoicesPage());
  }
}