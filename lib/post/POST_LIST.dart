import 'package:flutter/material.dart';
import 'package:wereads/post/COURIER.dart';
import 'package:wereads/post/HANDDELIVERY.dart';
import 'package:wereads/post/SPEEDPOST.dart';
import 'package:wereads/post/registerpost.dart';

class RegisterpostList extends StatelessWidget {
  const RegisterpostList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('POST LIST', style: TextStyle(color: Colors.white)),
        ),
        body: const Column(
          children: [
            TabBar(
              dividerColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'REGISTERPOST'),
                Tab(text: 'SPEEDPOST'),
                Tab(text: 'COURIER'),
                Tab(text: 'HANDDELIVERY'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RegisterPostList(),
                  SPEEDPOSTList(),
                  COURIERList(),
                  HANDDELIVERYList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubTabPage2 extends StatelessWidget {
  const SubTabPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const TabBar(
            tabs: [
              Tab(text: 'Sender'),
              Tab(text: 'Receiver'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for SubTab 1')),
            Center(child: Text('Content for SubTab 2')),
          ],
        ),
      ),
    );
  }
}

class SubTabPage3 extends StatelessWidget {
  const SubTabPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const TabBar(
            tabs: [
              Tab(text: 'Sender'),
              Tab(text: 'Receiver'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for SubTab 1')),
            Center(child: Text('Content for SubTab 2')),
          ],
        ),
      ),
    );
  }
}

class SubTabPage4 extends StatelessWidget {
  const SubTabPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const TabBar(
            tabs: [
              Tab(text: 'Sender'),
              Tab(text: 'Receiver'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for SubTab 1')),
            Center(child: Text('Content for SubTab 2')),
          ],
        ),
      ),
    );
  }
}
