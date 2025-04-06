import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:clinica/models/appointment_model.dart';
import 'package:clinica/models/app_color.dart';
import '../../../viewmodels/appointment_viewmodel.dart';
import '../../../services/sms_service.dart'; // Importa el servicio de SMS

class ClientAppointmentFormScreen extends StatefulWidget {
  final String nombreCita;
  final String tipoCita;

  const ClientAppointmentFormScreen({
    Key? key,
    required this.nombreCita,
    required this.tipoCita,
  }) : super(key: key);

  @override
  _ClientAppointmentFormScreenState createState() =>
      _ClientAppointmentFormScreenState();
}

class _ClientAppointmentFormScreenState
    extends State<ClientAppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _clientNameController;
  late TextEditingController _dniController;
  late TextEditingController _telefonoController;
  late DateTime _appointmentDate;

  String _estadoPago = 'Pendiente';
  String _status = 'Confirmada';

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _dniController = TextEditingController();
    _telefonoController = TextEditingController();
    _appointmentDate = DateTime.now();
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final appointment = Appointment(
        id: DateTime.now().toString(),
        clientName: _clientNameController.text,
        appointmentDate: _appointmentDate.toIso8601String(),
        dniCliente: _dniController.text,
        estadoPago: _estadoPago,
        status: _status,
        telefono: _telefonoController.text,
        tipoCita: widget.tipoCita,
        nombreCita: widget.nombreCita,
      );

      // Registrar la cita en Firebase
      await Provider.of<AppointmentViewModel>(context, listen: false)
          .createAppointment(appointment);

      // Enviar mensaje de texto al cliente
      final smsService = SmsService();
      await smsService.sendSms(
        _telefonoController.text,
        'Hola ${_clientNameController.text}, tu cita para ${widget.nombreCita} ha sido registrada exitosamente para el ${_appointmentDate.toLocal().toString().split(' ')[0]}. ¡Gracias!',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita registrada y SMS enviado')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Consulta'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                'Nombre del Cliente',
                _clientNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre del cliente es requerido';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'DNI del Cliente',
                _dniController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El DNI es requerido';
                  } else if (value.length != 8) {
                    return 'El DNI debe tener exactamente 8 dígitos';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Teléfono',
                _telefonoController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El teléfono es requerido';
                  } else if (value.length != 9) {
                    return 'El teléfono debe tener exactamente 9 dígitos';
                  }
                  return null;
                },
              ),
              _buildCalendar(),
              _buildReadOnlyField('Nombre de la Cita', widget.nombreCita),
              _buildReadOnlyField('Tipo de Cita', widget.tipoCita),
              _buildReadOnlyField('Estado de Pago', _estadoPago),
              _buildReadOnlyField('Estado de la Cita', _status),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleSubmit(context),
                child: Text('Registrar Cita'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        List<TextInputFormatter>? inputFormatters,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        readOnly: true,
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        color: AppColors.inputBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TableCalendar(
            focusedDay: _appointmentDate,
            firstDay: DateTime.utc(2000),
            lastDay: DateTime.utc(2100),
            selectedDayPredicate: (day) => isSameDay(day, _appointmentDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _appointmentDate = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
