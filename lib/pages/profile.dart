import 'package:flutter/material.dart';
import 'package:recycle_app/services/shared_pref.dart';
import 'package:recycle_app/services/auth.dart';
import 'package:recycle_app/pages/login.dart'; // Import your login page

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userName = "";
  String? userEmail = "";
  String? userId = "";
  String? userImage = "";

  final SharedpreferenceHelper sharedPreferenceHelper =
      SharedpreferenceHelper();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    userName = await sharedPreferenceHelper.getUserName();
    userEmail = await sharedPreferenceHelper.getUserEmail();
    userId = await sharedPreferenceHelper.getUserId();
    userImage = await sharedPreferenceHelper.getUserImage();
    setState(() {});
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE3EAFE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              child: const Center(
                child: Text(
                  "Profile Page",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Profile Avatar
            userImage != null && userImage!.isNotEmpty
                ? CircleAvatar(
                  radius: 44,
                  backgroundImage: NetworkImage(userImage!),
                )
                : CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.teal,
                  child: Text(
                    (userName != null && userName!.isNotEmpty)
                        ? userName![0].toUpperCase()
                        : "U",
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            const SizedBox(height: 24),
            // Name Card
            _ProfileInfoCard(
              icon: Icons.person,
              title: "Name",
              value: userName ?? "",
            ),
            const SizedBox(height: 10),
            // Email Card
            _ProfileInfoCard(
              icon: Icons.email,
              title: "Email",
              value: userEmail ?? "",
              isEmail: true,
            ),
            const SizedBox(height: 18),
            // Logout Button
            _ProfileActionCard(
              icon: Icons.logout,
              label: "LogOut",
              onTap: () async {
                await AuthMethods().signOut();
                _navigateToLogin(context);
              },
            ),
            const SizedBox(height: 10),
            // Delete Account Button
            _ProfileActionCard(
              icon: Icons.delete,
              label: "Delete Account",
              iconColor: Colors.red,
              onTap: () async {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Delete Account"),
                        content: const Text(
                          "Are you sure you want to delete your account? This action cannot be undone.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await AuthMethods().deleteUser();
                              _navigateToLogin(context);
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isEmail;

  const _ProfileInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.isEmail = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 28),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isEmail ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ProfileActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? Colors.teal, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
