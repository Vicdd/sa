import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedType;
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();
  List<String> jobName = <String>[
    'Desenvolvedor',
    'Adminstrador',
    'Designer',
    'Profissional de RH'
  ];

  String _date = "01 - 01 - 01";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _date)
      setState(() {_date = "${picked.month} - ${picked.day} - ${picked.year}";});
  }

  final _nameController = TextEditingController();

  void _sendDataToSecondScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(list: [_nameController.text, selectedType, _date.toString()]))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKeyValue,
          autovalidate: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your Full Name',
                  labelText: 'Full Name',
                ),
                controller: _nameController
              ),
              SizedBox(height: 20.0),
              DropdownButton(
                items: jobName
                    .map((value) => DropdownMenuItem(
                          child: Text(
                            value,
                          ),
                          value: value,
                        ))
                    .toList(),
                onChanged: (selectedAccountType) {
                  setState(() {
                    selectedType = selectedAccountType;
                  });
                },
                value: selectedType,
                isExpanded: false,
                hint: Text(
                  'Choose Job',
                ),
              ),
              SizedBox(height: 20.0),
              Text('Date selected: $_date'),
              RaisedButton(
                child: Text('Date of Birth'),
                onPressed: (){
                  _selectDate(context);
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Submit'),
                onPressed: (){
                  _sendDataToSecondScreen(context);
                }
              ),
            ],
          ),
        ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final List list;

  SecondScreen({Key key, @required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second screen')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(list[0]),
            SizedBox(height: 20.0),
            Text(list[1]),
            SizedBox(height: 20.0),
            Text(list[2])
          ]
        )
      ),
    );
  }
}