import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:study/components/Resultado.dart';

//ignore: must_be_immutable
class GetJsonQUIMICA extends StatelessWidget {
  late String materias;
   GetJsonQUIMICA(this.materias);
  late String assettoload;

  setasset() {
    if (materias == "Química Básica") {  
      assettoload = "assets/quimica_basica.json";
    } else if (materias == "Química Geral") {
      assettoload = "assets/quimica_geral.json";
    } else if (materias == "Físico-Química") {
      assettoload = "assets/fisico_quimica.json";
    } else if (materias == "Química Orgânica") {
      assettoload = "assets/quimica_organica.json";
    } else if (materias == "Meio Ambiente") {
      assettoload = "assets/meio_ambiente.json";     
    } else {
      assettoload = "assets/energia.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setasset();
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString(assettoload, cache: true),
      builder: (context, snapshot) {
        List? mydata = json.decode(snapshot.data.toString());
        if (mydata == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Carregando",
              ),
            ),
          );
        } else {
          return QuizPage(mydata: mydata);
        }
      },
    );
  }
}

class QuizPage extends StatefulWidget {
  final List mydata;

  QuizPage({ Key? key, required this.mydata}) : super(key: key);
  @override
  QuizPageState createState() => QuizPageState(mydata);
}

class QuizPageState extends State<QuizPage> {
  final List mydata;
  QuizPageState(this.mydata);

  Color colortoshow = Colors.blue;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int pontos = 0;
  int i = 1; //PRIMEIRA QUESTÃO
  bool disableAnswer = false;
  int j = 1; //de qnts em qnts questões vai 
  var randomarray;

  Map<String, Color> btncolor = {
    "a": Colors.blue,
    "b": Colors.blue,
    "c": Colors.blue,
    "d": Colors.blue,
  };

  genrandomarray() {
    var distinctIds = [];
    var rand = new Random();
    // ignore: unused_local_variable
    for (int i = 0;;) {
      distinctIds.add(rand.nextInt(10) + 1);
      randomarray = distinctIds.toSet().toList();
      if (randomarray.length < 10)  {   //NUMERO DE QUESTÕES
        continue;
      } else {
        break;
      }
    }
    print(randomarray);
  }

  @override
  void initState() {
    genrandomarray();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void nextquestion() {
    setState(() {
      if (j < 10) {
        i = randomarray[j];
        j++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResultPage(pontos: pontos),
        ));
      }
      btncolor["a"] = Colors.blue;
      btncolor["b"] = Colors.blue;
      btncolor["c"] = Colors.blue;
      btncolor["d"] = Colors.blue;
      disableAnswer = false;
    });
  }

  void checkanswer(String k) {
    if (mydata[2][i.toString()] == mydata[1][i.toString()][k]) {
      pontos = pontos + 1;
      colortoshow = right;
    } else {
      colortoshow = wrong;
    }
    setState(() {
      btncolor[k] = colortoshow;
      disableAnswer = true;
    });
    Timer(Duration(seconds: 1), nextquestion);
  }

  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 30.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: Text(
          mydata[1][i.toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 3,
        ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Text(
          "Study",
          style: TextStyle(
            fontFamily: "Quando",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: Text(
                mydata[0][i.toString()],
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: "Quando",
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: AbsorbPointer(
              absorbing: disableAnswer,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choicebutton('a'),
                    choicebutton('b'),
                    choicebutton('c'),
                    choicebutton('d'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
