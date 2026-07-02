import '../models/help_desk_request_model.dart';

abstract class HelpDeskRequestsDataSource {
  Future<List<HelpDeskRequest>> fetchRequests();
}

class MockHelpDeskRequestsDataSource implements HelpDeskRequestsDataSource {
  const MockHelpDeskRequestsDataSource();

  @override
  Future<List<HelpDeskRequest>> fetchRequests() async {
    return _mockRequests;
  }
}

final List<HelpDeskRequest> _mockRequests = [
  HelpDeskRequest(
    requestNumber: 'HRHD075015',
    subject: 'Leave Issue',
    severity: HelpDeskSeverity.low,
    status: HelpDeskStatus.inProgress,
    lastUpdated: DateTime(2026, 4, 28, 9, 7),
    assignedTo: '',
    categoryName: 'Leave',
    createdBy: 'Curtis Feitty',
    queue: 'HR Help Desk',
    primaryPointOfContact: 'Curtis Feitty',
  ),
  HelpDeskRequest(
    requestNumber: 'HRHD075014',
    subject: 'Leave Issue',
    severity: HelpDeskSeverity.low,
    status: HelpDeskStatus.newRequest,
    lastUpdated: DateTime(2026, 4, 28, 8, 55),
    assignedTo: '',
    categoryName: 'Leave',
    createdBy: 'Curtis Feitty',
    queue: 'HR Help Desk',
    primaryPointOfContact: 'Curtis Feitty',
  ),
  HelpDeskRequest(
    requestNumber: 'HRHD073013',
    subject: 'Testing',
    severity: HelpDeskSeverity.medium,
    status: HelpDeskStatus.newRequest,
    lastUpdated: DateTime(2025, 10, 5, 4, 24),
    assignedTo: 'Curtis Feitty',
    categoryName: 'General HR',
    createdBy: 'Curtis Feitty',
    queue: 'HR Operations',
    primaryPointOfContact: 'Curtis Feitty',
  ),
  HelpDeskRequest(
    requestNumber: 'HRHD072018',
    subject: 'Workplace Harassment Inquiry',
    severity: HelpDeskSeverity.high,
    status: HelpDeskStatus.newRequest,
    lastUpdated: DateTime(2025, 8, 27, 15, 7),
    assignedTo: 'Janice AgentHRHD',
    categoryName: 'Workplace Relations',
    createdBy: 'Mary Stone',
    queue: 'Employee Relations',
    primaryPointOfContact: 'Janice AgentHRHD',
  ),
  HelpDeskRequest(
    requestNumber: 'HRHD072017',
    subject: 'Information on Remote Work',
    severity: HelpDeskSeverity.low,
    status: HelpDeskStatus.waiting,
    lastUpdated: DateTime(2025, 8, 27, 15, 6),
    assignedTo: 'Janice AgentHRHD',
    categoryName: 'Policy',
    createdBy: 'Ahmed Shahin',
    queue: 'HR Help Desk',
    primaryPointOfContact: 'Janice AgentHRHD',
  ),
  HelpDeskRequest(
    requestNumber: 'HRHD071016',
    subject: 'Bonus not reflecting',
    severity: HelpDeskSeverity.low,
    status: HelpDeskStatus.newRequest,
    lastUpdated: DateTime(2025, 8, 18, 8, 30),
    assignedTo: 'John Dunbar',
    categoryName: 'Payroll',
    createdBy: 'Hope Hightower',
    queue: 'Payroll Support',
    primaryPointOfContact: 'John Dunbar',
  ),
  HelpDeskRequest(
    requestNumber: 'HRHD070119',
    subject: 'Employment letter request',
    severity: HelpDeskSeverity.medium,
    status: HelpDeskStatus.resolved,
    lastUpdated: DateTime(2025, 7, 22, 11, 45),
    assignedTo: 'Curtis Feitty',
    categoryName: 'Documents',
    createdBy: 'Kazi Al Shehri',
    queue: 'HR Operations',
    primaryPointOfContact: 'Curtis Feitty',
  ),
  HelpDeskRequest(
    requestNumber: 'HRHD069088',
    subject: 'Account access update',
    severity: HelpDeskSeverity.critical,
    status: HelpDeskStatus.closed,
    lastUpdated: DateTime(2025, 7, 12, 14, 20),
    assignedTo: 'IT Service Desk',
    categoryName: 'Access',
    createdBy: 'Sue Eden',
    queue: 'HR Systems',
    primaryPointOfContact: 'IT Service Desk',
  ),
];
