import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practical_task/FileUpload.dart';
import 'package:practical_task/HomeScreen.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<BottomNavigation> {
  int _selectedTab = 0;
  final _pageOptions = [HomePage(), FileUpload()];

  @override
  void initState() {
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Color(0xffffffff),
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Color(0xff44aae4),
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.white))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedTab,
              onTap: (int index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              unselectedItemColor: Color(0xff69737f),
              // fixedColor: Color(0xffFF5555),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.folder), title: Text('Create Folder')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.filter), title: Text('Upload Files')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
