import 'package:flutter/material.dart';

// Custom Drawer Item Widget
class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const DrawerItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the specified route
        Navigator.pushNamed(context, route);
      },
      hoverColor: Colors.blue.withOpacity(0.2), // Hover effect color
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }
}
