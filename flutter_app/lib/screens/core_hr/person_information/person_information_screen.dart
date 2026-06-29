import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

class PersonInformationScreen extends StatefulWidget {
  const PersonInformationScreen({super.key});

  @override
  State<PersonInformationScreen> createState() => _PersonInformationScreenState();
}

class _PersonInformationScreenState extends State<PersonInformationScreen> {
  // Name details
  String _startDate = '6/15/05';
  String _nameStyle = 'United States';
  String _lastName = 'Feitty';
  String _firstName = 'Curtis';
  String _title = 'Mr.';

  // Denmark Demographics
  String _dkCountry = 'Denmark';
  String _dkMaritalStatus = 'Single';
  String _dkStartDate = '6/14/26';
  String _dkGender = 'Male';
  String _dkHighestEd = '—';

  // US Demographics
  String _usCountry = 'United States';
  String _usMaritalStatus = 'Single';
  final String _usMaritalStatusChangeDate = '—';
  String _usStartDate = '6/15/05';
  String _usGender = 'Male';
  String _usHighestEd = 'Bachelor of Arts';
  final String _usVeteranStatus = '—';
  final String _usDisabledVeteran = '—';
  final String _usActiveDutyWartime = '—';
  final String _usArmedForcesMedal = '—';
  final String _usRecentlySeparated = '—';
  final String _usNewlySeparatedDischarge = '—';
  final String _usSexAtBirth = '—';
  final String _usRegionalEthnicity = '—';

  // Ethnicity states
  bool _isHispanicOrLatino = false;
  bool _raceAmericanIndian = false;
  bool _raceAsian = false;
  bool _raceBlack = false;
  bool _raceHawaiian = false;
  bool _raceWhite = false;

  // National Identifiers
  String _nationalCountry = 'United States';
  String _nationalIdType = 'Social Security Number';
  String _nationalId = '123-45-6789';
  String _nationalIssueDate = '—';
  String _nationalExpirationDate = '—';
  bool _isNationalIdVisible = false;

  // Biographical
  final String _dob = '10/23/76';

  String _calculateAge() {
    final dobDateTime = DateTime(1976, 10, 23);
    final now = DateTime.now();
    int years = now.year - dobDateTime.year;
    int months = now.month - dobDateTime.month;
    int days = now.day - dobDateTime.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    return '$years Years $months Months $days Days';
  }

