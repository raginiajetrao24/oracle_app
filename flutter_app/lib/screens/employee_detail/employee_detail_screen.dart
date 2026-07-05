import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Map<String, String> employee;
  const EmployeeDetailScreen({super.key, required this.employee});

  static const _blue = Color(0xFF1F4E8C);

  @override
  Widget build(BuildContext context) {
    final initials = (employee['name'] ?? 'WS')
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0].toUpperCase())
        .take(2)
        .join();

    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const AppHeaderWidget(title: 'Employment Details', showBack: true),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // ── Employee Header ─────────────────────────────────────────
                  _Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: _blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee['name'] ?? 'Will Smith',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              if (employee['contextTitle'] != null &&
                                  employee['contextTitle']!.isNotEmpty) ...[
                                Text(
                                  employee['contextTitle']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                'Person Number: ${employee['personNumber'] ?? '-'}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Work Relationship ───────────────────────────────────────
                  _ExpandableCard(
                    title: 'Work Relationship',
                    titleSuffix: const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'Legal Employer',
                          'value':
                              employee['legalEmployer'] ?? 'USI Legal Entity',
                        },
                        {
                          'label': 'Country',
                          'value': employee['country'] ?? 'United States',
                        },
                        {
                          'label': 'Worker Type',
                          'value': employee['personType'] ?? 'Nonworker',
                        },
                        {
                          'label': 'Hire Date',
                          'value': employee['hireDate'] ?? '1/1/22',
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Assignment Card ─────────────────────────────────────────
                  _Card(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Assignment header
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Assignment: ${employee['assignment'] ?? 'Human Resources Business Partner'}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Action: ${employee['action'] ?? 'Add nonworker'}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        Text(
                                          'Action Reason: ${employee['actionReason'] ?? 'Creation of Non-Worker'}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: _blue,
                                          size: 20,
                                        ),
                                        tooltip: 'Edit Assignment',
                                        onSelected: (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Selected option: $value',
                                              ),
                                            ),
                                          );
                                        },
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                            value: 'Update',
                                            child: Text('Update'),
                                          ),
                                          PopupMenuItem(
                                            value: 'Correct',
                                            child: Text('Correct'),
                                          ),
                                          PopupMenuItem(
                                            value: 'Delete Record',
                                            child: Text('Delete Record'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 2),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: _blue),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            'View History',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: _blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const _IconBtn(
                                        icon: Icons.access_time_outlined,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Effective Start Date: ${employee['effectiveStartDate'] ?? '1/1/22 (1 of 1)'}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE5E7EB)),

                        // Tab
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: _blue, width: 3),
                                  ),
                                ),
                                child: const Text(
                                  'Assignment Details',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Assignment fields
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TwoCol(
                                items: [
                                  {
                                    'label': 'Assignment Number',
                                    'value':
                                        employee['assignmentNumber'] ?? 'N1748',
                                  },
                                  {
                                    'label': 'Business Unit',
                                    'value':
                                        employee['businessUnit'] ??
                                        'US1 Business Unit',
                                  },
                                  {
                                    'label': 'Person Type',
                                    'value':
                                        employee['personType'] ?? 'Nonworker',
                                  },
                                  {
                                    'label': 'Position',
                                    'value':
                                        employee['position'] ??
                                        'Human Resources Business Partner',
                                  },
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(
                                  height: 1,
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                              _Field(
                                label: 'Job',
                                value:
                                    employee['job'] ??
                                    'Human Resources Business Partner',
                              ),
                              const SizedBox(height: 10),
                              _Field(
                                label: 'Assignment Name',
                                value:
                                    employee['assignmentName'] ??
                                    'Human Resources Business Partner',
                              ),
                              const SizedBox(height: 12),
                              _TwoCol(
                                items: [
                                  {
                                    'label': 'Grade Ladder',
                                    'value': employee['gradeLadder'] ?? '-',
                                  },
                                  {
                                    'label': 'Grade',
                                    'value': employee['grade'] ?? '-',
                                  },
                                  {
                                    'label': 'Department',
                                    'value': employee['department'] ?? '-',
                                  },
                                  {
                                    'label': 'Location',
                                    'value':
                                        employee['location'] ??
                                        'Redwood City, US',
                                  },
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    employee['includeInProgression'] == 'Yes'
                                        ? Icons.check_box_outlined
                                        : Icons
                                              .check_box_outline_blank_outlined,
                                    size: 18,
                                    color: _blue,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Include in Grade Step Progression',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _TwoCol(
                                items: [
                                  {
                                    'label': 'Working at Home',
                                    'value': employee['workingAtHome'] ?? 'No',
                                  },
                                  {
                                    'label': 'Worker Category',
                                    'value': employee['workerCategory'] ?? '-',
                                  },
                                  {
                                    'label': 'Assignment Category',
                                    'value':
                                        employee['assignmentCategory'] ?? '-',
                                  },
                                  {
                                    'label': 'Regular or Temporary',
                                    'value':
                                        employee['regularOrTemporary'] ?? '-',
                                  },
                                  {
                                    'label': 'Full Time or Part Time',
                                    'value':
                                        employee['fullTimeOrPartTime'] ?? '-',
                                  },
                                  {
                                    'label': 'Working as a Manager',
                                    'value':
                                        employee['workingAsManager'] ?? 'No',
                                  },
                                  {
                                    'label': 'Hourly Paid or Salaried',
                                    'value':
                                        employee['hourlyPaidOrSalaried'] ?? '-',
                                  },
                                  {
                                    'label': 'Workcare Category',
                                    'value':
                                        employee['workcareCategory'] ?? '-',
                                  },
                                  {
                                    'label': 'Context Value',
                                    'value': employee['contextValue'] ?? '-',
                                  },
                                ],
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {},
                                child: const Row(
                                  children: [
                                    Text(
                                      'Work Measure Details',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _blue,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 16,
                                      color: _blue,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Working Hours / Frequency',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${employee['workingHours'] ?? '40'} @ ${employee['frequency'] ?? 'Weekly'}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _TwoCol(
                                items: [
                                  {
                                    'label': 'Derived Standard Working Hours',
                                    'value':
                                        employee['derivedHours'] ?? '40 Weekly',
                                  },
                                  {
                                    'label': 'FTE',
                                    'value': employee['fte'] ?? '1',
                                  },
                                  {
                                    'label': 'Headcount',
                                    'value': employee['headcount'] ?? '1',
                                  },
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(
                                  height: 1,
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                              const Text(
                                'Assignment Status',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  employee['assignmentStatus'] ??
                                      'Active - Payroll Eligible',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Start Time / End Time on same row like desktop
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Start Time',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          employee['startTime'] ?? '08:30 AM',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'End Time',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          employee['endTime'] ?? '04:30 PM',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _TwoCol(
                                items: [
                                  {
                                    'label': 'Basis for Seniority Calculation',
                                    'value':
                                        employee['seniorityBasis'] ?? 'Days',
                                  },
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Job Details ───────────────────────────────────────────
                  _ExpandableCard(
                    title: 'Job Details',
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'Effective Date',
                          'value': employee['effectiveStartDate'] ?? '-',
                        },
                        {
                          'label': 'Action',
                          'value': employee['action'] ?? 'Manager Change',
                        },
                        {
                          'label': 'Action Reason',
                          'value': employee['actionReason'] ?? '-',
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Manager Details ───────────────────────────────────────
                  _ExpandableCard(
                    title:
                        'Manager (${employee['managerName'] != null ? '1' : '0'})',
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Field(
                          label: 'Name',
                          value: employee['managerName'] ?? 'Jane Smith',
                        ),
                        const SizedBox(height: 8),
                        _Field(
                          label: 'Type',
                          value: employee['managerType'] ?? 'Line Manager',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Manage Assignments ────────────────────────────────────
                  _ExpandableCard(
                    title: 'Manage Assignments',
                    bodyPadding: EdgeInsets.zero,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            bottom: 14,
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: _Field(label: 'Reassign To', value: ''),
                              ),
                            ],
                          ),
                        ),
                        // Action bar (View, Format, Detach, Wrap)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFE5E7EB)),
                              bottom: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _SmallActionChip(
                                  label: 'View',
                                  icon: Icons.visibility_outlined,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: 'Format',
                                  icon: Icons.format_list_bulleted,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: '',
                                  icon: Icons.close,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: '',
                                  icon: Icons.check,
                                  isActive: true,
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Freeze',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.ac_unit,
                                  size: 14,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Detach',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Wrap',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Direct Report table header
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Table(
                                border: const TableBorder(
                                  bottom: BorderSide(color: Color(0xFFE5E7EB)),
                                  horizontalInside: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 0.5,
                                  ),
                                ),
                                children: const [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFE5E7EB),
                                        ),
                                      ),
                                    ),
                                    children: [
                                      _TH('Select'),
                                      _TH('Name'),
                                      _TH('Direct Report'),
                                      _TH('Proposed Manager'),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      _TD('All'),
                                      _TD('Add Subordinate'),
                                      _TD(''),
                                      _TD(''),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'No data to display',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Direct Reports ────────────────────────────────────────
                  _ExpandableCard(
                    title: 'Direct Reports',
                    bodyPadding: EdgeInsets.zero,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (employee['directReportName'] != null) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Direct Reports Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _TwoCol(
                                  items: [
                                    {
                                      'label': 'Effective Date',
                                      'value':
                                          employee['directReportEffectiveDate'] ??
                                          '7/2/26',
                                    },
                                    {
                                      'label': 'Action',
                                      'value':
                                          employee['directReportAction'] ??
                                          'Manager Change',
                                    },
                                    {
                                      'label': 'Action Reason',
                                      'value':
                                          employee['directReportActionReason'] ??
                                          '-',
                                    },
                                    {
                                      'label': 'Reassign To',
                                      'value':
                                          employee['directReportReassignTo'] ??
                                          '-',
                                    },
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Table(
                              border: const TableBorder(
                                bottom: BorderSide(color: Color(0xFFE5E7EB)),
                                horizontalInside: BorderSide(
                                  color: Color(0xFFE5E7EB),
                                  width: 0.5,
                                ),
                              ),
                              children: [
                                const TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                  ),
                                  children: [
                                    _TH('Select'),
                                    _TH('Direct Report'),
                                    _TH('Proposed Manager'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.check_box_outlined,
                                          size: 18,
                                          color: _blue,
                                        ),
                                      ),
                                    ),
                                    _TD(employee['directReportName']!),
                                    _TD(employee['proposedManager'] ?? '-'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          const Padding(
                            padding: EdgeInsets.all(14),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'No data to display',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Employment IT Information ─────────────────────────────
                  _ExpandableCard(
                    title: 'Employment IT Information',
                    body: const Text(
                      'IT Assignment Extra Information',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Australian Workplace ────────────────────────────────────
                  _ExpandableCard(
                    title: 'Australian Workplace Gender Equality Information',
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'Manager Category',
                          'value': employee['managerCategory'] ?? '-',
                        },
                        {
                          'label': 'Occupational Category',
                          'value': employee['occupationalCategory'] ?? '-',
                        },
                        {
                          'label': 'Employment Status',
                          'value': employee['employmentStatus'] ?? '-',
                        },
                        {
                          'label': 'Industry',
                          'value': employee['industry'] ?? '-',
                        },
                        {
                          'label': 'Graduate or Apprentice',
                          'value': employee['graduateOrApprentice'] ?? '-',
                        },
                        {
                          'label': 'Industry Classification',
                          'value': employee['industryClassification'] ?? '-',
                        },
                        {
                          'label': 'Reporting Level',
                          'value': employee['reportingLevel'] ?? '-',
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── UK HESA ─────────────────────────────────────────────────
                  _ExpandableCard(
                    title: 'UK HESA Information',
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'acempplan',
                          'value': employee['acempplan'] ?? '-',
                        },
                        {
                          'label': 'clinical',
                          'value': employee['clinical'] ?? '-',
                        },
                        {'label': 'campid', 'value': employee['campid'] ?? '-'},
                        {'label': 'recon', 'value': employee['recon'] ?? '-'},
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── PAR Remarks ─────────────────────────────────────────────
                  _ExpandableCard(
                    title: 'PAR Remarks',
                    bodyPadding: EdgeInsets.zero,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Action bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFE5E7EB)),
                              bottom: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _SmallActionChip(
                                  label: 'View',
                                  icon: Icons.visibility_outlined,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: 'Format',
                                  icon: Icons.format_list_bulleted,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: '',
                                  icon: Icons.close,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: '',
                                  icon: Icons.check,
                                  isActive: true,
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Freeze',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Detach',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Wrap',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // PAR table
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Table(
                                border: const TableBorder(
                                  bottom: BorderSide(color: Color(0xFFE5E7EB)),
                                  horizontalInside: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 0.5,
                                  ),
                                ),
                                children: const [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFE5E7EB),
                                        ),
                                      ),
                                    ),
                                    children: [
                                      _TH('PAR Remark Code'),
                                      _TH('PAR Command'),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'No data to display',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Related Grade ───────────────────────────────────────────
                  _ExpandableCard(
                    title: 'Related Grade',
                    bodyPadding: EdgeInsets.zero,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Action bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFE5E7EB)),
                              bottom: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _SmallActionChip(
                                  label: 'View',
                                  icon: Icons.visibility_outlined,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: 'Format',
                                  icon: Icons.format_list_bulleted,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: '',
                                  icon: Icons.close,
                                  isActive: false,
                                ),
                                const SizedBox(width: 4),
                                _SmallActionChip(
                                  label: '',
                                  icon: Icons.check,
                                  isActive: true,
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Detach',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Wrap',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Related Grade table
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  defaultColumnWidth:
                                      const IntrinsicColumnWidth(),
                                  border: const TableBorder(
                                    bottom: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                    horizontalInside: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 0.5,
                                    ),
                                  ),
                                  children: const [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xFFE5E7EB),
                                          ),
                                        ),
                                      ),
                                      children: [
                                        _TH('Start Date'),
                                        _TH('End Date'),
                                        _TH('Primary'),
                                        _TH('Pay Table'),
                                        _TH('Grade'),
                                        _TH('Step'),
                                        _TH('Pay Basis'),
                                        _TH('Pay Plan'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'No data to display',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Probation and Notice Periods ────────────────────────────
                  _ExpandableCard(
                    title: 'Probation and Notice Periods',
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'Probation Period',
                          'value': employee['probationPeriod'] ?? '-',
                        },
                        {
                          'label': 'Notice Period',
                          'value': employee['noticePeriod'] ?? '-',
                        },
                        {
                          'label': 'Probation End Date',
                          'value': employee['probationEndDate'] ?? '-',
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Work Tax Address ────────────────────────────────────────
                  _ExpandableCard(
                    title: 'Work Tax Address',
                    body: _Field(
                      label: 'Work Tax Address',
                      value: employee['workTaxAddress'] ?? '-',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Expenses Information ───────────────────────────────────
                  _ExpandableCard(
                    title: 'Expenses Information',
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'Default Expense Account',
                          'value': employee['defaultExpenseAccount'] ?? '-',
                        },
                        {
                          'label': 'Expense Check Send To Address',
                          'value': employee['expenseSendAddress'] ?? '-',
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Retirement ─────────────────────────────────────────────
                  _ExpandableCard(
                    title: 'Retirement',
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'Retirement Age',
                          'value': employee['retirementAge'] ?? '-',
                        },
                        {
                          'label': 'Retirement Date',
                          'value': employee['retirementDate'] ?? '-',
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Collective Agreement ───────────────────────────────────
                  _ExpandableCard(
                    title: 'Collective Agreement',
                    body: _TwoCol(
                      items: [
                        {
                          'label': 'Union Member',
                          'value': employee['unionMember'] ?? '-',
                        },
                        {
                          'label': 'Bargaining Unit',
                          'value': employee['bargainingUnit'] ?? '-',
                        },
                        {'label': 'Union', 'value': employee['union'] ?? '-'},
                        {
                          'label': 'Collective Agreement',
                          'value': employee['collectiveAgreement'] ?? '-',
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable widgets ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding ?? const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

class _RowHeader extends StatelessWidget {
  final String title;
  final Widget? titleSuffix;
  final bool isExpanded;
  final VoidCallback? onTap;
  const _RowHeader({
    required this.title,
    this.titleSuffix,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (titleSuffix != null) ...[
                const SizedBox(width: 6),
                titleSuffix!,
              ],
            ],
          ),
        ),
        AnimatedRotation(
          turns: isExpanded ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
        ),
      ],
    ),
  );
}

/// A card that can expand/collapse its [body] when the header is tapped.
class _ExpandableCard extends StatefulWidget {
  final String title;
  final Widget? titleSuffix;
  final Widget body;
  final EdgeInsets? bodyPadding;
  const _ExpandableCard({
    required this.title,
    this.titleSuffix,
    required this.body,
    this.bodyPadding,
  });

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = true;
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: _RowHeader(
              title: widget.title,
              titleSuffix: widget.titleSuffix,
              isExpanded: _expanded,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding:
                  widget.bodyPadding ??
                  const EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: widget.body,
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label, value;
  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
      ),
      const SizedBox(height: 2),
      Text(
        value.isEmpty ? '-' : value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
    ],
  );
}

class _TwoCol extends StatelessWidget {
  final List<Map<String, String>> items;
  const _TwoCol({required this.items});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: _Field(
                label: items[i]['label']!,
                value: items[i]['value']!,
              ),
            ),
            const SizedBox(width: 12),
            i + 1 < items.length
                ? Expanded(
                    child: _Field(
                      label: items[i + 1]['label']!,
                      value: items[i + 1]['value']!,
                    ),
                  )
                : const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < items.length) rows.add(const SizedBox(height: 12));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  const _IconBtn({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: const Color(0xFFEEF5FC),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, color: const Color(0xFF1F4E8C), size: 18),
  );
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6B7280),
      ),
    ),
  );
}

class _TD extends StatelessWidget {
  final String text;
  const _TD(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, color: Color(0xFF1F2937)),
    ),
  );
}

class _SmallActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  const _SmallActionChip({
    required this.label,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1F4E8C) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.white : const Color(0xFF6B7280),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
