import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
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

    age = now.year - date.year;
    if (now.month < date.month) age--;
    if (now.month == date.month) if (now.day < date.day) age--;

    return age;
  }

  void _sendDataToSecondScreen(BuildContext context) {
    Map formValues = _fbKey.currentState.value;
    var age = calculateAge(formValues['date']);
    final data = FormData(formValues['name'], formValues['job'], age);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SecondScreen(data: data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset("assets/images/img3.png"),
            FormBuilder(
              key: _fbKey,
              autovalidate: false,
              initialValue: {
                'name': "",
                'job': 'Select Job',
                'date': DateTime.now(),
              },
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "name",
                    decoration: InputDecoration(labelText: "Name"),
                    validators: [FormBuilderValidators.required()],
                  ),
                  FormBuilderDropdown(
                    attribute: "job",
                    hint: Text('Select Job'),
                    validators: [FormBuilderValidators.required()],
                    items: [
                      'Select Job',
                      'Desenvolvedor',
                      'Adminstrador',
                      'Designer',
                      'Profissional de RH'
                    ]
                        .map((job) =>
                            DropdownMenuItem(value: job, child: Text("$job")))
                        .toList(),
                  ),
                  FormBuilderDateTimePicker(
                    attribute: "date",
                    inputType: InputType.date,
                    format: DateFormat("dd-MM-yyyy"),
                    validators: [FormBuilderValidators.required()],
                    decoration: InputDecoration(labelText: "Date of birth"),
                  ),
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
      body: Column(
        children: <Widget>[
          Image.asset("assets/images/img2.png"),
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.personName.replaceAll(' ', '\u00A0'), //No-Break
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 36,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  data.personJob,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 36,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  data.personAge.toString() + " anos",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
