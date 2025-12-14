
import 'package:flutter/material.dart';

class TitleRadion extends StatefulWidget{
  final String name;
  final String value;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const TitleRadion({super.key, required this.name, required this.value, required this.selectedValue, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _TitleRadion();
}

class _TitleRadion extends State<TitleRadion>{
  @override
  Widget build(BuildContext context) {

    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        horizontalTitleGap: 8,
        title:  Text(
          widget.name,
          style:const TextStyle(
            fontSize: 18,
            color: Colors.black38,
          ),
        ),
        leading: Container(
          child: Radio<String>(
              value: widget.value.toString(),
              groupValue: widget.selectedValue,
              onChanged: widget.onChanged,
              visualDensity: VisualDensity.compact,
            activeColor: Colors.grey,
          ),
        )
    );
  }
}