import 'package:flutter_modular/flutter_modular.dart';

import 'pages/details_page.dart';

class DetailsModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      '/:invoice',
      child: (context) => DetailsPage(invoice: r.args.data),
    );
  }
}
