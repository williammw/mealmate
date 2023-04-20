import 'package:flutter/material.dart';

class SearchRestaurantScreen extends StatefulWidget {
  const SearchRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<SearchRestaurantScreen> createState() => _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState extends State<SearchRestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Search Restaurants'),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Search for nearby restaurants here.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // TODO: Implement restaurant search and display functionality
  }
}
