import 'package:flutter/material.dart';

class RoundedLabel extends StatelessWidget {
  final String name;
  const RoundedLabel({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Center(child: Text(name, style: Theme.of(context).textTheme.bodyMedium,)),
    );
  }
}
