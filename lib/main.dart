import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(GradeMotivator());

class GenerateGrade extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GenerateGradeState();
}

class Grade {
  double _userScore;
  double _totalPossiblePoints;
  bool _show;
  String _grade;

  Grade() {
    _grade = "";
    _show = false;
  }
}

class GradeMessage extends StatelessWidget {
  final String _grade;
  GradeMessage(this._grade);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Text(
        "You recieved a(n)",
        textAlign: TextAlign.center,
      ),
      Text(
        _grade,
        textScaleFactor: 2,
        textAlign: TextAlign.center,
      )
    ]);
  }
}

class GradeMotivator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to Grade Motivator",
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Use this to calculate your grades!")),
        backgroundColor: Colors.lightBlueAccent,
        body: Center(
            child: Container(
          constraints: BoxConstraints(maxWidth: 350),
          padding: EdgeInsets.all(30),
          child: GenerateGrade(),
        )),
      ),
    );
  }
}

class _GenerateGradeState extends State<GenerateGrade> {
  final _fk = GlobalKey<FormState>();
  var _numberGradeInput;
  var _totalPossibleInput;
  Grade grade = new Grade();
  String _dropdown = "Standard";

  void _onSubmit() {
    setState(() {
      this.grade._show = true;
      if (this._dropdown == "Standard") {
        print("Standard grading");
        this.grade._grade = _calculateStandardGrade(
            this.grade._userScore, this.grade._totalPossiblePoints);
      }
      if (this._dropdown == "Triage") {
        print("Triage grading");
        this.grade._grade = _calculateTriageGrade(
            this.grade._userScore, this.grade._totalPossiblePoints);
      }
    });
  }

  String _calculateStandardGrade(double myScore, double totalPossiblePoints) {
    double percentage = (myScore / totalPossiblePoints) * 100;
    if (percentage >= 100)
      return "A+ : Outstanding work! Extra credit pays off!";
    if (percentage >= 90)
      return "A : Great Job! Keep It up! Aim even higher next time!";
    if (percentage >= 80)
      return "B : Not Too Bad! One step below perfection! Keep going!";
    if (percentage >= 70)
      return "C : Still Passing, You can do better! Try asking for some extra help.";
    if (percentage >= 60)
      return "D : Maybe try making some notecards! Better study habits are a must.";
    if (percentage < 60)
      return "F : Spend more time hittin' the books! You will get it next time.";
    return "Invalid";
  }

  String _calculateTriageGrade(double myScore, double totalPossiblePoints) {
    double percent = (myScore / totalPossiblePoints);
    if (percent > (17.0 / 18.0))
      return "A : Great Job! Keep It up! Aim even higher next time!";
    if (percent > (5.0 / 6.0))
      return "B : Not Too Bad! One step below perfection! Keep going!";
    if (percent > (2.0 / 3.0))
      return "C : Still Passing, You can do better! Try asking for some extra help.";
    if (percent > (7.0 / 15.0))
      return "D : Maybe try making some notecards! Better study habits are a must.";
    if (percent <= (7.0 / 15.0))
      return "F : Spend more time hittin' the books! You will get it next time.";
    return "Invalid";
  }

  String _validate(String value) {
    if (double.tryParse(value) == null || value.isEmpty) {
      return "Make sure you entered a number";
    }
    return null;
  }

  Widget _dropDown() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0),
        child: Column(
          children: [
            Text("Choose a Grading Scale:"),
            DropdownButtonFormField(
                dropdownColor: Colors.grey,
                value: "Standard",
                items: <String>["Standard", "Triage"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String value) {
                  this._dropdown = value;
                })
          ],
        ));
  }

  Widget _myPointMessage() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(children: [
          Text("Enter the points you got correct:"),
        ]));
  }

  Widget _totalPointMessage() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(children: [
          Text("Enter the total points of the assignment:"),
        ]));
  }

  Widget _myScoreText() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        hintText: "*HERE*",
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        String _validation = _validate(value);
        if (_validation == null) {
          this._numberGradeInput = double.parse(value);
        }
        return _validation;
      },
    );
  }

  Widget _totalPossibleText() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: const InputDecoration(hintText: "*HERE*"),
      keyboardType: TextInputType.number,
      validator: (value) {
        String _validation = _validate(value);
        if (_validation == null) {
          double _total = double.parse(value);
          if (_total == 0) {
            return "Must be a non-zero value";
          }
          this._totalPossibleInput = _total;
        }
        return _validation;
      },
    );
  }

  Widget _calculateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: RaisedButton(
        color: Colors.grey,
        onPressed: () {
          if (_fk.currentState.validate()) {
            _fk.currentState.save();
            this.grade._userScore = this._numberGradeInput;
            this.grade._totalPossiblePoints = this._totalPossibleInput;
            print(this._dropdown);
            _onSubmit();
          }
        },
        child: Text('Calculate Grade'),
      ),
    );
  }

  Widget _gradeMessage() {
    return Flexible(
        child: this.grade._show ? GradeMessage(this.grade._grade) : Text(""));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _fk,
        child: Column(
          children: <Widget>[
            _dropDown(),
            _myPointMessage(),
            _myScoreText(),
            _totalPointMessage(),
            _totalPossibleText(),
            _calculateButton(),
            _gradeMessage()
          ],
        ));
  }
}
