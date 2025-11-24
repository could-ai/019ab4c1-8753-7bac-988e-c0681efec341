import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
        fontFamily: 'Roboto', // Defaulting to Roboto or system font
      ),
      // Explicitly defining routes for safety
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScaffold(),
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StatsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // The middle button (Add) is handled separately by the FAB
      return;
    }
    // Adjust index because the FAB is in the middle visually but not in the list
    // 0 -> Home
    // 1 -> Add (FAB)
    // 2 -> Stats
    
    setState(() {
      _selectedIndex = index > 1 ? index - 1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.blue[800] : Colors.grey,
                  size: 30,
                ),
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
              const SizedBox(width: 40), // Space for FAB
              IconButton(
                icon: Icon(
                  Icons.pie_chart,
                  color: _selectedIndex == 1 ? Colors.blue[800] : Colors.grey,
                  size: 30,
                ),
                onPressed: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
