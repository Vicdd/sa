import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
    int age;
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
            Image.asset("assets/images/img1.png"),
            Container (
              padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0), 
              child: FormBuilder(
                key: _fbKey,
                autovalidate: false,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "name",
                      maxLines: 1,
                      decoration: InputDecoration(labelText: "Full Name"),
                      validators: [FormBuilderValidators.required()],
                    ),
                    SizedBox(height: 30.0),

                    FormBuilderDropdown(
                      attribute: "job",
                      hint: Text('Select Job'),
                      decoration: InputDecoration(filled: true, border: InputBorder.none),
                      validators: [FormBuilderValidators.required()],
                      iconSize: 0,
                      items: [
                        'Desenvolvedor',
                        'Adminstrador',
                        'Designer',
                        'Profissional de RH'
                      ]
                          .map((job) =>
                              DropdownMenuItem(value: job, child: Text(job)))
                          .toList(),
                    ),
                    SizedBox(height: 15.0),

                    FormBuilderDateTimePicker(
                      attribute: "date",
                      inputType: InputType.date,
                      format: DateFormat("dd-MM-yyyy"),
                      validators: [FormBuilderValidators.required()],
                      decoration: InputDecoration(labelText: "Date of birth"),
                    ),
                    SizedBox(height: 20.0),

                    MaterialButton(
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          _sendDataToSecondScreen(context);
                        }
                      },
                      splashColor: Colors.transparent,  
                      highlightColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFA074E7),
                              Color(0xFFE6ABC1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
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
