import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/widgets.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  String? selectedCategory;
  String? selectedWallet;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.violet100,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.violet100,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "Income",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40), // Balance the back button
                      ],
                    ),
                  ),

                  // Flexible spacer
                  const Flexible(child: SizedBox(height: 40)),

                  // "How much?" and amount
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "How much?",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AmountInput(
                          controller: amountController,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // White container with form fields
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            
                            // Category Dropdown
                            CustomDropdown<String>(
                              labelText: "Category",
                              value: selectedCategory,
                              items: ['Salary', 'Freelance', 'Investment', 'Business']
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                            ),
                            
                            const SizedBox(height: 16),

                            // Description Field
                            CustomTextField(
                              labelText: "Description",
                              controller: descriptionController,
                            ),
                            
                            const SizedBox(height: 16),

                            // Wallet Dropdown
                            CustomDropdown<String>(
                              labelText: "Wallet",
                              value: selectedWallet,
                              items: ['Cash', 'Bank', 'Card']
                                  .map((wallet) => DropdownMenuItem(
                                        value: wallet,
                                        child: Text(wallet),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedWallet = value;
                                });
                              },
                            ),
                            
                            const Spacer(),

                            // Continue Button
                            CustomButton(
                              text: "Continue",
                              backgroundColor: AppColors.violet100,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
