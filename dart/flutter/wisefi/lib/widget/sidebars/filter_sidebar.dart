import 'package:flutter/material.dart';
import 'package:wisefi/models/models.dart';

class FilterSidebar extends StatefulWidget {
  final Set<String> selectedCustomers;
  final Set<String> selectedLocations;
  final Set<String> selectedSSIDs;
  final int selectedIndex;
  final Function(int) onDashboardChanged;
  final Function(Set<String>, Set<String>, Set<String>) onFilterChanged;
  final List<FortiAPData> fortiAPData;

  const FilterSidebar({
    Key? key,
    required this.selectedCustomers,
    required this.selectedLocations,
    required this.selectedSSIDs,
    required this.selectedIndex,
    required this.onDashboardChanged,
    required this.onFilterChanged,
    required this.fortiAPData,
  }) : super(key: key);

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  late Set<String> _selectedCustomers;
  late Set<String> _selectedLocations;
  late Set<String> _selectedSSIDs;

  @override
  void initState() {
    super.initState();
    _selectedCustomers = Set.from(widget.selectedCustomers);
    _selectedLocations = Set.from(widget.selectedLocations);
    _selectedSSIDs = Set.from(widget.selectedSSIDs);
  }

  @override
  Widget build(BuildContext context) {
    // Extract unique site names and locations
    final sites = widget.fortiAPData
        .where((ap) => ap.dv_fortigate_customer_name != null)
        .map((ap) => ap.dv_fortigate_customer_name!)
        .toSet()
        .toList();

    // Get unique physical locations
    final locations = widget.fortiAPData
        .where((ap) => ap.dv_location != null)
        .map((ap) => ap.dv_location!)
        .toSet()
        .toList();

    // If lists are empty, provide defaults
    if (sites.isEmpty) {
      sites.addAll(['unknow site']);
    }

    if (locations.isEmpty) {
      locations.addAll(['unknow location']);
    }
    return SizedBox(
      width: 300,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // App Logo and Name
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'WiseFi by Dev DV',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),

            Divider(color: Theme.of(context).dividerColor),

            // Dashboard Navigation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboards',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // FortiAP Dashboards
                  _buildDashboardCategory(context, 'FortiAP Insights'),
                  _buildDashboardItem(
                      context, 'AP Health & Performance', Icons.speed, 0),
                  _buildDashboardItem(
                      context, 'Client Distribution', Icons.devices, 1),

                  const SizedBox(height: 16),

                  // FortiManager Dashboards
                  _buildDashboardCategory(context, 'FortiManager Insights'),
                  _buildDashboardItem(
                      context, 'Config Changes', Icons.settings, 2),
                  _buildDashboardItem(
                      context, 'Admin Activity', Icons.admin_panel_settings, 3),

                  const SizedBox(height: 16),

// Combined Insights section
                  _buildDashboardCategory(context, 'Combined Insights'),
                  _buildDashboardItem(
                      context,
                      'Security Monitoring',
                      Icons.security,
                      4 // This index should match the position in the _dashboards list
                      ),
                ],
              ),
            ),

            Divider(color: Theme.of(context).dividerColor),

            // Filters Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),

                  // Date Range Filter
                  _buildFilterSection(
                    context,
                    'Date Range',
                    Icons.calendar_today,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: 'Last 24 Hours',
                      items: ['Last 24 Hours', 'Last Week', 'Last Month']
                          .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ))
                          .toList(),
                      onChanged: (value) {
                        // Handle date range change
                      },
                    ),
                  ),
// Site filter (based on dv_fortigate_customer_name)
                  _buildFilterSection(
                    context,
                    'Sites',
                    Icons.business,
                    child: Column(
                      children: sites
                          .map((site) => _buildCheckboxItem(
                                context,
                                site,
                                selectedItems: _selectedCustomers,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked) {
                                      _selectedCustomers.add(site);
                                    } else {
                                      _selectedCustomers.remove(site);
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),

                  // Physical location filter (based on dv_location)
                  _buildFilterSection(
                    context,
                    'Physical Locations',
                    Icons.location_on,
                    child: Column(
                      children: locations
                          .map((location) => _buildCheckboxItem(
                                context,
                                location,
                                selectedItems: _selectedLocations,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked) {
                                      _selectedLocations.add(location);
                                    } else {
                                      _selectedLocations.remove(location);
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Apply and Reset Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply filters
                            widget.onFilterChanged(_selectedCustomers,
                                _selectedLocations, _selectedSSIDs);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Filters applied'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedCustomers.clear();
                            _selectedLocations.clear();
                            _selectedSSIDs.clear();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Actions Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Views',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildQuickViewButton(
                    context,
                    'Critical Issues',
                    Icons.warning_amber,
                    Colors.red,
                  ),
                  _buildQuickViewButton(
                    context,
                    'Rogue APs',
                    Icons.security,
                    Colors.orange,
                  ),
                  _buildQuickViewButton(
                    context,
                    'Performance Issues',
                    Icons.speed,
                    Colors.amber,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCategory(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildDashboardItem(
      BuildContext context, String title, IconData icon, int index) {
    final isSelected = widget.selectedIndex == index;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => widget.onDashboardChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context, String title, IconData icon,
      {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCheckboxItem(BuildContext context, String label,
      {required Set<String> selectedItems, required Function(bool) onChanged}) {
    return CheckboxListTile(
      title: Text(label),
      value: selectedItems.contains(label),
      onChanged: (value) {
        onChanged(value ?? false);
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildQuickViewButton(
      BuildContext context, String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
