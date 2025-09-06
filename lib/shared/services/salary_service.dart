import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user salary data
class SalaryService {
  static const String _salaryKey = 'monthly_salary';

  /// Saves the monthly salary to local storage
  static Future<void> saveMonthlySalary(double salary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_salaryKey, salary);
  }

  /// Retrieves the monthly salary from local storage
  static Future<double> getMonthlySalary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_salaryKey) ?? 0.0;
  }

  /// Checks if salary has been set
  static Future<bool> hasSalarySet() async {
    final salary = await getMonthlySalary();
    return salary > 0;
  }

  /// Clears the saved salary
  static Future<void> clearSalary() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_salaryKey);
  }
}