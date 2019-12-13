import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

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
    DateTime now = DateTime.now();
    int age = now.year - date.year;

    if (now.month < date.month) age--;
    if (now.month == date.month) if (now.day < date.day) age--;

    return age;
  }

  void _sendDataToSecondScreen(BuildContext context) {
    Map formValues = _fbKey.currentState.value;
    var age = calculateAge(formValues['date']);
    final data = FormData(formValues['name'], formValues['job'], age);

    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => SecondScreen(data: data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/img1.png'),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: FormBuilder(
                key: _fbKey,
                autovalidate: false,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE8E8E8),
                            width: 5.0,
                          ),
                        ),
                      ),
                      child: FormBuilderTextField(
                        attribute: "name",
                        style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'OpenSans',
                            color: Color(0xFF757575)),
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        maxLines: 1,
                        validators: [FormBuilderValidators.required()],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    Material(
                      elevation: 8.0,
                      shadowColor: Colors.grey,
                      child: FormBuilderDropdown(
                        attribute: "job",
                        hint: Text('Select Job',
                            style: TextStyle(
                                color: Color(0xFF757575), fontSize: 22)),
                        decoration: InputDecoration(
                            filled: true, border: InputBorder.none),
                        style:
                            TextStyle(color: Color(0xFF757575), fontSize: 22),
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
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFFE8E8E8), width: 5.0))),
                      child: FormBuilderDateTimePicker(
                        attribute: "date",
                        inputType: InputType.date,
                        format: DateFormat("dd-MM-yyyy"),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().add(Duration(hours: 1)),
                        validators: [FormBuilderValidators.required()],
                        style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'OpenSans',
                            color: Color(0xFF757575)),
                        decoration: InputDecoration(
                          labelText: "Date of birth",
                          labelStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 42.0),
                    Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.2),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_left,
                            size: 28,
                            color: Color(0xFF0D2945),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.08),
                          Icon(
                            Icons.fiber_manual_record,
                            size: 12,
                            color: Color(0xFFA6003E),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04),
                          Container(
                            width: 9,
                            height: 9,
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
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.06),
                          RawMaterialButton(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.08,
                                maxHeight:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  _sendDataToSecondScreen(context);
                                }
                              },
                              child: Container(
                                  width: double.infinity, //match_parent
                                  height: double.infinity,
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
                                  child: Icon(Icons.arrow_right,
                                      color: Colors.white))),
                        ],
                      ),
                    )
                  ],
                ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/img2.png'),
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.personName.replaceAll(' ', '\u00A0'), //No-Break
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  data.personJob,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  data.personAge.toString() + " anos",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.165),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      color: Color(0xFFD4E1F3),
                      iconSize: 28,
                      onPressed: () {
                        Navigator.pop(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 12,
                      color: Color(0xFF0D2945),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 12,
                      color: Color(0xFFD4E1F3),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFD4E1F3)),
                      child: Icon(Icons.arrow_right,
                          size: 28, color: Color(0xFF0D2945)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
