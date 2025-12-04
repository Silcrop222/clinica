import 'package:flutter/material.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../../data/repositories/report_repository_impl.dart';

class ReportProvider extends ChangeNotifier {
  final ReportRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ReportProvider({ReportRepository? repository})
      : _repository = repository ?? ReportRepositoryImpl();

  Future<void> addReport(Report report) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.addReport(report);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Report> _recentReports = [];
  List<Report> get recentReports => _recentReports;

  Future<void> fetchRecentReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recentReports = await _repository.getRecentReports();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Report> _searchResults = [];
  List<Report> get searchResults => _searchResults;

  Future<void> search(String query, {int? minAge, int? maxAge, String? city}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _repository.searchReports(query, minAge: minAge, maxAge: maxAge, city: city);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
