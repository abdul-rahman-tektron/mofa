import 'package:flutter/material.dart';
import 'package:mofa/model/appointment_model.dart';

class AppointmentTable extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentTable({Key? key, required this.appointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text("Ref. No")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Company Name")),
          DataColumn(label: Text("Email")),
          DataColumn(label: Text("Visit Start Date")),
          DataColumn(label: Text("Visit End Date")),
          DataColumn(label: Text("Mobile Number")),
          DataColumn(label: Text("Host Name")),
          DataColumn(label: Text("Location")),
          DataColumn(label: Text("Print Status")),
          DataColumn(label: Text("Action")),
        ],
        rows: appointments.map((appointment) {
          return DataRow(cells: [
            DataCell(Text(appointment.refNo)),
            DataCell(Text(appointment.name)),
            DataCell(Text(appointment.companyName)),
            DataCell(Text(appointment.email)),
            DataCell(Text(appointment.startDate)),
            DataCell(Text(appointment.endDate)),
            DataCell(Text(appointment.mobile)),
            DataCell(Text(appointment.host)),
            DataCell(Text(appointment.location)),
            DataCell(Text(appointment.printStatus)),
            DataCell(ElevatedButton(
              onPressed: () {
                // TODO: Handle Action
              },
              child: Text("View"),
            )),
          ]);
        }).toList(),
      ),
    );
  }
}
