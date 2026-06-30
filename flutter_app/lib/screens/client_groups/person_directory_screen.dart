import 'package:flutter/material.dart';
import 'package:flutter_app/screens/client_groups/person_profile_screen.dart';
import 'package:flutter_app/widgets/common/app_header_widget.dart';

class PersonDirectoryScreen extends StatefulWidget {
  const PersonDirectoryScreen({super.key});

  @override
  State<PersonDirectoryScreen> createState() => _PersonDirectoryScreenState();
}

class _PersonDirectoryScreenState extends State<PersonDirectoryScreen> {
  static const _blue = Color(0xFF1F4E8C);
  static const _muted = Color(0xFF64748B);

  final TextEditingController _searchController = TextEditingController();
  bool _directReportsExpanded = true;

  late final List<PersonRecord> _people = const [
    PersonRecord(
      name: 'Ahmed Shahin',
      initials: 'AS',
      job: 'Analyst',
      email: 'AHMED.SHAHIN_esll-dev2@oracledemos.com',
      phone: '974-64845490',
      personNumber: '1000101',
      department: 'Analytics',
      location: 'Doha, Qatar',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Aisha Alma',
      initials: 'AA',
      job: 'UG Manager',
      email: 'sanita.dalmeida@mannai.com.qa',
      phone: '974-89907654',
      personNumber: '1000102',
      department: 'University Graduate Programs',
      location: 'Doha, Qatar',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Anthony Wesley',
      initials: 'AW',
      job: 'Human Resources Specialist',
      email: 'anthony.wesley_esll-dev2@oracledemos.com',
      phone: '1-770-675-5220',
      personNumber: '1000103',
      department: 'Human Resources',
      location: 'Atlanta, US',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Carli Lavelle',
      initials: 'CL',
      job: 'Human Resources Administrator',
      email: 'Carli.Lavelle_esll-dev2@oracledemos.com',
      phone: '1-906-384-0972',
      personNumber: '1000104',
      department: 'Human Resources',
      location: 'Chicago, US',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Halle Justus',
      initials: 'HJ',
      job: 'Human Resources Generalist',
      email: 'Halle.Justus_esll-dev2@oracledemos.com',
      phone: '1-576-957-5454',
      personNumber: '1000105',
      department: 'Human Resources',
      location: 'Redwood City, US',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Hope Hightower',
      initials: 'HH',
      job: 'Human Resources Generalist',
      email: 'Hope.Hightower_esll-dev2@oracledemos.com',
      phone: '1-847-546-9845',
      personNumber: '1000106',
      department: 'Human Resources',
      location: 'Seattle, US',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Juned Mohamed',
      initials: 'JM',
      job: 'UG HR Consultant',
      email: '',
      phone: '',
      personNumber: '1000107',
      department: 'Consulting',
      location: 'Doha, Qatar',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Kazi Al Shehri',
      initials: 'KS',
      job: 'Analyst',
      email: 'KAZI.ALSHEHRI_esll-dev2@oracledemos.com',
      phone: '973-648454904',
      personNumber: '1000108',
      department: 'Analytics',
      location: 'Manama, Bahrain',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Khalid Almajid',
      initials: 'KA',
      job: 'Minister',
      email: 'Khalid.Almajid_esll-dev2@oracledemos.com',
      phone: '',
      personNumber: '1000109',
      department: 'Executive Office',
      location: 'Doha, Qatar',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Martin Lletget',
      initials: 'ML',
      job: 'Human Resources Generalist',
      email: 'Martin.Lletget_esll-dev2@oracledemos.com',
      phone: '',
      personNumber: '1000110',
      department: 'Human Resources',
      location: 'London, UK',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Mohamed Alkuyvari',
      initials: 'MA',
      job: 'Senior Vice President',
      email: '',
      phone: '',
      personNumber: '1000111',
      department: 'Corporate Strategy',
      location: 'Doha, Qatar',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'Sue Eden',
      initials: 'SE',
      job: 'Product Design Engineer',
      email: 'Sue.Eden_esll-dev2@oracledemos.com',
      phone: '1-906-376-0396',
      personNumber: '1000112',
      department: 'Product Design',
      location: 'Austin, US',
      manager: 'Curtis Feitty',
    ),
    PersonRecord(
      name: 'TAHER BHIRI',
      initials: 'TB',
      job: 'Director of IT',
      email: '',
      phone: '',
      personNumber: '1000113',
      department: 'Information Technology',
      location: 'Doha, Qatar',
      manager: 'Curtis Feitty',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final results = query.isEmpty
        ? _people
        : _people
              .where(
                (person) =>
                    person.name.toLowerCase().contains(query) ||
                    person.job.toLowerCase().contains(query) ||
                    person.email.toLowerCase().contains(query),
              )
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: AppHeaderWidget(title: 'Person', showBack: true),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(child: _buildSearchCard()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverToBoxAdapter(
                child: _buildDirectReportsCard(results),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search for a Person',
          prefixIcon: const Icon(Icons.search_rounded, color: _muted),
          suffixIcon: _searchController.text.isEmpty
              ? const Icon(Icons.keyboard_arrow_down_rounded, color: _muted)
              : IconButton(
                  icon: const Icon(Icons.close_rounded, color: _muted),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _blue, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectReportsCard(List<PersonRecord> people) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: () => setState(
              () => _directReportsExpanded = !_directReportsExpanded,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Direct Reports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  Icon(
                    _directReportsExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: _muted,
                  ),
                ],
              ),
            ),
          ),
          if (_directReportsExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            if (people.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No direct reports found.',
                  style: TextStyle(fontSize: 13, color: _muted),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: people.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: Color(0xFFEFF2F5)),
                itemBuilder: (context, index) {
                  final person = people[index];
                  return _PersonRow(
                    person: person,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonProfileScreen(person: person),
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _PersonRow extends StatelessWidget {
  final PersonRecord person;
  final VoidCallback onTap;

  const _PersonRow({required this.person, required this.onTap});

  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(initials: person.initials),
            const SizedBox(width: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 520;
                  final nameBlock = _NameBlock(person: person);
                  final contactBlock = _ContactBlock(person: person);
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: nameBlock),
                        const SizedBox(width: 16),
                        Expanded(child: contactBlock),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nameBlock,
                      const SizedBox(height: 6),
                      contactBlock,
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
          ],
        ),
      ),
    );
  }
}

class _NameBlock extends StatelessWidget {
  final PersonRecord person;
  const _NameBlock({required this.person});

  static const _linkBlue = Color(0xFF00759B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          person.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: _linkBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          person.job,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class _ContactBlock extends StatelessWidget {
  final PersonRecord person;
  const _ContactBlock({required this.person});

  static const _linkBlue = Color(0xFF00759B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (person.email.isNotEmpty)
          Text(
            person.email,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _linkBlue,
            ),
          ),
        if (person.phone.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            person.phone,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }
}

class PersonRecord {
  final String name;
  final String initials;
  final String job;
  final String email;
  final String phone;
  final String personNumber;
  final String department;
  final String location;
  final String manager;

  const PersonRecord({
    required this.name,
    required this.initials,
    required this.job,
    required this.email,
    required this.phone,
    required this.personNumber,
    required this.department,
    required this.location,
    required this.manager,
  });
}
