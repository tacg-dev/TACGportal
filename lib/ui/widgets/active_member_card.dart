import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/active_member_db_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveMemberCard extends StatelessWidget {
  final ActiveMemberDbInfo member;

  const ActiveMemberCard({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMemberDetails(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "http://127.0.0.1:5000/api/active-member/headshot/${getGoogleDriveFileId(member.headshotUrl)}"),
                    fit:
                        BoxFit.cover, // Maintains aspect ratio, crops if needed
                    alignment: Alignment
                        .topCenter, // Shows top part (good for headshots)
                  ),
                ),
                // Loading and error handling
                child: getGoogleDriveFileId(member.headshotUrl) == null
                    ? Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                      )
                    : null,
              ),
            ),
            // Member Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    '${member.firstName} ${member.lastName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Classification and Major
                  Row(
                    children: [
                      const Icon(
                        Icons.school,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${member.classification} • ${member.expectedGraduationDate}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // View Profile Button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${member.major}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showMemberDetails(context),
                          child: const Text('View Profile'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberDetails(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => _MemberDetailsModal(member: member),
    // );

    showDialog(
        context: context,
        builder: (context) => _MemberDetailsModal(member: member));
  }
}

class _MemberDetailsModal extends StatelessWidget {
  final ActiveMemberDbInfo member;

  const _MemberDetailsModal({
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    double dialog_width = MediaQuery.sizeOf(context).width * 1 / 2;
    double dialog_height = MediaQuery.sizeOf(context).height * 7/8;
    double photo_max_width = dialog_width;
    double photo_max_height = dialog_height * 1 / 3;
    return Dialog(
      child: Container(
        width: dialog_width,
        height: dialog_height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity, // Full width of column
                height: photo_max_height,
                child: Stack(
                  children: [
                    // Background image
                    Container(
                      width: double.infinity,
                      height: photo_max_height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage(
                              'lib/assets/tacg.png'), // or NetworkImage
                          fit:
                              BoxFit.cover, // or BoxFit.fill to stretch exactly
                        ),
                      ),
                    ),
                    // Foreground headshot
                    Center(
                      child: Container(
                        width: photo_max_width,
                        height: photo_max_height,
                        child: Image.network(
                          "http://127.0.0.1:5000/api/active-member/headshot/${getGoogleDriveFileId(member.headshotUrl)}",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and basic info
                      Text(
                        '${member.firstName} ${member.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Classification and major
                      Text(
                        '${member.classification} • ${member.major}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                
                      // Contact information section
                      infoSection(
                        title: 'CONTACT INFORMATION',
                        children: [
                          infoRow(Icons.email, 'TAMU Email', member.tamuEmail),
                          infoRow(Icons.email_outlined, 'Personal Email',
                              member.personalEmail),
                          infoRow(Icons.phone, 'Phone', member.phoneNumber),
                        ],
                      ),
                
                      const SizedBox(height: 24),
                
                      // Education section
                      infoSection(
                        title: 'EDUCATION',
                        children: [
                          infoRow(Icons.school, 'Major', member.major),
                          infoRow(Icons.calendar_today, 'Expected Graduation',
                              member.expectedGraduationDate),
                        ],
                      ),
                
                      const SizedBox(height: 24),
                
                      // Resume section
                      infoSection(
                        title: 'RESUME',
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.description),
                            label: const Text('View Resume'),
                            onPressed: () => _launchURL(member.resumeUrl),
                          ),
                        ],
                      ),
                
                      const SizedBox(height: 24),
                
                      // About section
                      infoSection(
                        title: 'ABOUT',
                        children: [
                          Text(
                            member.description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modal Header with close button and image
          Stack(
            children: [
              // Member Headshot
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "http://127.0.0.1:5000/api/active-member/headshot/${getGoogleDriveFileId(member.headshotUrl)}"),
                      fit: BoxFit
                          .cover, // Maintains aspect ratio, crops if needed
                      alignment: Alignment
                          .topCenter, // Shows top part (good for headshots)
                    ),
                  ),
                  // Loading and error handling
                  child: getGoogleDriveFileId(member.headshotUrl) == null
                      ? Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                        )
                      : null,
                ),
              ),
              // Close Button
              Positioned(
                top: 16,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          // Member Details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and basic info
                  Text(
                    '${member.firstName} ${member.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Classification and major
                  Text(
                    '${member.classification} • ${member.major}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact information section
                  infoSection(
                    title: 'CONTACT INFORMATION',
                    children: [
                      infoRow(Icons.email, 'TAMU Email', member.tamuEmail),
                      infoRow(Icons.email_outlined, 'Personal Email',
                          member.personalEmail),
                      infoRow(Icons.phone, 'Phone', member.phoneNumber),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Education section
                  infoSection(
                    title: 'EDUCATION',
                    children: [
                      infoRow(Icons.school, 'Major', member.major),
                      infoRow(Icons.calendar_today, 'Expected Graduation',
                          member.expectedGraduationDate),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Resume section
                  infoSection(
                    title: 'RESUME',
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.description),
                        label: const Text('View Resume'),
                        onPressed: () => _launchURL(member.resumeUrl),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // About section
                  infoSection(
                    title: 'ABOUT',
                    children: [
                      Text(
                        member.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.black54,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print('Could not launch $url: $e');
    }
  }
}

String? getGoogleDriveFileId(String? url) {
  if (url == null || url.isEmpty) {
    return null;
  }

  // Pattern 1: https://drive.google.com/open?id=FILE_ID
  RegExp regExp1 = RegExp(r'drive\.google\.com/open\?id=([^&]+)');
  Match? match1 = regExp1.firstMatch(url);
  if (match1 != null && match1.groupCount >= 1) {
    return match1.group(1);
  }

  // Pattern 2: https://drive.google.com/file/d/FILE_ID/view
  RegExp regExp2 = RegExp(r'drive\.google\.com/file/d/([^/]+)');
  Match? match2 = regExp2.firstMatch(url);
  if (match2 != null && match2.groupCount >= 1) {
    return match2.group(1);
  }

  // Pattern 3: https://drive.google.com/uc?id=FILE_ID
  RegExp regExp3 = RegExp(r'drive\.google\.com/uc\?id=([^&]+)');
  Match? match3 = regExp3.firstMatch(url);
  if (match3 != null && match3.groupCount >= 1) {
    return match3.group(1);
  }

  // If no patterns match
  return null;
}

String getGoogleDriveDirectUrl(String sharingUrl) {
  // Extract file ID from the URL
  final RegExp regExp = RegExp(r'id=([a-zA-Z0-9-_]+)');
  final Match? match = regExp.firstMatch(sharingUrl);

  if (match != null && match.groupCount >= 1) {
    final String fileId = match.group(1)!;
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }

  return sharingUrl; // Return original if parsing fails
}
