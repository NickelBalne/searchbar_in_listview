import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchEditingController = TextEditingController();

  final totalItems = ["One", "Two", "Three", "Four", "Five", "Six"];
  var selectedItems = List<String>();
  var unselectedItems = List<String>();
  var duplicateUnselectedItems = List<String>();
  bool selectedListViewVisibility = true;
  bool addSuffixButtonInSearchBar = false;

  @override
  void initState() {
    unselectedItems.addAll(totalItems);
    duplicateUnselectedItems.addAll(totalItems);

    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(unselectedItems);

    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        selectedListViewVisibility = false;
        unselectedItems.clear();
        unselectedItems.addAll(dummyListData);

        if (unselectedItems.length == 0) {
          debugPrint("While Entering Empty");
          addSuffixButtonInSearchBar = true;
        } else {
//          addSuffixButtonInSearchBar = false;
          debugPrint("While Entering Not Empty");
        }
      });
      return;
    } else {
      setState(() {
        selectedListViewVisibility = true;
        unselectedItems.clear();
        unselectedItems.addAll(duplicateUnselectedItems);

        if (unselectedItems.length == 0) {
          debugPrint("While clearing Empty");
//          addSuffixButtonInSearchBar = true;
        } else {
          addSuffixButtonInSearchBar = false;
          debugPrint("While clearing Not Empty");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Bar"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchEditingController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: "Search Instruction",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                  suffix: Visibility(
                    visible: addSuffixButtonInSearchBar,
                    child: IconButton(
                        icon: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () {
                          debugPrint("Add button tapped");
                        }),
                  ),
//                  border: OutlineInputBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                ),
              ),
            ),
            Visibility(
              visible: selectedListViewVisibility,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          icon: Icons.edit,
                          caption: 'EDIT',
                          color: Colors.blue,
                          closeOnTap: true,
                          onTap: () {
//                            print("Edit ${selectedItems[index]} is Clicked");

                            upperListViewEditButtonTapped(index);
                          }),
                      IconSlideAction(
                          icon: Icons.delete,
                          color: Colors.red,
                          caption: 'DELETE',
                          closeOnTap: true,
                          onTap: () {
                            print("Delete ${selectedItems[index]} is Clicked");

                            setState(() {
                              unselectedItems.insert(0, selectedItems[index]);
                              duplicateUnselectedItems.insert(
                                  0, selectedItems[index]);

                              selectedItems.removeAt(index);
                            });
                          })
                    ],
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          unselectedItems.insert(0, selectedItems[index]);
                          duplicateUnselectedItems.insert(
                              0, selectedItems[index]);

                          selectedItems.removeAt(index);
                        });
                      },
                      title: Text(
                        '${selectedItems[index]}',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    actionPane: SlidableDrawerActionPane(),
                  );
                  ;
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: unselectedItems.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          icon: Icons.edit,
                          caption: 'Edit',
                          color: Colors.red,
                          closeOnTap: true,
                          onTap: () {
                            print("Edit ${unselectedItems[index]} is Clicked");
                          })
                    ],
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          if (searchEditingController.text.length == 0) {
                            selectedItems.insert(0, unselectedItems[index]);
                            unselectedItems.removeAt(index);

                            duplicateUnselectedItems.removeAt(index);
                          } else {
                            selectedItems.insert(0, unselectedItems[index]);
                            var insertedItem = unselectedItems[index];

                            unselectedItems.removeAt(index);

                            if (duplicateUnselectedItems
                                .contains(insertedItem)) {
                              duplicateUnselectedItems.remove(insertedItem);
                            }

                            unselectedItems.clear();
                            unselectedItems.addAll(duplicateUnselectedItems);

                            searchEditingController.text = "";
                          }

                          selectedListViewVisibility = true;
                        });
                      },
                      title: Text('${unselectedItems[index]}'),
                    ),
                    actionPane: SlidableDrawerActionPane(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _editedInstructionInformation = 'No Information Yet';

  void updateInformation(String information) {
    setState(() {
      _editedInstructionInformation = information;
      debugPrint("Retrived Information : $information");
    });
  }

  _displayDialog(
      BuildContext context, instructionName, selectedInstructionIndex) async {
    TextEditingController _instructionTextController =
        new TextEditingController();

    _instructionTextController.text = instructionName;

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                              ),
                            )),
                      ),
                      Expanded(
                          flex: 4,
                          child: Text(
                            instructionName,
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                            onPressed: () {
//                              debugPrint("Save button tapped : ${_instructionTextController.text}");
                              debugPrint(
                                  "SelectedIndex:$selectedInstructionIndex");
                              Navigator.pop(
                                  context, _instructionTextController.text);
                            },
                            child: Text(
                              "Save",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              content: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                width: 300.0,
                height: 300.0,
                child: TextField(
                  controller: _instructionTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            );
          });
        });
  }

  void upperListViewEditButtonTapped(int index) async {
    final information =
        await _displayDialog(context, "${selectedItems[index]}", index);
    updateInformation(information);
  }
}
