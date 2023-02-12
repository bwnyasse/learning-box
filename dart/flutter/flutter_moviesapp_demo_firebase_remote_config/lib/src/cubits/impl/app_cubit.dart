import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/services.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final ApiService service;

  AppCubit({
    required this.service,
  }) : super(AppEmpty());

  void onErrorEvent() => emit(AppError());
  void onLoadingEvent() => emit(AppLoading());
  void onLoadEvent(final String restApi) async {
    emit(AppLoading());
    try {
      final list = await service.loadMovies(restApi);
      emit(AppLoaded(response: list));
    } catch (e) {
      print(e);
      emit(AppError());
    }
  }
}
