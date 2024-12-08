import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;
  const BioBox({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Text(text.isNotEmpty ? text : "Empty Bio...",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
    );
  }
}
