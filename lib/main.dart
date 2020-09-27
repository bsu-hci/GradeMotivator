import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(GradeMotivator());

class GenerateGrade extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GenerateGradeState();
}

class Grade {
  int _userScore;
  int _totalPossiblePoints;
  bool _show;
  String _grade;

  Grade() {
    _grade = "";
    _show = false;
  }
}

class Show extends StatelessWidget {
  final String _grade;
  Show(this._grade);

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
        appBar: AppBar(
            title: Text(
                "Use this to calculate fraction based grades! (Whole numbers only for now) (For %, enter 100 for the total points)")),
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
  var _totalPosibleInput;
  Grade grade = new Grade();

  void _onCalculateButtonPressed() {
    setState(() {
      this.grade._show = true;
      this.grade._grade = calculateGrade(
          this.grade._userScore, this.grade._totalPossiblePoints);
    });
  }

  String calculateGrade(int myScore, int totalPossiblePoints) {
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

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _fk,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.right,
              decoration: const InputDecoration(hintText: "My Points"),
              keyboardType: TextInputType.number,
              onSaved: (newValue) {
                this._numberGradeInput = int.parse(newValue);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Must enter grade";
                }
                return null;
              },
            ),
            TextFormField(
              textAlign: TextAlign.right,
              decoration:
                  const InputDecoration(hintText: "Total Possible Points"),
              keyboardType: TextInputType.number,
              onSaved: (newNumber) {
                this._totalPosibleInput = int.parse(newNumber);
              },
              validator: (number) {
                if (number.isEmpty) {
                  return "Must enter a total";
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: RaisedButton(
                onPressed: () {
                  if (_fk.currentState.validate()) {
                    _fk.currentState.save();
                    this.grade._userScore = this._numberGradeInput;
                    this.grade._totalPossiblePoints = this._totalPosibleInput;
                    _onCalculateButtonPressed();
                  }
                },
                child: Text('Calculate Grade'),
              ),
            ),
            Flexible(
                child: this.grade._show ? Show(this.grade._grade) : Text(""))
          ],
        ));
  }
}
