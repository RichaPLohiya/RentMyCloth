import 'package:flutter/material.dart';
import 'package:clothsonrent/src/widgets/bottomnavigationbar.dart';
import 'package:clothsonrent/src/view/my_request.dart';
import 'package:clothsonrent/src/view/other_request.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Notification",
            style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'My Requests'),
              Tab(text: 'Other Requests'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              MyRequestScreen(),
              OtherRequestScreen(),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 2),
      ),
    );
  }
}
