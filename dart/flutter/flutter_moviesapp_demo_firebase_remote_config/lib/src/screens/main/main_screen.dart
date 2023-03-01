import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../cubits/cubit.dart';
import '../../services/services.dart';
import '../dashboard/dashboard_screen.dart';
import 'components/side_menu_component.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenuComponent(),
            ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  // Is Loading
                  if (state is AppLoading) {
                    return const LoadingWidget();
                  }

                  // Is Loaded
                  if (state is AppLoaded) {
                    return DashboardScreen(response: state.response);
                  }

                  // State error
                  if (state is AppError) {
                    return const Text("Error ...");
                  }
                  return const InitStateWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text("Loading ..."),
        ],
      ),
    );
  }
}

class InitStateWidget extends StatelessWidget {
  const InitStateWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseRemoteConfigService firebaseRemoteConfigService =
        context.watch<FirebaseRemoteConfigService>();
    return Center(
      child: SizedBox(
        width: 300,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (firebaseRemoteConfigService.isDemoDay())
              const Text("It is DEMO DAY ..."),
            const SizedBox(
              height: 15,
            ),
            const LinearProgressIndicator(),
            const SizedBox(
              height: 15,
            ),
            const Text("Select a category ..."),
          ],
        ),
      ),
    );
  }
}
