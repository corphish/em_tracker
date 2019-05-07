import 'package:flutter/material.dart';
import 'item.dart';
import 'currency.dart';

void main() {
  runApp(IntroApp());
  ItemManager itemManager = ItemManager();
  itemManager.fetchSettings().then((_) {
    runApp(MainApp(itemManager: itemManager,));
  });
}

class IntroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intro',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(child: Icon(Icons.attach_money, size: 128, color: Colors.white,), padding: EdgeInsets.symmetric(vertical: 32, horizontal: 0)),
              SizedBox (child: LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),), width: 48, height: 2,),
            ],
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  final ItemManager itemManager;

  MainApp({Key key, this.itemManager}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMI Tracker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: MyHomePage(title: 'EMI Tracker', itemManager: itemManager),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.itemManager}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final ItemManager itemManager;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final titleController = TextEditingController();
  final valueController = TextEditingController();
  final durationController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    titleController.dispose();
    valueController.dispose();
    durationController.dispose();

    super.dispose();
  }

  void _showInputDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: SimpleDialog(
            title: Text("Add new item"),
            children: <Widget>[
              Padding(child: TextField(controller: titleController, decoration: InputDecoration(labelText: "Title",),), padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4)),
              Padding(child: TextField(controller: valueController, decoration: InputDecoration(labelText: "Value"), keyboardType: TextInputType.number,), padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4)),
              Padding(child: TextField(controller: durationController, decoration: InputDecoration(labelText: "Remaining installments"), keyboardType: TextInputType.number,), padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4)),
              Padding(
                child: RaisedButton(
                    child: Text("Create"),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        widget.itemManager.addItem(double.parse(valueController.text) ?? 0, titleController.text, int.parse(durationController.text ?? 0));
                        valueController.clear();
                        titleController.clear();
                        durationController.clear();
                      });
                    },
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                  ), 
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0)
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontFamily: 'Montserrat',
          )
        ),
        backgroundColor: Colors.white10,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            child: Text('EMI Tracker lets you add your current active EMIs (Equated Monthly Installments) and track them. It also shows an overview of how much money you need to pay per month, and the total money you would need to pay.'),
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16)
          ),
          Padding(
            child: Text('Overview', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.2),
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0)
          ),
          Center(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('${CurrencyManager.encode(widget.itemManager.total, widget.itemManager.currency)}', textAlign: TextAlign.center, textScaleFactor: 2.5,),
                        Text('Payable per month', textAlign: TextAlign.center, textScaleFactor: 0.8,),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('${CurrencyManager.encode(widget.itemManager.totalPayable, widget.itemManager.currency)}', textAlign: TextAlign.center, textScaleFactor: 2.5,),
                        Text('Total payable', textAlign: TextAlign.center, textScaleFactor: 0.8,),
                      ],
                    )
                  ],
                )
              ],
            ), 
            heightFactor: 1.6,
          ),
          Padding(
            child: Text('Details', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.2),
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0)
          ),
          Flexible(child: ListView.builder(
            itemCount: widget.itemManager.items.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor, child: Icon(Icons.attach_money, color: Colors.white)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.itemManager.items[index].title,),
                      Text("${widget.itemManager.items[index].formattedMonthsRemaining()}", textScaleFactor: 0.7,),
                    ],
                  ), 
                  trailing: Text("${widget.itemManager.items[index].value}"),
                ),
              );
            }
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
