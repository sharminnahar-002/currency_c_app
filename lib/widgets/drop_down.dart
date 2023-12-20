import 'package:flutter/material.dart';

Widget customDropDown(List<String> items, String selectedValue, Function(String?) onChanged) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
      color:Colors.lightGreen, // Set the background color to mainColor
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: DropdownButton<String>(
      value: selectedValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 36,
      elevation: 16,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              Icon(Icons.flag),
              SizedBox(width: 8.0),
              Text(value),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
