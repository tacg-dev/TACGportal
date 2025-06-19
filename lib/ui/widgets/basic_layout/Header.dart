import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tacgportal/router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../util.dart';
import '../../../main.dart'; // Import to use the handleSignOut function

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool homeHovered = false;

  // Function to launch external URL
  void _launchURL() async {
    const url =
        "https://www.tamuconsultinggroup.com/"; // Replace with your external website URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.02;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), // Padding for header
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side:
          Expanded(
            child: Container(
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.black, width: 3),
                //   borderRadius: BorderRadius.circular(8),
                //   color: Theme.of(context).colorScheme.primaryContainer,
                // ),
                ),
          ),

          // Center Section of header
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Return To Main Website Here',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  // Button to navigate to external website
                  MouseRegion(
                    onEnter: (event) => setState(() {
                      homeHovered = true;
                    }),
                    onExit: (event) => setState(() {
                      homeHovered = false;
                    }),
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          color: homeHovered
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          "HOME",
                          style: GoogleFonts.openSans(
                            textStyle:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: homeHovered
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                    ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.add_home_work),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<ProfileScreen>(
                          builder: (context) => ProfileScreen(
                            appBar: AppBar(
                              title: const Text('Profile'),
                            ),
                            actions: [
                              SignedOutAction(
                                (context) {
                                  // First close the profile screen
                                  Navigator.of(context).pop();
                                  context.goNamed(AppRoute.login.name);
                                },
                              ),
                            ],
                            children: [
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset('lib/assets/tacg-nbg.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),

          // Right Side: User Profile section
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
