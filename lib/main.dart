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
  Map<String, int> _moodCounts = {
    'happy': 1, // Start with 1 since happy is the default
    'sad': 0,
    'excited': 0,
  };

  String get currentMood => _currentMood; 
  Map<String, int> get moodCounts => _moodCounts;

  void setHappy() { 
    _currentMood = 'happy'; 
    _moodCounts['happy'] = _moodCounts['happy']! + 1;
    notifyListeners(); 
  } 

  void setSad() { 
    _currentMood = 'sad'; 
    _moodCounts['sad'] = _moodCounts['sad']! + 1;
    notifyListeners(); 
  } 

  void setExcited() { 
    _currentMood = 'excited'; 
    _moodCounts['excited'] = _moodCounts['excited']! + 1;
    notifyListeners(); 
  } 
} 

// Theme Model - Manages app themes
class ThemeModel with ChangeNotifier {
  String _currentTheme = 'default';
  
  String get currentTheme => _currentTheme;
  
  // Theme definitions
  Map<String, ThemePack> get themes => {
    'default': ThemePack(
      name: 'Default',
      happyColor: Colors.yellow,
      sadColor: Colors.blue,
      excitedColor: Colors.orange,
      textColor: Colors.black87,
      cardColor: Colors.white.withOpacity(0.8),
    ),
    'dark': ThemePack(
      name: 'Dark',
      happyColor: Colors.amber[800]!,
      sadColor: Colors.indigo[900]!,
      excitedColor: Colors.deepOrange[800]!,
      textColor: Colors.white,
      cardColor: Colors.grey[800]!.withOpacity(0.9),
    ),
    'pastel': ThemePack(
      name: 'Pastel',
      happyColor: Colors.yellow[100]!,
      sadColor: Colors.blue[100]!,
      excitedColor: Colors.orange[100]!,
      textColor: Colors.black54,
      cardColor: Colors.white.withOpacity(0.9),
    ),
  };
  
  ThemePack get currentThemePack => themes[_currentTheme]!;
  
  Color getBackgroundColor(String mood) {
    switch (mood) {
      case 'happy':
        return currentThemePack.happyColor;
      case 'sad':
        return currentThemePack.sadColor;
      case 'excited':
        return currentThemePack.excitedColor;
      default:
        return currentThemePack.happyColor;
    }
  }
  
  void setTheme(String theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}

// Theme Pack class to hold theme colors
class ThemePack {
  final String name;
  final Color happyColor;
  final Color sadColor;
  final Color excitedColor;
  final Color textColor;
  final Color cardColor;
  
  ThemePack({
    required this.name,
    required this.happyColor,
    required this.sadColor,
    required this.excitedColor,
    required this.textColor,
    required this.cardColor,
  });
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
    return Consumer2<MoodModel, ThemeModel>(
      builder: (context, moodModel, themeModel, child) {
        return Scaffold( 
          backgroundColor: themeModel.getBackgroundColor(moodModel.currentMood),
          appBar: AppBar(
            title: Text('Mood Toggle Challenge'),
            backgroundColor: Colors.white.withOpacity(0.9),
            elevation: 4,
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  onSelected: (String theme) {
                    themeModel.setTheme(theme);
                  },
                  itemBuilder: (BuildContext context) {
                    return themeModel.themes.keys.map((String theme) {
                      return PopupMenuItem<String>(
                        value: theme,
                        child: Row(
                          children: [
                            Icon(
                              theme == themeModel.currentTheme 
                                  ? Icons.check_circle 
                                  : Icons.circle_outlined,
                              size: 18,
                              color: theme == themeModel.currentTheme 
                                  ? Colors.deepPurple 
                                  : Colors.grey,
                            ),
                            SizedBox(width: 12),
                            Text(
                              themeModel.themes[theme]!.name,
                              style: TextStyle(
                                fontWeight: theme == themeModel.currentTheme 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.palette,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Themes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  tooltip: 'Select Theme',
                ),
              ),
            ],
          ), 
          body: Center( 
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [ 
                Text(
                  'How are you feeling?', 
                  style: TextStyle(
                    fontSize: 24,
                    color: themeModel.currentThemePack.textColor,
                  ),
                ), 
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
    return Consumer2<MoodModel, ThemeModel>(
      builder: (context, moodModel, themeModel, child) {
        return Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: themeModel.currentThemePack.cardColor,
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
                  color: themeModel.currentThemePack.textColor,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCounterItem('Happy', moodModel.moodCounts['happy']!, 
                      themeModel.currentThemePack.happyColor, themeModel.currentThemePack.textColor),
                  _buildCounterItem('Sad', moodModel.moodCounts['sad']!, 
                      themeModel.currentThemePack.sadColor, themeModel.currentThemePack.textColor),
                  _buildCounterItem('Excited', moodModel.moodCounts['excited']!, 
                      themeModel.currentThemePack.excitedColor, themeModel.currentThemePack.textColor),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCounterItem(String mood, int count, Color color, Color textColor) {
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
                color: textColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          mood,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
      ],
    );
  }
} 