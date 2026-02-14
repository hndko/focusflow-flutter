import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GamificationService extends ChangeNotifier {
  int _xp = 0;
  int _level = 1;
  int _streak = 0;
  DateTime? _lastTaskDate;

  int get xp => _xp;
  int get level => _level;
  int get streak => _streak;

  GamificationService() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _xp = prefs.getInt('xp') ?? 0;
    _level = prefs.getInt('level') ?? 1;
    _streak = prefs.getInt('streak') ?? 0;
    final lastTaskString = prefs.getString('lastTaskDate');
    if (lastTaskString != null) {
      _lastTaskDate = DateTime.parse(lastTaskString);
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
    await prefs.setInt('level', _level);
    await prefs.setInt('streak', _streak);
    if (_lastTaskDate != null) {
      await prefs.setString('lastTaskDate', _lastTaskDate!.toIso8601String());
    }
  }

  void completeTask() {
    // XP Calculation
    const int taskXp = 10;
    _xp += taskXp;

    // Level Up Logic (Simple: Level * 100 XP required)
    if (_xp >= _level * 100) {
      _level++;
      _xp = 0; // Or keep overflow? Let's reset for simplicity
    }

    // Streak Logic
    final now = DateTime.now();
    if (_lastTaskDate != null) {
      final difference = now.difference(_lastTaskDate!).inDays;
      if (difference == 1) {
        _streak++;
      } else if (difference > 1) {
        _streak = 1; // Reset streak if missed a day
      }
    } else {
      _streak = 1;
    }
    _lastTaskDate = now;

    _saveData();
    notifyListeners();
  }
}
