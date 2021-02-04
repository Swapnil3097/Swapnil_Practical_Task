import 'package:flutter/material.dart';

class SubFolder extends StatefulWidget {
  final String name;

  SubFolder({
    @required this.name,
  });
  @override
  _SubFolderState createState() => _SubFolderState();
}

class _SubFolderState extends State<SubFolder> {
  String title;
  List<String> foldersAdded;
  int currentIndex = 0;
  String newFolderName;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    title = widget.name;
    foldersAdded = ['${widget.name}'];
  }

  //no folder added
  Widget noFolders() {
    return Center(
      child: Text('Please Add Folder!'),
    );
  }

//folder listtile
  Widget folderView(String folderName) {
    return ListTile(
      onTap: () {
        if (mounted) {
          setState(() {
            currentIndex++;
            title = '$folderName';
          });
        }
        print('$currentIndex, ${foldersAdded.length}');
      },
      leading: CircleAvatar(
        child: Icon(Icons.folder),
      ),
      title: Text('$folderName'),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

//for adding new folder
  void addFolder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Folder'),
        content: TextFormField(
          onChanged: (value) {
            if (value != null) {
              newFolderName = value;
            }
          },
          decoration: InputDecoration(
              labelText: ' Folder Name',
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(),
              )),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  foldersAdded.add('$newFolderName');
                  Navigator.of(ctx).pop();
                });
                print('$currentIndex');
              }
            },
            child: Text('Add Folder'),
          ),
        ],
      ),
    );
  }

//on pressing back button
  Future<bool> onBackPress() {
    Future<bool> temp;
    print('$currentIndex');
    if (currentIndex == 0) {
      temp = Future.value(true);
    } else {
      if (mounted) {
        setState(() {
          currentIndex--;
        });
      }
      temp = Future.value(false);
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print('$foldersAdded');
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text('${foldersAdded[currentIndex]}'),
        ),
        body: foldersAdded.length == 1
            ? noFolders()
            : currentIndex + 1 < foldersAdded.length
                ? folderView('${foldersAdded[currentIndex + 1]}')
                : noFolders(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[800],
          onPressed: addFolder,
          tooltip: 'Add Folder',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
