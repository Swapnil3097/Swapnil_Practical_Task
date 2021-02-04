import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class FileUpload extends StatefulWidget {
  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var myData;
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
  File _image, _image1;
  final picker = ImagePicker();
  List<String> userList;
  List<File> images = [];
  List<File> images1 = [];
  bool _loadingPath = false;
  var _path;
  String assignedId;
  Map<String, String> _paths;
  File file;
  List<File> file1 = [];
  String _extension;
  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      setState(() {
        Navigator.pop(context);
        _image = File(pickedFile.path);
        images.add(_image);
      });
    } catch (e) {
      print(e);
    }
  }

  _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _paths = await FilePicker.getMultiFilePath(
          type: FileType.image,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll('', '')?.split(',')
              : null);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      Navigator.pop(context);
      _loadingPath = false;
      if (_paths != null) {
        for (var i in _paths.entries) {
          var abc = i.value;
          file = new File(abc);
          images.add(file);
          print(images);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _selectionMode
            ? Text('Selected ${_selectedIndexList.length}')
            : Text('File Upload'),
        backgroundColor: Colors.blue[800],
      ),
      body: _createBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          this
              ._scaffoldKey
              .currentState
              .showBottomSheet((ctx) => _buildBottomSheet(ctx));
        },
        tooltip: 'File Upload',
        child: Icon(Icons.file_upload),
      ),
    );
  }

  Widget _createBody() {
    return GridView.builder(
      primary: false,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      padding: const EdgeInsets.all(10.0),
    );
  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
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
              child: Image.file(
                images[index],
                fit: BoxFit.cover,
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
            child: Image.file(
              images[index],
              fit: BoxFit.cover,
            ),
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
          onTap: () {},
        ),
      );
    }
  }

  Container _buildBottomSheet(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        // height: 300,
        constraints: BoxConstraints(minHeight: 100, maxHeight: 150),
        // padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff669cb2), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.green[50].withOpacity(0.7),
                        child: IconButton(
                          padding: EdgeInsets.all(15.0),
                          icon: Icon(FontAwesomeIcons.cameraRetro),
                          color: Color(0xff669cb2),
                          iconSize: 30.0,
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Camera',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.green[50].withOpacity(0.7),
                        child: IconButton(
                          padding: EdgeInsets.all(15.0),
                          icon: Icon(FontAwesomeIcons.photoVideo),
                          color: Color(0xff669cb2),
                          iconSize: 30.0,
                          onPressed: () {
                            _openFileExplorer();
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Gallery',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
