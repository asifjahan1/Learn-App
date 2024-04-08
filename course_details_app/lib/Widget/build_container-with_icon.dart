// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget buildContainerWithIcon(String text, Color textColor) {
  return Container(
    padding: const EdgeInsets.all(10),
    color: const Color(0xFFF7F8FA),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textColor, // Set the text color to the provided color
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up_outlined,
              color: Color.fromARGB(255, 133, 94, 251)),
          onPressed: () {
            // Handle icon click here
          },
        ),
      ],
    ),
  );
}
