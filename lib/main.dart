import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 

void main() { 
  runApp( 
    ChangeNotifierProvider( 
      create: (context) => MoodModel(), 
      child: MyApp(), 
    ), 
  ); 
} 

// Mood Model - The "Brain" of our app 
class MoodModel with ChangeNotifier { 
  String _currentMood = 'happy'; 

  String get currentMood => _currentMood; 

  void setHappy() { 
    _currentMood = 'happy'; 
    notifyListeners(); 
  } 

  void setSad() { 
    _currentMood = 'sad'; 
    notifyListeners(); 
  } 

  void setExcited() { 
    _currentMood = 'excited'; 
    notifyListeners(); 
  } 
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
    return Scaffold( 
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
          ], 
        ), 
      ), 
    ); 
  } 
} 

// Widget that displays the current mood 
class MoodDisplay extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return Consumer<MoodModel>( 
      builder: (context, moodModel, child) { 
        return Container(
          width: 200,
          height: 200,
          child: Image.asset(
            'assets/${moodModel.currentMood}.jpg',
            fit: BoxFit.cover,
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