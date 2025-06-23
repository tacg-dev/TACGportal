import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/chat/v1.dart';
import 'package:tacgportal/data/models/active_member_db_info.dart';
import 'package:tacgportal/data/services/api/active_member_db_service.dart';
import 'package:tacgportal/ui/widgets/active_member_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveMembersPage extends StatefulWidget {
  const ActiveMembersPage({super.key});

  @override
  State<ActiveMembersPage> createState() => _ActiveMembersPageState();
}

class _ActiveMembersPageState extends State<ActiveMembersPage> {
  bool _isLoading = true;
  List<ActiveMemberDbInfo>? _activemembers;
  List<ActiveMemberDbInfo>? _activeleaders;
  String? _error;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _activemembers = [];
    _activeleaders = [];
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final leaders = await fetchActiveMemberDatabase(true);
      if (leaders.any((member) => member.role?.toLowerCase() == 'president')) {
        final presidentIndex = leaders.indexWhere((member) => member.role?.toLowerCase() == 'president');
        if (presidentIndex > 0) {
          final president = leaders.removeAt(presidentIndex);
          leaders.insert(0, president);
        }
      }

      final members = await fetchActiveMemberDatabase(false);
      setState(() {
        _activeleaders = leaders;
        _activemembers = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _launchURL() async {
    const url =
        "https://www.tamuconsultinggroup.com/"; // Replace with your external website URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildSectionHeader(String title) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: screenWidth < 600
                  ? 20
                  : screenWidth < 1024
                      ? 24
                      : 28,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 1,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(
          'Error loading data: $_error',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    int cardsPerRow;

    if (screenWidth < 600) {
      // Mobile
      cardsPerRow = 1;
    } else if (screenWidth < 1024) {
      // Tablet
      cardsPerRow = 2;
    } else if (screenWidth < 1440) {
      // Desktop
      cardsPerRow = 4;
    } else {
      // Extra large
      cardsPerRow = 5;
    }

    final double horizontalPadding = 16.0;
    final double cardSpacing = 16.0;
    final double totalSpacing =
        (cardsPerRow - 1) * cardSpacing + 2 * horizontalPadding;
    final double card_width = (screenWidth - totalSpacing) / cardsPerRow;

    for (final member in _activeleaders!) {
      print(member.role);
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header / appbar of the page
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Active Members',
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.normal, // This is equivalent to 400
                    fontSize: screenWidth < 600
                        ? 22
                        : screenWidth < 1024
                            ? 28
                            : screenWidth < 1440
                                ? 32
                                : 36,
                  ),
                ),
                const SizedBox(width: 8), // Add some spacing
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    _launchURL();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            floating: true,
            snap: true,
            centerTitle: true,
          ),
          
          // Leaders Section
          SliverToBoxAdapter(
              child: _buildSectionHeader('Leaders'),
            ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: cardsPerRow,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childCount: _activeleaders!.length,
              itemBuilder: (context, index) {
                final member = _activeleaders![index];
                return ActiveMemberCard(member: member);
              },
            ),
          ),
      
          SliverToBoxAdapter(
            child: _buildSectionHeader('Members'),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: cardsPerRow,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childCount: _activemembers!.length,
              itemBuilder: (context, index) {
                final member = _activemembers![index];
                return ActiveMemberCard(member: member);
              },
            ),
          ),
        ],
      ),
    );
  }
}
