import 'package:flutter/material.dart';
import 'package:flutter_app/screens/my_team/document_records_screen.dart';

/// Document Records screen for the "Me" section.
/// Shows Curtis Feitty's own document records using the shared
/// [PersonDocumentRecordsScreen] from the My Team module.
class MeDocumentRecordsScreen extends StatelessWidget {
  const MeDocumentRecordsScreen({super.key});

  static const _curtisFeitty = DocumentPerson(
    'Curtis Feitty',
    'Human Resources Specialist',
    '1000001',
    'E1000001',
    'curtis.feitty_esll-dev2@oracledemos.com',
    assignmentStatus: 'Active - Payroll Eligible',
    workerType: 'Employee',
  );

  @override
  Widget build(BuildContext context) {
    return const PersonDocumentRecordsScreen(
      person: _curtisFeitty,
      isMeSection: true,
    );
  }
}
