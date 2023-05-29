# MealMate

## Objective
Develop an app that helps users get personalized meal recommendations from restaurant menus based on their dietary preferences, allergies, and other specific needs.

## Features
1. Restaurant search and selection
2. Menu image capture
3. OCR-based text extraction
4. Menu translation (if needed)
5. User profile and preferences
6. Personalized meal recommendations using OpenAI API

## Project Structure

1. lib/
   - main.dart
   - screens/
       - home_screen.dart (rename from home_screen_tab.dart)
       - search_restaurant_screen.dart (rename from search_screen.dart)
       - restaurant_details_screen.dart
       - user_profile_screen.dart (rename from profile_screen.dart)
       - settings_screen.dart
   - widgets/
       - bottom_navigation.dart
       - custom_sliver_app_bar.dart
       - restaurant_card.dart
       - menu_image_capture.dart
       - meal_recommendation_card.dart
   - models/
       - restaurant.dart
       - user.dart
       - menu_item.dart
       - recommendation.dart
   - services/
       - restaurant_service.dart
       - openai_service.dart
       - user_service.dart
2. assets/
   - images/
   - icons/

## Changes to existing files
1. Rename 'home_screen_tab.dart' to 'home_screen.dart'
2. Rename 'search_screen.dart' to 'search_restaurant_screen.dart'
3. Rename 'profile_screen.dart' to 'user_profile_screen.dart'

## New files to create
1. 'restaurant_details_screen.dart': The screen that displays restaurant details and allows the user to capture the menu image.
2. 'settings_screen.dart': The screen that allows users to modify their preferences and settings.
3. 'restaurant_card.dart': A widget for displaying a single restaurant in the search results.
4. 'menu_image_capture.dart': A widget for capturing the menu image and processing it with OCR.
5. 'meal_recommendation_card.dart': A widget for displaying a single meal recommendation.

# image creation
https://www.bing.com/images/create