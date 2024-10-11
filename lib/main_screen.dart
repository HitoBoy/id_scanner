import 'package:flutter/material.dart';
import 'mrz_scanner.dart'; // Import the MRZ scanner screen

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the containers
        children: [
          Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.blue,
            ), // Customize your color 
          ),

           Expanded(
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 130, 182, 226),
              child: const Center( 
                child: Text(
                  'ID Card \n(NFC) Scanner',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              ), // Light background color
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
              ),
              color:Color.fromARGB(255, 177, 209, 231),
            ),

            child: ElevatedButton(
            onPressed: () {
              // Navigate to the MRZ Picture Scanner screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MRZPictureScanner()),
              );
            },
            child: const Text('ID Card Scanner'),
            ),
          )
        ]
      ),
    );
  }
}