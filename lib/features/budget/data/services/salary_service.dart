import 'package:shared_preferences/shared_preferences.dart';

class SalaryService {
  static const String _salaryKey = 'monthly_salary';

  /// Save monthly salary to local storage
  static Future<bool> saveMonthlySalary(double salary) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setDouble(_salaryKey, salary);
    } catch (e) {
      return false;
    }
  }

  /// Get monthly salary from local storage
  static Future<double> getMonthlySalary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_salaryKey) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Clear saved salary data
  static Future<bool> clearSalary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_salaryKey);
    } catch (e) {
      return false;
    }
  }

  /// Check if salary data exists
  static Future<bool> hasSalaryData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_salaryKey);
    } catch (e) {
      return false;
    }
  }
}