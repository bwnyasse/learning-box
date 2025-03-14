import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:convert';

class AppColors_1 {
  // Version 3: Warm and Inviting Light Theme
  static const Color primary = Color(0xFF64B5F6); // Light blue
  static const Color background = Color(0xFFF5F5F5); // Light grey background
  static const Color textPrimary = Color(0xFF333333); // Dark grey
  static const Color textSecondary = Color(0xFF666666); // Medium grey
  static const Color unfilledDot = Color(0xFFBDBDBD); // Light gray
  static const Color achievedDot = Color(0xFF81C784); // Light green
  static const Color missedDot = Color(0xFFFFD54F); // Light amber
  static const Color cardBackground = Colors.white; // White card
  static const Color cardBorder = Color(0xFFE0E0E0); // Very light grey
  static const Color progressBarBackground = Color(0xFFE0E0E0);
}

class AppColors {
  // Version 0: Dark
  static const Color primary = Color(0xFF0066CC);
  static const Color background = Colors.black;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color unfilledDot = Color(0xFF3A3A3C);
  static const Color achievedDot = Color(0xFF00E676); // Material green A400
  static const Color missedDot = Color(0xFFFFA000); // Material amber 700
  static const Color cardBackground =
      Color(0xFF282828); // Slightly lighter than grey[900]
  static const Color cardBorder =
      Color(0xFF424242); // Slightly lighter than grey[800]
  static const Color progressBarBackground =
      Color(0xFF424242); // Slightly lighter than grey[800]
}

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required for SystemChrome
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Year Visualizer',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: '.SF Pro Display',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32, // Adjusted
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 18, // Adjusted
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          bodyLarge: TextStyle(
            fontSize: 14, // Adjusted
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 12, // Adjusted
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const YearVisualizerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class YearVisualizerPage extends StatefulWidget {
  const YearVisualizerPage({Key? key}) : super(key: key);

  @override
  State<YearVisualizerPage> createState() => _YearVisualizerPageState();
}

class _YearVisualizerPageState extends State<YearVisualizerPage> {
  // Configuration
  final int daysPerRow = 17; // Custom grid layout with 15 dots per row
  final int totalDays = 365;
  late int rows;

  // Activity types with their colors (Apple-inspired, dark theme)
  final Map<String, Map<String, dynamic>> activityTypes = {
    'achieved': {
      'color': AppColors.achievedDot, // Apple achieved
      'label': 'Target Achieved'
    },
    'missed': {
      'color': AppColors.missedDot, // Apple red
      'label': 'Target Missed'
    },
    'none': {
      'color': AppColors.unfilledDot, // Dark gray for unfilled
      'label': 'Unfilled'
    },
  };

  late List<Map<String, dynamic>> daysData = [];
  late int dayOfYear;
  late int remainingDays;
  late int percentRemaining;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    rows = (totalDays / daysPerRow).ceil();

    // Calculate current day of year
    final currentDate = DateTime.now();
    final startOfYear = DateTime(currentDate.year, 1, 1);
    dayOfYear = currentDate.difference(startOfYear).inDays + 1;
    remainingDays = totalDays - dayOfYear;
    percentRemaining = ((remainingDays / totalDays) * 100).round();

    // Load data from JSON file
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      // Load the JSON file from assets
      final String jsonString =
          await rootBundle.loadString('assets/days_data.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);

      // Convert JSON to our data format
      daysData =
          jsonData.map((item) => Map<String, dynamic>.from(item)).toList();

      // Make sure we have exactly 365 days
      if (daysData.length != totalDays) {
        generateDaysData();
      }

      // Reverse the list to fill from bottom to top
      daysData = daysData.reversed.toList();
    } catch (e) {
      print('Error loading JSON data: $e');
      // If there's an error, generate default data
      generateDaysData();
    }

    // Set loading to false when data is ready
    setState(() {
      isLoading = false;
    });
  }

  void generateDaysData() {
    // Generate default days data with current date as reference
    final currentDate = DateTime.now();
    final startOfYear = DateTime(currentDate.year, 1, 1);

    daysData = List.generate(totalDays, (index) {
      final date = startOfYear.add(Duration(days: index));
      final day = index + 1;

      // Default all days to unfilled
      String type = 'none';

      // For demo purposes, set some days as achieved or missed
      if (index < dayOfYear) {
        // For past days, randomly distribute achievements and misses
        final rand = Random().nextDouble();
        if (rand < 0.7) {
          type = 'achieved';
        } else if (rand < 0.9) {
          type = 'missed';
        }
      }

      return {
        'day': day,
        'date':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'type': type
      };
    });

    // Reverse to fill from bottom to top
    daysData = daysData.reversed.toList();
  }

  // Calculate statistics
  Map<String, dynamic> get stats {
    final achieved = daysData.where((d) => d['type'] == 'achieved').length;
    final missed = daysData.where((d) => d['type'] == 'missed').length;
    final successRate =
        dayOfYear > 0 ? ((achieved / dayOfYear) * 100).round() : 0;

    return {
      'achieved': achieved,
      'missed': missed,
      'successRate': successRate,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final dotSize = screenWidth * 0.035; // Dynamic dot size
    final dotSpacing = screenWidth * 0.005; // Dynamic spacing

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
// Motivational quote with enhanced styling
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Let's go Boris-Wilfried!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            "Stop thinking, start building.",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // This will be overridden by the gradient
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grid of dots in a card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: List.generate(rows, (rowIndex) {
                        final start = rowIndex * daysPerRow;
                        final end = min((rowIndex + 1) * daysPerRow, totalDays);
                        final rowDays = daysData.sublist(start, end);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: rowDays.map((day) {
                            return Container(
                              width: 14,
                              height: 14,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: activityTypes[day['type']]!['color'],
                                shape: BoxShape.circle,
                                boxShadow: day['type'] != 'none'
                                    ? [
                                        BoxShadow(
                                          color: activityTypes[day['type']]![
                                                  'color']
                                              .withOpacity(0.3),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),

// Replace your current "Year remaining info" container with this more compact version
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        // Compact year and percentage in one row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '2025',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$percentRemaining% remaining',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        // Progress bar
                        Container(
                          width: double.infinity,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.progressBarBackground,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: percentRemaining / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Statistics
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Achieved',
                            value: '${stats['achieved']}',
                            color: AppColors.achievedDot,
                            iconData: Icons.check_circle_outline,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Success Rate',
                            value: '${stats['successRate']}%',
                            color: AppColors.primary,
                            iconData: Icons.trending_up,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Legend
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(
                            color: activityTypes['achieved']!['color'],
                            label: 'Target Achieved'),
                        const SizedBox(width: 16),
                        _buildLegendItem(
                            color: activityTypes['missed']!['color'],
                            label: 'Target Missed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData iconData,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Make the row take minimum space
            mainAxisAlignment: MainAxisAlignment.center, // Center children
            children: [
              Icon(
                iconData,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center, // Center the text
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center, // Center the text
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
