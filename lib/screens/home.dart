import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_models/budget_view_model.dart';
import '../services/theme_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> bottomNavItems = const [ // This is to define our BottomNavigationBarItems
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  List<Widget> pages = const [
    HomePage(), 
    ProfilePage(),
  ];

  int _currentPageIndex = 0; // Current page Index. We need to declare this so the index from onTap of the NavigationBottomBar shows what we should have in our page 

  @override
    Widget build(BuildContext context) {
      final themeService = Provider.of<ThemeService>(
        context, 
        listen: false
      );
      return Scaffold(
        appBar: AppBar(
          title: const Text("Budget Tracker"),
          leading: IconButton(
            onPressed: () {
              themeService.darkTheme = !themeService.darkTheme;
            },
            icon: Icon(themeService.darkTheme ? Icons.sunny : Icons.dark_mode),
          ),
        actions: [
          IconButton(onPressed: () {
            showDialog(
              context: context, 
              builder: (context) {  
                return AddBudgetDialog(
                  budgetToAdd: (budget) {
                    final budgetService = Provider.of<BudgetViewModel>(
                      context,
                      listen: false
                    );
                    budgetService.budget = budget;
                  },
                );
              }
            );
          },
          icon: const Icon(Icons.attach_money)),
        ],
      ),
      body: pages[_currentPageIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        items: bottomNavItems,
        onTap: (index) {
          setState( () { 
          _currentPageIndex = index; 
          });
        },// 0 if click on Home, 1 in Profile
      ),
    );
  }
}


class AddBudgetDialog extends StatefulWidget {
  final Function(double) budgetToAdd;
  const AddBudgetDialog({ required this.budgetToAdd, super.key});

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final TextEditingController amountBudget = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Dialog(
      child: SizedBox(
        width: screenSize.width / 1.3,
        height: 185,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text( 
                "Set up a Budget",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ), 
              const SizedBox(height: 10.0),
              TextField(
                controller: amountBudget,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: "Amount in \$", ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (amountBudget.text.isNotEmpty) {
                      widget.budgetToAdd(
                        double.parse(amountBudget.text), 
                      );
                      Navigator.pop(context);
                    }
                  }
                  , child: const Text("Add"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
} 