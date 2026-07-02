enum HelpDeskSeverity { low, medium, high, critical }

enum HelpDeskStatus { newRequest, inProgress, waiting, closed, resolved }

class HelpDeskRequest {
  final String requestNumber;
  final String subject;
  final HelpDeskSeverity severity;
  final HelpDeskStatus status;
  final DateTime lastUpdated;
  final String assignedTo;
  final String categoryName;
  final String createdBy;
  final String queue;
  final String primaryPointOfContact;

  const HelpDeskRequest({
    required this.requestNumber,
    required this.subject,
    required this.severity,
    required this.status,
    required this.lastUpdated,
    required this.assignedTo,
    required this.categoryName,
    required this.createdBy,
    required this.queue,
    required this.primaryPointOfContact,
  });
}

extension HelpDeskSeverityLabel on HelpDeskSeverity {
  String get label {
    switch (this) {
      case HelpDeskSeverity.low:
        return 'Low';
      case HelpDeskSeverity.medium:
        return 'Medium';
      case HelpDeskSeverity.high:
        return 'High';
      case HelpDeskSeverity.critical:
        return 'Critical';
    }
  }
}

extension HelpDeskStatusLabel on HelpDeskStatus {
  String get label {
    switch (this) {
      case HelpDeskStatus.newRequest:
        return 'New';
      case HelpDeskStatus.inProgress:
        return 'In Progress';
      case HelpDeskStatus.waiting:
        return 'Waiting';
      case HelpDeskStatus.closed:
        return 'Closed';
      case HelpDeskStatus.resolved:
        return 'Resolved';
    }
  }
}
