import 'package:flutter/material.dart';


class calendar_event extends StatelessWidget {
  final DateTime date;
  final String description;
  final String time;
  final String location;
  const calendar_event({Key? key,
  required this.date,
  required this.description,
  required this.time,
  required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          leading: Text(
              'Date: ${date.toLocal()}'.split(' ')[0],
              style: Theme.of(context).textTheme.labelMedium,
            ),
          title:  Text(
              'Description: $description',
              
            ),
          subtitle: Text(
              'Location: $location',
              
            ),
            trailing:  Text(
              'Time: $time',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          
        ),
      ),
    );
  }
} 