import 'package:flutter/material.dart';

class ArrowValue extends StatelessWidget {
  const ArrowValue({
    super.key,
    required this.label,
    required this.value,
    required this.upper,
    required this.lower,
  });

  final String label;
  final String value;
  final VoidCallback upper;
  final VoidCallback lower;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: lower,
            splashRadius: 24,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$label',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: upper,
            splashRadius: 24,
          ),
        ],
      ),
    );
  }
}
