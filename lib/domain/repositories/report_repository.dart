import '../entities/report.dart';

abstract class ReportRepository {
  Future<void> addReport(Report report);
  Future<List<Report>> getRecentReports({int limit = 50});
  Future<List<Report>> searchReports(String query, {int? minAge, int? maxAge, String? city});
  Future<Report?> getReportById(String id);
  Future<void> voteReport(String reportId, bool isReal);
}
