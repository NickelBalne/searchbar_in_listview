import 'package:flutter/material.dart';
import 'dart:developer' as dev;

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
      });
      return;
    } else {
      setState(() {
        selectedListViewVisibility = true;
        unselectedItems.clear();
        unselectedItems.addAll(duplicateUnselectedItems);
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
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: searchEditingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Visibility(
              visible: selectedListViewVisibility,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){

                    },
                    title: Text(
                      '${selectedItems[index]}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight:FontWeight.bold
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: unselectedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {

                        if (searchEditingController.text.length == 0){

                          selectedItems.insert(0, unselectedItems[index]);
                          unselectedItems.removeAt(index);

                          duplicateUnselectedItems.removeAt(index);

                        }else{

                          selectedItems.insert(0, unselectedItems[index]);
                          var insertedItem = unselectedItems[index];

                          unselectedItems.removeAt(index);

                          if (duplicateUnselectedItems.contains(insertedItem)){
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
