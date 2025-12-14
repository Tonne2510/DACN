
import 'package:flutter/material.dart';

class FavouriteScreen extends StatelessWidget{
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            children: [
              Text("This is favourite screen")
            ],
          ),
        ),
      ),
    );
  }
}