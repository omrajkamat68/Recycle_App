import 'package:flutter/material.dart';
import 'package:recycle_app/Admin/admin_approval.dart';
import 'package:recycle_app/Admin/admin_reedem.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bluish = const Color(0xFFE3EAFE);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // White header with "Home Admin"
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 48, bottom: 18),
            child: const Center(
              child: Text(
                "Home Admin",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Bluish background with rounded top corners
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bluish,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  children: [
                    _AdminHomeCard(
                      imagePath: "images/approval.png",
                      label: "Admin\nApproval",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminApproval()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _AdminHomeCard(
                      imagePath: "images/reedem.png",
                      label: "Reedem\nRequest",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminReedem()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminHomeCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _AdminHomeCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110, // Increased card height
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            children: [
              const SizedBox(width: 18),
              Image.asset(
                imagePath,
                width: 64, // Increased image size
                height: 64,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 22, // Increased font size
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





