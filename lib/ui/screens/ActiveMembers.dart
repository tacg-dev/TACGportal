import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/active_member_db_info.dart';
import 'package:tacgportal/data/services/api/active_member_db_service.dart';
import 'package:tacgportal/ui/widgets/active_member_card.dart';

class ActiveMembersPage extends StatefulWidget {
  const ActiveMembersPage({super.key});

  @override
  State<ActiveMembersPage> createState() => _ActiveMembersPageState();
}

class _ActiveMembersPageState extends State<ActiveMembersPage> {
  bool _isLoading = true;
  List<ActiveMemberDbInfo>? _activemembers;
  String? _error;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final members = await fetchActiveMemberDatabase();
      setState(() {
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

  @override
  Widget build(BuildContext context) {
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

    print(_activemembers);
    return Center(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              
              Container(
                width: card_width,
                child: ActiveMemberCard(member: _activemembers![0]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
