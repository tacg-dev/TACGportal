import 'package:flutter/material.dart';

class calendar_event extends StatelessWidget {
  final DateTime date;
  final String description;
  final String time;
  final String location;
  final String title;
  const calendar_event({
    Key? key,
    required this.date,
    required this.description,
    required this.time,
    required this.location,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          leading: Text(
            'Date: ${date.month}/${date.day}/${date.year}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Column(
            children: [
              Text(
                'Time: $time',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Location: $location',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
