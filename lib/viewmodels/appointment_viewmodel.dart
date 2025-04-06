import 'package:flutter/material.dart';
import 'package:clinica/models/appointment_model.dart';
import 'package:clinica/services/appointment_service.dart';

class AppointmentViewModel extends ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();

  List<Appointment> _appointments = [];
  List<Appointment> get appointments => _appointments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Método para cargar todas las citas
  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _appointments = await _appointmentService.listAppointments();
    } catch (e) {
      print("Error al cargar las citas: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para buscar cita por DNI
  Future<void> searchAppointmentsByDni(String dni) async {
    _isLoading = true;
    notifyListeners();

    try {
      _appointments = await _appointmentService.searchAppointmentByDni(dni);
    } catch (e) {
      print("Error al buscar citas por DNI: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para buscar citas por rango de fechas
  Future<void> searchAppointmentsByDateRange(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      _appointments = await _appointmentService.searchAppointmentsByDateRange(startDate, endDate);
    } catch (e) {
      print("Error al buscar citas por rango de fechas: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para marcar cita como pagada
  Future<void> markAppointmentAsPaid(String id) async {
    try {
      await _appointmentService.markAppointmentAsPaid(id);
      loadAppointments(); // Recargar las citas luego de la actualización
    } catch (e) {
      print("Error al marcar la cita como pagada: $e");
    }
  }

  // Método para crear una nueva cita
  Future<void> createAppointment(Appointment appointment) async {
    try {
      await _appointmentService.createAppointment(appointment);
      loadAppointments();
    } catch (e) {
      print("Error al crear la cita: $e");
    }
  }

  // Método para actualizar una cita
  Future<void> updateAppointment(String id, Appointment updatedAppointment) async {
    try {
      await _appointmentService.updateAppointment(id, updatedAppointment);
      loadAppointments();
    } catch (e) {
      print("Error al actualizar la cita: $e");
    }
  }

  // Método para eliminar una cita
  Future<void> deleteAppointment(String id) async {
    try {
      await _appointmentService.deleteAppointment(id);
      loadAppointments();
    } catch (e) {
      print("Error al eliminar la cita: $e");
    }
  }
}
