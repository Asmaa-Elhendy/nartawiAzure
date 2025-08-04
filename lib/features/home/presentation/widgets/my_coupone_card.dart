import 'package:flutter/material.dart';

class MyCouponCard extends StatelessWidget {
  const MyCouponCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Flat \$25 Off*", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("FINFIRST25", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            child: const Text("Apply Code"),
          ),
        ],
      ),
    );
  }
}
