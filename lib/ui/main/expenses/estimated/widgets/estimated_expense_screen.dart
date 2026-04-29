import 'package:flutter/material.dart';

import '../../../../core/ui/top_app_bar.dart';

class EstimatedExpenseScreen extends StatefulWidget {
  const EstimatedExpenseScreen({super.key});

  @override
  State<EstimatedExpenseScreen> createState() => _EstimatedExpenseScreenState();
}

class _EstimatedExpenseScreenState extends State<EstimatedExpenseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /* 計算する */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: TopAppBar(automaticallyImplyLeading: true), body: Column());
  }
}
