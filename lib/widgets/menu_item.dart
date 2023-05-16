import 'package:flutter/material.dart';

import '../models/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;

  const MenuItemCard({Key? key, required this.menuItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            menuItem.imageUrl.isNotEmpty
                ? Image.network(
                    menuItem.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(width: 80, height: 80),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    menuItem.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${menuItem.price} ${menuItem.currency}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
