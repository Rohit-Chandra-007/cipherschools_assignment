import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipherschools_assignment/features/home/models/home_summary.dart';
import 'package:cipherschools_assignment/features/home/models/home_repository.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';

/// State class for Home feature
class HomeState {
  final int bottomNavIndex;
  final String selectedMonth;
  final TimeFilter timeFilter;
  final List<Transaction> transactions;
  final HomeSummary? homeSummary;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.bottomNavIndex = 0,
    this.selectedMonth = 'October',
    this.timeFilter = TimeFilter.daily,
    this.transactions = const [],
    this.homeSummary,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    int? bottomNavIndex,
    String? selectedMonth,
    TimeFilter? timeFilter,
    List<Transaction>? transactions,
    HomeSummary? homeSummary,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      timeFilter: timeFilter ?? this.timeFilter,
      transactions: transactions ?? this.transactions,
      homeSummary: homeSummary ?? this.homeSummary,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// ViewModel for Home feature
class HomeViewModel extends Notifier<HomeState> {
  late final HomeRepository _repository;

  @override
  HomeState build() {
    _repository = HomeRepository();
    Future.microtask(() => initialize());
    return const HomeState();
  }

  void setBottomNavIndex(int index) {
    state = state.copyWith(bottomNavIndex: index);
  }

  void setSelectedMonth(String month) {
    state = state.copyWith(selectedMonth: month);
    loadHomeSummary();
  }

  void setTimeFilter(TimeFilter filter) {
    state = state.copyWith(timeFilter: filter);
  }

  Future<void> loadTransactions() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final transactions = await _repository.getTransactions();
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> loadHomeSummary() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final summary = await _repository.getHomeSummary(
        month: state.selectedMonth,
      );
      state = state.copyWith(homeSummary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> initialize() async {
    await Future.wait([loadTransactions(), loadHomeSummary()]);
  }
}

/// Provider for HomeViewModel
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});

/// Navigator keys for tab navigation
final tabNavigatorKeysProvider = Provider<List<GlobalKey<NavigatorState>>>((
  ref,
) {
  return List.generate(4, (_) => GlobalKey<NavigatorState>());
});
