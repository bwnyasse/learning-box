import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import '../helpers/helpers.dart';
import 'dashboards/ap_health_dashboard.dart';
import 'dashboards/client_distribution_dashboard.dart';
import 'dashboards/config_changes_dashboard.dart';
import 'dashboards/admin_activity_dashboard.dart';
import 'sidebars/filter_sidebar.dart';
import 'sidebars/ai_chat_sidebar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final DataService _dataService = DataService();

  List<FortiAPData> fortiAPData = [];
  List<FortiManagerData> fortiManagerData = [];

  bool isLoading = true;
  Set<String> selectedCustomers = {};
  Set<String> selectedLocations = {};
  Set<String> selectedSSIDs = {};

  int _selectedIndex = 0;

  // List of dashboards
  final List<String> _dashboards = [
    'AP Health & Performance',
    'Client Distribution',
    'Config Changes',
    'Admin Activity',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Try to load data from JSON files
      final apData = await _dataService.loadFortiAPData();
      final managerData = await _dataService.loadFortiManagerData();

      // If no data was loaded, generate sample data
      setState(() {
        fortiAPData = apData.isNotEmpty
            ? apData
            : _dataService.generateSampleFortiAPData();

        fortiManagerData = managerData.isNotEmpty
            ? managerData
            : _dataService.generateSampleFortiManagerData();

        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');

      // If an error occurs, fall back to sample data
      setState(() {
        fortiAPData = _dataService.generateSampleFortiAPData();
        fortiManagerData = _dataService.generateSampleFortiManagerData();
        isLoading = false;
      });
    }
  }

  void _onDashboardChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // Left sidebar for filters and navigation
          FilterSidebar(
            selectedCustomers: selectedCustomers,
            selectedLocations: selectedLocations,
            selectedSSIDs: selectedSSIDs,
            selectedIndex: _selectedIndex,
            onDashboardChanged: _onDashboardChanged,
            onFilterChanged: (customers, locations, ssids) {
              setState(() {
                selectedCustomers = customers;
                selectedLocations = locations;
                selectedSSIDs = ssids;
              });
            },
            fortiAPData: fortiAPData,
          ),

          // Vertical divider
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),

          // Main content area
          Expanded(
            flex: 3,
            child: _buildDashboardContent(context),
          ),

          // Vertical divider
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),

          // Right sidebar for AI chat
          const AIChatSidebar(),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    // Return the appropriate dashboard based on selected index
    switch (_selectedIndex) {
      case 0:
        return APHealthDashboard(fortiAPData: fortiAPData);
      case 1:
        return ClientDistributionDashboard(fortiAPData: fortiAPData);
      case 2:
        return ConfigChangesDashboard(fortiManagerData: fortiManagerData);
      case 3:
        return AdminActivityDashboard(fortiManagerData: fortiManagerData);
      default:
        return APHealthDashboard(fortiAPData: fortiAPData);
    }
  }
}
