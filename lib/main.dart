import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

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
  String personJob; 
  int personAge;
   
  FormData(this.personName, this.personJob, this.personAge);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  int calculateAge(DateTime date) {
    var age;
    DateTime now = DateTime.now();
    print(date);
    age = now.year - date.year;
    if (now.month < date.month)
      age--;
    if (now.month == date.month)
      if (now.day < date.day)
        age--;

    return age;
  }

  void _sendDataToSecondScreen(BuildContext context) {
    Map formValues = _fbKey.currentState.value;
    var age = calculateAge(formValues['date']);
    final data = FormData(formValues['name'], formValues['job'], age);
    
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(data : data))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _fbKey,
        autovalidate: true,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            FormBuilderTextField(
              attribute: "name",
              decoration: InputDecoration(labelText: "Name"),
              validators: [FormBuilderValidators.required()],
            ),
            SizedBox(height: 20.0),

            FormBuilderDropdown(
              attribute: "job",
              decoration: InputDecoration(labelText: "Job"),
              // initialValue: 'Male',
              hint: Text('Select Job'),
              validators: [FormBuilderValidators.required()],
              items: ['Desenvolvedor', 'Adminstrador','Designer','Profissional de RH']
                .map((job) => DropdownMenuItem(
                  value: job,
                  child: Text("$job")
              )).toList(),
            ),
            SizedBox(height: 20.0),

            FormBuilderDateTimePicker(
              attribute: "date",
              inputType: InputType.date,
              format: DateFormat("dd-MM-yyyy"),
              validators: [FormBuilderValidators.required()],
              decoration:
                InputDecoration(labelText: "Date of birth"),
            ),
            SizedBox(height: 40.0),

            MaterialButton(
              child: Text("Submit"),
              onPressed: () {
                if (_fbKey.currentState.saveAndValidate()) {
                  _sendDataToSecondScreen(context);
                }
              },
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
            Text(data.personJob),
            SizedBox(height: 20.0),
            Text(data.personAge.toString()),
          ]
        )
      ),
    );
  }
}