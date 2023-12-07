import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bloc/search_bloc.dart';
import 'pages/widget/search.dart';

class SearchModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {

    r.child(
      '/',
      child: (context) => BlocProvider(
        create: (context) => SearchBloc(),
        child: const Search(),
      ),
    );
  }
}

