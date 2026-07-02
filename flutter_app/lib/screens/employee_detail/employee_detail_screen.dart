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
                              const SizedBox(height: 4),
                              const Text(
                                'Person Management',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 2),
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
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Work Relationship',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF6B7280),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const _TwoCol(
                          items: [
                            {
                              'label': 'Legal Employer',
                              'value': 'USI Legal Entity',
                            },
                            {'label': 'Country', 'value': 'United States'},
                            {'label': 'Worker Type', 'value': 'Nonworker'},
                            {'label': 'Hire Date', 'value': '1/1/22'},
                          ],
                        ),
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
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Assignment: Human Resources Business Partner',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Action: Add nonworker',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        Text(
                                          'Action Reason: Creation of Non-Worker',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: const [
                                      _IconBtn(icon: Icons.edit_outlined),
                                      SizedBox(width: 6),
                                      _IconBtn(
                                        icon: Icons.access_time_outlined,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Effective Start Date: 1/1/22 (1 of 1)',
                                style: TextStyle(
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
                              const _TwoCol(
                                items: [
                                  {
                                    'label': 'Assignment Number',
                                    'value': 'N1748',
                                  },
                                  {
                                    'label': 'Business Unit',
                                    'value': 'US1 Business Unit',
                                  },
                                  {
                                    'label': 'Person Type',
                                    'value': 'Nonworker',
                                  },
                                  {
                                    'label': 'Position',
                                    'value': 'Human Resources Business Partner',
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
                              const _Field(
                                label: 'Job',
                                value: 'Human Resources Business Partner',
                              ),
                              const SizedBox(height: 10),
                              const _Field(
                                label: 'Assignment Name',
                                value: 'Human Resources Business Partner',
                              ),
                              const SizedBox(height: 12),
                              const _TwoCol(
                                items: [
                                  {'label': 'Grade Ladder', 'value': '-'},
                                  {'label': 'Grade', 'value': '-'},
                                  {'label': 'Department', 'value': '-'},
                                  {
                                    'label': 'Location',
                                    'value': 'Redwood City, US',
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
                              const _TwoCol(
                                items: [
                                  {'label': 'Working Hours', 'value': '40'},
                                  {
                                    'label': 'Derived Standard Working Hours',
                                    'value': '40',
                                  },
                                  {'label': 'FTE', 'value': '1'},
                                  {'label': 'Headcount', 'value': '1'},
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
                                child: const Text(
                                  'Active - Payroll Eligible',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const _TwoCol(
                                items: [
                                  {'label': 'Primary', 'value': 'Yes'},
                                  {'label': 'Projected End Date', 'value': '-'},
                                  {'label': 'Start Time', 'value': '08:30 AM'},
                                  {'label': 'End Time', 'value': '04:30 PM'},
                                  {
                                    'label': 'Basis for Seniority Calculation',
                                    'value': 'Days',
                                  },
                                  {'label': 'Frequency', 'value': 'Weekly'},
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
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Job Details'),
                        SizedBox(height: 12),
                        _TwoCol(
                          items: [
                            {'label': 'Effective Date', 'value': '-'},
                            {'label': 'Action', 'value': 'Manager Change'},
                            {'label': 'Action Reason', 'value': '-'},
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Manager Details ───────────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Manager Details'),
                        SizedBox(height: 12),
                        _Field(
                          label: 'Name',
                          value: 'Active - Payroll Eligible',
                        ),
                        SizedBox(height: 8),
                        _Field(
                          label: 'Type',
                          value: 'Line Manager',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Manage Assignments ────────────────────────────────────
                  _Card(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _RowHeader(title: 'Manage Assignments'),
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  Expanded(
                                    child: _Field(
                                      label: 'Reassign To',
                                      value: '',
                                    ),
                                  ),
                                ],
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
                              const Spacer(),
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
                  const _ExpandRow(title: 'Direct Reports'),
                  const SizedBox(height: 10),

                  // ── Employment IT Information ─────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(
                          title: 'Employment IT Information',
                        ),
                        SizedBox(height: 4),
                        Text(
                          'IT Assignment Extra Information',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Australian Workcare ─────────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(
                          title:
                              'Australian Workcare Gender Equality Information',
                        ),
                        SizedBox(height: 12),
                        _TwoCol(
                          items: [
                            {'label': 'Manager Category', 'value': '-'},
                            {'label': 'Occupational Category', 'value': '-'},
                            {'label': 'Employment Status', 'value': '-'},
                            {'label': 'Industry', 'value': '-'},
                            {'label': 'Graduate or Apprentice', 'value': '-'},
                            {'label': 'Industry Classification', 'value': '-'},
                            {'label': 'Reporting Level', 'value': '-'},
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── UK HESA ─────────────────────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'UK HESA Information'),
                        SizedBox(height: 12),
                        _TwoCol(
                          items: [
                            {'label': 'acemphls', 'value': '-'},
                            {'label': 'clinical', 'value': '-'},
                            {'label': 'campid', 'value': '-'},
                            {'label': 'recon', 'value': '-'},
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── PAR Remarks ─────────────────────────────────────────────
                  _Card(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: _RowHeader(title: 'PAR Remarks'),
                        ),
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
                              const Spacer(),
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
                                      _TH('RPA Remark Code'),
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
                  _Card(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: _RowHeader(title: 'Related Grade'),
                        ),
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
                              const Spacer(),
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
                                    bottom:
                                        BorderSide(color: Color(0xFFE5E7EB)),
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
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Probation and Notice Periods'),
                        SizedBox(height: 12),
                        _TwoCol(
                          items: [
                            {'label': 'Probation Period', 'value': '-'},
                            {'label': 'Under Period', 'value': '-'},
                            {'label': 'Probation End Date', 'value': '-'},
                            {'label': 'Notice Period', 'value': '-'},
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Work Tax Address ────────────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Work Tax Address'),
                        SizedBox(height: 12),
                        _Field(
                          label: 'Work Tax Address',
                          value: '-',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Expenses Information ───────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Expenses Information'),
                        SizedBox(height: 12),
                        _Field(
                          label: 'Default Expense Account',
                          value: '-',
                        ),
                        SizedBox(height: 10),
                        _Field(
                          label: 'Finance Check Send To Address',
                          value: '-',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Expense Account ────────────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Expense Account'),
                        SizedBox(height: 12),
                        _TwoCol(
                          items: [
                            {'label': 'Default Expense Account', 'value': '-'},
                            {
                              'label': 'Finance Check Send To Address',
                              'value': '-',
                            },
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Retirement ─────────────────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Retirement'),
                        SizedBox(height: 12),
                        _TwoCol(
                          items: [
                            {'label': 'Retirement Age', 'value': '-'},
                            {'label': 'Retirement Date', 'value': '-'},
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Collective Agreement ───────────────────────────────────
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _RowHeader(title: 'Collective Agreement'),
                        SizedBox(height: 12),
                        _TwoCol(
                          items: [
                            {'label': 'Union Member', 'value': '-'},
                            {'label': 'Bargaining Unit', 'value': '-'},
                            {'label': 'GHID', 'value': '-'},
                            {'label': 'Collective Agreement', 'value': '-'},
                          ],
                        ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _blue,
        unselectedItemColor: const Color(0xFF9CA3AF),
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Requests'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Approvals',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Directory'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
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
  const _RowHeader({required this.title});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
    ],
  );
}

class _ExpandRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _ExpandRow({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RowHeader(title: title),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ],
    ),
  );
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
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF1F2937),
      ),
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
