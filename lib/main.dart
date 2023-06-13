//

import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizHomePage(),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  String _selectedQuizType = '';

  List<Map<String, dynamic>> _footballQuestions = [
    {
      'question':
          'Quelle équipe a remporté la Coupe du Monde de football en 2018 ?',
      'options': ['France', 'Brésil', 'Allemagne', 'Espagne'],
      'correctAnswerIndex': 0,
    },
    {
      'question': 'Qui a remporté le Ballon d\'Or en 2020 ?',
      'options': [
        'Lionel Messi',
        'Cristiano Ronaldo',
        'Robert Lewandowski',
        'Neymar'
      ],
      'correctAnswerIndex': 2,
    },
    // Ajouter plus de questions de football ici...
  ];

  List<Map<String, dynamic>> _histoireQuestions = [
    {
      'question': 'Quand a eu lieu la Révolution française ?',
      'options': ['1789', '1812', '1492', '1945'],
      'correctAnswerIndex': 0,
    },
    {
      'question': 'Qui a peint la Mona Lisa ?',
      'options': [
        'Leonardo da Vinci',
        'Vincent van Gogh',
        'Pablo Picasso',
        'Claude Monet'
      ],
      'correctAnswerIndex': 0,
    },
    // Ajouter plus de questions d'histoire ici...
  ];

  List<Map<String, dynamic>> get currentQuestionSet =>
      _selectedQuizType == 'Football' ? _footballQuestions : _histoireQuestions;

  void _startQuiz(String quizType) {
    setState(() {
      _selectedQuizType = quizType;
      _score = 0;
      _currentQuestionIndex = 0;
    });
  }

  void _checkAnswer(int? selectedAnswerIndex) {
    final currentQuestion = currentQuestionSet[_currentQuestionIndex];
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'];

    if (selectedAnswerIndex == correctAnswerIndex) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      _currentQuestionIndex++;
    });

    if (_currentQuestionIndex == currentQuestionSet.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz terminé'),
            content: Text('Score: $_score / ${currentQuestionSet.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choisissez un type de quiz',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _startQuiz('Football'),
                child: Text('Football'),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () => _startQuiz('Histoire'),
                child: Text('Histoire'),
              ),
              SizedBox(height: 20.0),
              _currentQuestionIndex < currentQuestionSet.length
                  ? Column(
                      children: [
                        Text(
                          currentQuestionSet[_currentQuestionIndex]['question'],
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        Column(
                          children: List<Widget>.generate(
                            currentQuestionSet[_currentQuestionIndex]['options']
                                .length,
                            (index) {
                              final option =
                                  currentQuestionSet[_currentQuestionIndex]
                                      ['options'][index];
                              return RadioListTile<int>(
                                title: Text(option),
                                value: index,
                                groupValue: null,
                                onChanged: _checkAnswer,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
