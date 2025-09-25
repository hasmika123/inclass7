import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 

void main() { 
  runApp( 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoodModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: MyApp(),
    ), 
  ); 
} 

// Mood Model - The "Brain" of our app 
class MoodModel with ChangeNotifier { 
  String _currentMood = 'happy'; 
  Color _backgroundColor = Colors.yellow;
  Map<String, int> _moodCounts = {
    'happy': 1, // Start with 1 since happy is the default
    'sad': 0,
    'excited': 0,
  };

  String get currentMood => _currentMood; 
  Color get backgroundColor => _backgroundColor;
  Map<String, int> get moodCounts => _moodCounts;

  void setHappy() { 
    _currentMood = 'happy'; 
    _backgroundColor = Colors.yellow;
    _moodCounts['happy'] = _moodCounts['happy']! + 1;
    notifyListeners(); 
  } 

  void setSad() { 
    _currentMood = 'sad'; 
    _backgroundColor = Colors.blue;
    _moodCounts['sad'] = _moodCounts['sad']! + 1;
    notifyListeners(); 
  } 

  void setExcited() { 
    _currentMood = 'excited'; 
    _backgroundColor = Colors.orange;
    _moodCounts['excited'] = _moodCounts['excited']! + 1;
    notifyListeners(); 
  } 
}

// Theme Model - Manages different theme packs
class ThemeModel with ChangeNotifier {
  String _currentTheme = 'default';
  
  String get currentTheme => _currentTheme;
  
  // Theme pack definitions
  Map<String, Map<String, dynamic>> get themePacks => {
    'default': {
      'name': 'Default',
      'happy': Colors.yellow,
      'sad': Colors.blue,
      'excited': Colors.orange,
      'textColor': Colors.black,
      'cardColor': Colors.white.withOpacity(0.8),
    },
    'dark': {
      'name': 'Dark',
      'happy': Colors.amber.shade800,
      'sad': Colors.indigo.shade800,
      'excited': Colors.deepOrange.shade800,
      'textColor': Colors.white,
      'cardColor': Colors.grey.shade800.withOpacity(0.9),
    },
    'pastel': {
      'name': 'Pastel',
      'happy': Colors.yellow.shade200,
      'sad': Colors.blue.shade200,
      'excited': Colors.orange.shade200,
      'textColor': Colors.grey.shade700,
      'cardColor': Colors.white.withOpacity(0.9),
    },
  };
  
  // Get current theme colors
  Color getBackgroundColor(String mood) {
    return themePacks[_currentTheme]![mood] as Color;
  }
  
  Color get textColor => themePacks[_currentTheme]!['textColor'] as Color;
  Color get cardColor => themePacks[_currentTheme]!['cardColor'] as Color;
  
  // Change theme
  void setTheme(String theme) {
    _currentTheme = theme;
    notifyListeners();
  }
  
  // Get available themes
  List<String> get availableThemes => themePacks.keys.toList();
} 

// Main App Widget 
class MyApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Mood Toggle Challenge', 
      theme: ThemeData(primarySwatch: Colors.blue), 
      home: HomePage(), 
    ); 
  } 
} 

// Home Page 
class HomePage extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Scaffold( 
          backgroundColor: moodModel.backgroundColor,
          appBar: AppBar(title: Text('Mood Toggle Challenge')), 
          body: Center( 
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [ 
                Text('How are you feeling?', style: TextStyle(fontSize: 24)), 
                SizedBox(height: 30), 
                MoodDisplay(), 
                SizedBox(height: 50), 
                MoodButtons(), 
                SizedBox(height: 30),
                MoodCounter(),
              ], 
            ), 
          ), 
        );
      },
    ); 
  } 
} 

// Widget that displays the current mood 
class MoodDisplay extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return Consumer<MoodModel>( 
      builder: (context, moodModel, child) { 
        return ClipRRect(
          borderRadius: BorderRadius.circular(100), // Makes it circular
          child: Container(
            width: 200,
            height: 200,
            child: Image.asset(
              'assets/${moodModel.currentMood}.jpg',
              fit: BoxFit.cover,
            ),
          ),
        );
      }, 
    ); 
  } 
} 

// Widget with buttons to change the mood 
class MoodButtons extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return Row( 
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: [ 
        ElevatedButton( 
          onPressed: () { 
            Provider.of<MoodModel>(context, listen: false).setHappy(); 
          }, 
          child: Text('Happy'), 
        ), 
        ElevatedButton( 
          onPressed: () { 
            Provider.of<MoodModel>(context, listen: false).setSad(); 
          }, 
          child: Text('Sad'), 
        ), 
        ElevatedButton( 
          onPressed: () { 
            Provider.of<MoodModel>(context, listen: false).setExcited(); 
          }, 
          child: Text('Excited'), 
        ), 
      ], 
    ); 
  } 
} 

// Widget that displays mood selection counts
class MoodCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Mood Counter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCounterItem('Happy', moodModel.moodCounts['happy']!, Colors.yellow),
                  _buildCounterItem('Sad', moodModel.moodCounts['sad']!, Colors.blue),
                  _buildCounterItem('Excited', moodModel.moodCounts['excited']!, Colors.orange),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCounterItem(String mood, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          mood,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
} 