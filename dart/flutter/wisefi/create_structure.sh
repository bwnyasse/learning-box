#!/bin/bash

# Base directory
base_dir="lib"

# Create directories
mkdir -p $base_dir/core/constants
mkdir -p $base_dir/core/models
mkdir -p $base_dir/core/utils
mkdir -p $base_dir/features/dashboard/bloc
mkdir -p $base_dir/features/dashboard/widgets
mkdir -p $base_dir/features/filter/bloc
mkdir -p $base_dir/features/filter/widgets
mkdir -p $base_dir/features/ai_chat/bloc
mkdir -p $base_dir/features/ai_chat/widgets
mkdir -p $base_dir/services/api
mkdir -p $base_dir/services/mock
mkdir -p $base_dir/services/ai

# Create files
touch $base_dir/core/constants/app_colors.dart
touch $base_dir/core/constants/app_strings.dart
touch $base_dir/core/constants/app_theme.dart
touch $base_dir/core/models/access_point.dart
touch $base_dir/core/models/client.dart
touch $base_dir/core/models/network_event.dart
touch $base_dir/core/models/security_alert.dart
touch $base_dir/core/utils/date_formatter.dart
touch $base_dir/core/utils/mock_data_generator.dart
touch $base_dir/features/dashboard/bloc/dashboard_bloc.dart
touch $base_dir/features/dashboard/bloc/dashboard_event.dart
touch $base_dir/features/dashboard/bloc/dashboard_state.dart
touch $base_dir/features/dashboard/widgets/ap_status_card.dart
touch $base_dir/features/dashboard/widgets/client_chart.dart
touch $base_dir/features/dashboard/widgets/health_metrics_chart.dart
touch $base_dir/features/dashboard/widgets/rogue_ap_alert.dart
touch $base_dir/features/dashboard/dashboard_page.dart
touch $base_dir/features/filter/bloc/filter_bloc.dart
touch $base_dir/features/filter/bloc/filter_event.dart
touch $base_dir/features/filter/bloc/filter_state.dart
touch $base_dir/features/filter/widgets/customer_filter.dart
touch $base_dir/features/filter/widgets/date_filter.dart
touch $base_dir/features/filter/widgets/location_filter.dart
touch $base_dir/features/filter/widgets/ssid_filter.dart
touch $base_dir/features/filter/filter_sidebar.dart
touch $base_dir/features/ai_chat/bloc/ai_chat_bloc.dart
touch $base_dir/features/ai_chat/bloc/ai_chat_event.dart
touch $base_dir/features/ai_chat/bloc/ai_chat_state.dart
touch $base_dir/features/ai_chat/widgets/chat_bubble.dart
touch $base_dir/features/ai_chat/widgets/chat_input.dart
touch $base_dir/features/ai_chat/widgets/suggested_prompts.dart
touch $base_dir/features/ai_chat/ai_chat_sidebar.dart
touch $base_dir/services/api/api_client.dart
touch $base_dir/services/api/api_endpoints.dart
touch $base_dir/services/mock/mock_api_client.dart
touch $base_dir/services/mock/mock_data.dart
touch $base_dir/services/ai/gemini_service.dart
touch $base_dir/main.dart
touch $base_dir/app.dart

echo "Directory and file structure created successfully." 