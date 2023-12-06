import 'package:flutter_modular/flutter_modular.dart';

import 'modules/search/search_module.dart';
import 'modules/search/search_service.dart';

class MainModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(SearchService.new);
  }

  @override
  void routes(r) {
    r.module('/', module: SearchModule());
  }
}
