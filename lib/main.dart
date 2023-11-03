import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/source/color_schemes.g.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('mode');

  runApp(MyApp(box));
}

class MyApp extends StatefulWidget {
  final Box box;
  MyApp(this.box, {Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box _box;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _box = widget.box;
    isDarkMode = _box.get('isDarkMode') ?? false;
  }

  saveThemeMode(bool value) async {
    await _box.put('isDarkMode', value);
    bool? savedMode = _box.get('isDarkMode');
    print(savedMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Modes"),
        ),
        body: Center(
          child: IconButton(
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });

              saveThemeMode(isDarkMode);
            },
            icon: IconButton(
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
              icon: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: isDarkMode
                    ? const Icon(
                        Icons.brightness_2,
                        key: ValueKey('moon'),
                      )
                    : const Icon(
                        Icons.wb_sunny,
                        key: ValueKey('sun'),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
