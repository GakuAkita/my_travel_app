import 'package:flutter/material.dart';

class ItineraryTableEditScreen extends StatefulWidget {
  final String sectionId;

  const ItineraryTableEditScreen({required this.sectionId, super.key});

  @override
  State<ItineraryTableEditScreen> createState() => _ItineraryTableEditScreenState();
}

class _ItineraryTableEditScreenState extends State<ItineraryTableEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text(widget.sectionId)]));
  }
}
