import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:asuka/asuka.dart';

import '../../auth/auth_service.dart';
import '../bloc/invoices_bloc.dart';
import '../bloc/invoices_event.dart';
import '../bloc/invoices_state.dart';
import '../invoices_service.dart';

AuthService get authService => Modular.get<AuthService>();
InvoicesService get invoicesService => Modular.get<InvoicesService>();

class InvoicesPage extends StatefulWidget {
  static const String routeKey = 'invoices';
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  @override
  void initState() {
    super.initState();
    handleAuthNavigation();
    BlocProvider.of<InvoicesBloc>(context).add(InvoicesLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text('Invoices'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(authService.getUser().photoURL),
                    radius: 40,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Welcome, ${authService.getUser().displayName.split(' ')[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                Modular.to.navigate('/');
                authService.signOut();
              },
            ),
          ],
        ),
      ),
      body: BlocListener<InvoicesBloc, InvoicesState>(
        // bloc: BlocProvider.of<InvoicesBloc>(context),
        listener: (context, state) {
          if (state is InvoicesLoadingState) {
          //  AsukaSnackbar.warning("InvoicesLoadingState").show();
          }
          if (state is InvoicesErrorState) {
             //AsukaSnackbar.alert("InvoicesErrorState").show();
          }
          if (state is InvoicesSuccessState) {
             //AsukaSnackbar.success("InvoicesSuccessState").show();
          }
        },
        child: BlocBuilder<InvoicesBloc, InvoicesState>(
          builder: (context, state) {
            if (state is InvoicesSuccessState) {
              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: state.response.invoices.length,
                itemBuilder: (BuildContext context, int index) {
                  final invoice = state
                      .response.invoices[index]; // Get the specific invoice
                  return ListTile(
                    leading: const Icon(
                        Icons.description), // Replace with a relevant icon
                    title: Text(
                        'Invoice #${invoice.data.invoiceId}'), // Replace with actual invoice name
                    subtitle: Text(
                        '${invoice.data.receiverName} - \$${invoice.data.totalAmount}'),
                    onTap: () {
                      // Navigate to the invoice details page
                      // You might pass the invoice data or id to the details page
                      Modular.to.navigate('/details/',
                          arguments: invoice);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            } else if (state is InvoicesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvoicesErrorState) {
              AsukaSnackbar.alert("Error loading invoices").show();
              return const Center(
                  child:
                      Text("Error loading invoices")); // Display error message
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}
