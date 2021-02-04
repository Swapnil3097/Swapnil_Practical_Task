import 'package:flutter/material.dart';
import 'package:practical_task/SubFolder.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
  List folder = [];
  bool showList = true;

  @override
  Widget build(BuildContext context) {
    Widget _buttons;

    _buttons = FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
        onPressed: () {
          setState(() {
            addFolder();
          });
        });

    changeMode() {
      setState(() {
        showList ? showList = false : showList = true;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: _selectionMode
              ? Text('Selected ${_selectedIndexList.length}')
              : Text('Create Folder'),
          backgroundColor: Colors.blue[800],
          actions: <Widget>[
            IconButton(
                icon: Icon(showList ? Icons.list : Icons.grid_on),
                onPressed: () {
                  changeMode();
                }),
            _selectionMode
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {})
                : SizedBox()
          ],
        ),
        backgroundColor: Colors.white,
        body: showList ? _createList() : _createBody(),
        floatingActionButton: _buttons);
  }

  @override
  void initState() {
    super.initState();
  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }


//ListView Builder
  Widget _createList() {
    return ListView.builder(
      primary: false,
      itemCount: folder.length,
      itemBuilder: (BuildContext context, int index) {
        return getListTile(index);
      },
      padding: const EdgeInsets.all(10.0),
    );
  }
//GridView Builder
  Widget _createBody() {
    return GridView.builder(
      primary: false,
      itemCount: folder.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      padding: const EdgeInsets.all(10.0),
    );
  }

  GridTile getGridTile(int index) {
    if (_selectionMode) {
      return GridTile(
          header: GridTileBar(
            leading: Icon(
              _selectedIndexList.contains(index)
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index)
                  ? Colors.green
                  : Colors.black,
            ),
          ),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[50], width: 30.0)),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      child: Icon(Icons.folder, size: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      folder[index],
                      // fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(enable: false, index: -1);
              });
            },
            onTap: () {
              setState(() {
                if (_selectedIndexList.contains(index)) {
                  _selectedIndexList.remove(index);
                } else {
                  _selectedIndexList.add(index);
                }
              });
            },
          ));
    } else {
      return GridTile(
        child: InkResponse(
          child: Container(
            color: Colors.blue[50],
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    child: Icon(
                      Icons.folder,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    folder[index],
                  ),
                ],
              ),
            ),
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubFolder(
                        name: folder[index],
                      )),
            );
          },
        ),
      );
    }
  }

  Container getListTile(int index) {
    if (_selectionMode) {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        color: _selectedIndexList.contains(index)
            ? Colors.blue[50]
            : Colors.transparent,
        child: Card(
          child: ListTile(
            trailing: Icon(
              _selectedIndexList.contains(index)
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index)
                  ? Colors.green
                  : Colors.black,
            ),
            title: Text(
              folder[index],
            ),

            leading: CircleAvatar(
              child: Icon(
                Icons.folder,
                color: _selectedIndexList.contains(index)
                    ? Colors.green
                    : Colors.white,
              ),
            ),

            onLongPress: () {
              setState(() {
                _changeSelection(enable: false, index: -1);
              });
            },
            onTap: () {
              setState(() {
                if (_selectedIndexList.contains(index)) {
                  _selectedIndexList.remove(index);
                } else {
                  _selectedIndexList.add(index);
                }
              });
            },
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.folder),
            ),
            trailing: Icon(Icons.more_vert),
            title: Text(
              folder[index],
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(enable: true, index: index);
              });
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubFolder(
                          name: folder[index],
                        )),
              );
            },
          ),
        ),
      );
    }
  }

// DialogBox
  void addFolder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Folder'),
        content: TextFormField(
          controller: controller,
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
                if (controller.text == null || controller.text == '') {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    folder.add(controller.text);
                    controller.clear();
                    Navigator.of(ctx).pop();
                  });
                }
              }
            },
            child: Text('Add Folder'),
          ),
        ],
      ),
    );
  }
}
