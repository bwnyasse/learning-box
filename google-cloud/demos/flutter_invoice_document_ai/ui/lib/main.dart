import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_invoice_document_ai_ui/models/models.dart';
import 'package:flutter_invoice_document_ai_ui/views/chartview_page.dart';
import 'package:flutter_invoice_document_ai_ui/views/details_page.dart';
import 'package:flutter_invoice_document_ai_ui/views/home_page.dart';
import 'package:flutter_invoice_document_ai_ui/views/login_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
        ),
        GoRoute(
          path: '/details',
          builder: (BuildContext context, GoRouterState state) => DetailsPage(
              invoiceData: InvoiceData.fromJson({}), invoiceImageUrl: ''),
        ),
        GoRoute(
          path: '/chart',
          builder: (BuildContext context, GoRouterState state) =>
              const ChartViewPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Flutter Incoive Document AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
