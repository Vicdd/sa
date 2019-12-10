import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Demo';

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

class FormData {
  String personName;
  String jobName; 
  int personAge;
   
  FormData(this.personName, this.jobName, this.personAge);
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

  DateTime _date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _date)
      setState(() {_date = picked;});
  }

  final _nameController = TextEditingController();

  int calculateAge(DateTime _date) {
    var age;
    DateTime now = DateTime.now();

    age = now.year - _date.year;
    if (now.month < _date.month) {
      age--;
    } else if (now.month == _date.month) {
      if (now.day < _date.day) {
        age--;
      }
    }

    return age;
  }

  void _sendDataToSecondScreen(BuildContext context) {
    var age = calculateAge(_date);
    final data = FormData(_nameController.text, selectedType, age);
    
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(data : data))
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
                isExpanded: true,
                hint: Text(
                  'Choose Job',
                ),
              ),
              SizedBox(height: 20.0),
              Text('Date selected: ${_date.day}/${_date.month}/${_date.year}'),
              RaisedButton(
                child: Text('Date of Birth'),
                onPressed: (){
                  _selectDate(context);
                }
              ),
              SizedBox(height: 40.0),
              RaisedButton(
                child: Text('Submit'),
                onPressed: (){
                  if (_formKeyValue.currentState.validate()) {
                    _sendDataToSecondScreen(context);
                  }
                }
              ),
            ],
          ),
        ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final FormData data;

  SecondScreen({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second screen')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(data.personName),
            SizedBox(height: 20.0),
            Text(data.jobName),
            SizedBox(height: 20.0),
            Text(data.personAge.toString() + ' anos')
          ]
        )
      ),
    );
  }
}