  void _editNameDetails() {
    final titleController = TextEditingController(text: _title);
    final firstController = TextEditingController(text: _firstName);
    final lastController = TextEditingController(text: _lastName);
    final styleController = TextEditingController(text: _nameStyle);
    final dateController = TextEditingController(text: _startDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Name Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: firstController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: styleController,
                  decoration: const InputDecoration(labelText: 'Name Style'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _title = titleController.text;
                      _firstName = firstController.text;
                      _lastName = lastController.text;
                      _nameStyle = styleController.text;
                      _startDate = dateController.text;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B2956),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editPhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Profile Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Library'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Library selection is not configured.')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera selection is not configured.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editDemographics() {
    final dkCountryController = TextEditingController(text: _dkCountry);
    final dkMaritalController = TextEditingController(text: _dkMaritalStatus);
    final dkStartDateController = TextEditingController(text: _dkStartDate);
    final dkGenderController = TextEditingController(text: _dkGender);
    final dkHighestEdController = TextEditingController(text: _dkHighestEd);

    final usCountryController = TextEditingController(text: _usCountry);
    final usMaritalController = TextEditingController(text: _usMaritalStatus);
    final usStartDateController = TextEditingController(text: _usStartDate);
    final usGenderController = TextEditingController(text: _usGender);
    final usHighestEdController = TextEditingController(text: _usHighestEd);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Demographic Info',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Denmark Info', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: dkCountryController,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                  TextField(
                    controller: dkMaritalController,
                    decoration: const InputDecoration(labelText: 'Marital Status'),
                  ),
                  TextField(
                    controller: dkStartDateController,
                    decoration: const InputDecoration(labelText: 'Start Date'),
                  ),
                  TextField(
                    controller: dkGenderController,
                    decoration: const InputDecoration(labelText: 'Gender'),
                  ),
                  TextField(
                    controller: dkHighestEdController,
                    decoration: const InputDecoration(labelText: 'Highest Education Level'),
                  ),
                  const SizedBox(height: 20),
                  const Text('United States Info', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: usCountryController,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                  TextField(
                    controller: usMaritalController,
                    decoration: const InputDecoration(labelText: 'Marital Status'),
                  ),
                  TextField(
                    controller: usStartDateController,
                    decoration: const InputDecoration(labelText: 'Start Date'),
                  ),
                  TextField(
                    controller: usGenderController,
                    decoration: const InputDecoration(labelText: 'Gender'),
                  ),
                  TextField(
                    controller: usHighestEdController,
                    decoration: const InputDecoration(labelText: 'Highest Education Level'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dkCountry = dkCountryController.text;
                        _dkMaritalStatus = dkMaritalController.text;
                        _dkStartDate = dkStartDateController.text;
                        _dkGender = dkGenderController.text;
                        _dkHighestEd = dkHighestEdController.text;

                        _usCountry = usCountryController.text;
                        _usMaritalStatus = usMaritalController.text;
                        _usStartDate = usStartDateController.text;
                        _usGender = usGenderController.text;
                        _usHighestEd = usHighestEdController.text;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B2956),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _editNationalIdentifiers() {
    final countryController = TextEditingController(text: _nationalCountry);
    final typeController = TextEditingController(text: _nationalIdType);
    final idController = TextEditingController(text: _nationalId);
    final issueController = TextEditingController(text: _nationalIssueDate);
    final expController = TextEditingController(text: _nationalExpirationDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit National Identifiers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: countryController,
                  decoration: const InputDecoration(labelText: 'Country'),
                ),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'National ID Type'),
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'National ID'),
                ),
                TextField(
                  controller: issueController,
                  decoration: const InputDecoration(labelText: 'Issue Date'),
                ),
                TextField(
                  controller: expController,
                  decoration: const InputDecoration(labelText: 'Expiration Date'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _nationalCountry = countryController.text;
                      _nationalIdType = typeController.text;
                      _nationalId = idController.text;
                      _nationalIssueDate = issueController.text;
                      _nationalExpirationDate = expController.text;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B2956),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          // Shared app header
          AppHeaderWidget(
            title: 'Personal Details',
            showBack: true,
          ),

          // Cards list
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildNameCard(),
                  _buildPhotoCard(),
                  _buildDemographicCard(),
                  _buildNationalIdentifiersCard(),
                  _buildBiographicalCard(),
                  _buildDisabilityCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCard({
    required String title,
    VoidCallback? onEditPressed,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (onEditPressed != null)
                GestureDetector(
                  onTap: onEditPressed,
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF7B8B9B),
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF7B8B9B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '—' : value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNameCard() {
    return _buildCard(
      title: 'Name',
      onEditPressed: _editNameDetails,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('Start Date', _startDate)),
              Expanded(child: _buildField('Name Style', _nameStyle)),
              Expanded(child: _buildField('Last Name', _lastName)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('First Name', _firstName)),
              Expanded(child: _buildField('Title', _title)),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard() {
    return _buildCard(
      title: 'Photo',
      onEditPressed: _editPhoto,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/curtis_feitty.png',
            width: 140,
            height: 140,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 140,
                height: 140,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDemographicCard() {
    return _buildCard(
      title: 'Demographic info',
      onEditPressed: _editDemographics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Denmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildField('Country for Demographic Reporting', _dkCountry),
              ),
              Expanded(child: _buildField('Marital Status', _dkMaritalStatus)),
              Expanded(child: _buildField('Start Date', _dkStartDate)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('Gender', _dkGender)),
              Expanded(child: _buildField('Highest Education Level', _dkHighestEd)),
              const Expanded(child: SizedBox()),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE2E8F0)),
          ),

          // United States
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildField('Country for Demographic Reporting', _usCountry),
              ),
              Expanded(child: _buildField('Marital Status', _usMaritalStatus)),
              Expanded(
                child: _buildField('Marital Status Change Date', _usMaritalStatusChangeDate),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('Start Date', _usStartDate)),
              Expanded(child: _buildField('Gender', _usGender)),
              Expanded(child: _buildField('Highest Education Level', _usHighestEd)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildField('Veteran Self-Identification Status', _usVeteranStatus),
              ),
              Expanded(child: _buildField('Disabled Veteran', _usDisabledVeteran)),
              Expanded(
                child: _buildField(
                  'Active Duty Wartime or Campaign Badge Veterans',
                  _usActiveDutyWartime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildField('Armed Forces Service Medal Veteran', _usArmedForcesMedal),
              ),
              Expanded(child: _buildField('Recently Separated Veteran', _usRecentlySeparated)),
              Expanded(
                child: _buildField(
                  'Newly Separated Veteran Discharge Date',
                  _usNewlySeparatedDischarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('Sex at Birth', _usSexAtBirth)),
              Expanded(child: _buildField('Regional Ethnicity or Race', _usRegionalEthnicity)),
              const Expanded(child: SizedBox()),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE2E8F0)),
          ),

          // Ethnicity list
          Row(
            children: [
              const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF7B8B9B)),
              const SizedBox(width: 8),
              const Text(
                'Ethnicity',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ethnicity list is not editable.')),
                  );
                },
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF7B8B9B),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckbox(
            'I am Hispanic or Latino.',
            _isHispanicOrLatino,
            (val) => setState(() => _isHispanicOrLatino = val ?? false),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the races you identify with:',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          _buildCheckbox(
            'American Indian or Alaska Native',
            _raceAmericanIndian,
            (val) => setState(() => _raceAmericanIndian = val ?? false),
          ),
          _buildCheckbox(
            'Asian',
            _raceAsian,
            (val) => setState(() => _raceAsian = val ?? false),
          ),
          _buildCheckbox(
            'Black or African American',
            _raceBlack,
            (val) => setState(() => _raceBlack = val ?? false),
          ),
          _buildCheckbox(
            'Native Hawaiian or other Pacific Islander',
            _raceHawaiian,
            (val) => setState(() => _raceHawaiian = val ?? false),
          ),
          _buildCheckbox(
            'White',
            _raceWhite,
            (val) => setState(() => _raceWhite = val ?? false),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF1F4E8C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNationalIdentifiersCard() {
    return _buildCard(
      title: 'National identifiers',
      onEditPressed: _editNationalIdentifiers,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('Country', _nationalCountry)),
              Expanded(child: _buildField('National ID Type', _nationalIdType)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'National ID',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF7B8B9B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _isNationalIdVisible ? _nationalId : '*********',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isNationalIdVisible = !_isNationalIdVisible;
                            });
                          },
                          child: Icon(
                            _isNationalIdVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 16,
                            color: const Color(0xFF7B8B9B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('Issue Date', _nationalIssueDate)),
              Expanded(child: _buildField('Expiration Date', _nationalExpirationDate)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF5FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Primary',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF1F4E8C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiographicalCard() {
    return _buildCard(
      title: 'Biographical info',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildField('Date of Birth', _dob)),
              Expanded(child: _buildField('Age', _calculateAge())),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisabilityCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Disability info',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Disability details additions are coming soon.')),
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF7B8B9B),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Add any mental or physical disabilities, or decline to declare.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
