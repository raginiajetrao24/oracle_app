import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const List<String> _channelTypeOptions = [
  'Chat',
  'Web Conference',
  'Digital Audio and Video',
  'E-Mail',
  'IoT',
  'LinkedIn',
  'Microsoft Teams',
  'None',
  'Phone',
  'SMS',
  'Slack',
  'Social',
  'Web',
  'Cobrowse',
];

const List<String> _queueOptions = [
  'Benefits Queue',
  'Canada - HR Default',
  'Default',
  'Disciplinary Actions',
  'Escalation HR ODA Queue',
  'Germany - HR Auto Assign',
  'Grievances',
  'HR Administration',
  'HR UK Queue',
  'Health and Safety Queue',
  'Health and Safety Supremo',
  'Initial HR ODA Queue',
  'Labor Relations',
  'LiveChat',
  'Payroll Queue',
];

const List<String> _severityOptions = ['High', 'Medium', 'Low'];

const List<String> _attachmentCategoryOptions = [
  'Inline Attachments',
  'Internal',
  'Miscellaneous',
];

const List<String> _contactOptions = [
  'Curtis Feitty',
  'Janice AgentHRHD',
  'John Dunbar',
];

const List<String> _categoryOptions = [
  'Benefits',
  'Payroll',
  'Workplace Relations',
  'HR Administration',
];

const List<String> _productGroupOptions = [
  'Human Resources',
  'Payroll',
  'Benefits',
  'Employee Relations',
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class CreateHelpDeskRequestScreen extends StatefulWidget {
  const CreateHelpDeskRequestScreen({super.key});

  @override
  State<CreateHelpDeskRequestScreen> createState() =>
      _CreateHelpDeskRequestScreenState();
}

class _CreateHelpDeskRequestScreenState
    extends State<CreateHelpDeskRequestScreen> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _primaryContactController = TextEditingController();
  final _queueController = TextEditingController(text: 'Default');
  final _severityController = TextEditingController(text: 'Low');
  final _assignedToController = TextEditingController();
  final _categoryController = TextEditingController();
  final _productGroupController = TextEditingController();
  final _channelTypeController = TextEditingController();
  final _attachmentCategoryController =
      TextEditingController(text: 'Miscellaneous');

  // Focus nodes for the dropdown fields (to trigger options overlay)
  final _primaryContactFocusNode = FocusNode();
  final _queueFocusNode = FocusNode();
  final _severityFocusNode = FocusNode();
  final _assignedToFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _productGroupFocusNode = FocusNode();
  final _channelTypeFocusNode = FocusNode();
  final _attachmentCategoryFocusNode = FocusNode();

  // Overlay entry for options popup
  OverlayEntry? _overlayEntry;

  bool _critical = false;

  // Dropped/selected files (names only for demo)
  final List<String> _attachedFiles = [];
  final List<String> _attachedUrls = [];

  int get _descLength => _descriptionController.text.length;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _removeOverlay();
    _subjectController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _primaryContactController.dispose();
    _queueController.dispose();
    _severityController.dispose();
    _assignedToController.dispose();
    _categoryController.dispose();
    _productGroupController.dispose();
    _channelTypeController.dispose();
    _attachmentCategoryController.dispose();
    _primaryContactFocusNode.dispose();
    _queueFocusNode.dispose();
    _severityFocusNode.dispose();
    _assignedToFocusNode.dispose();
    _categoryFocusNode.dispose();
    _productGroupFocusNode.dispose();
    _channelTypeFocusNode.dispose();
    _attachmentCategoryFocusNode.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOptions(
    BuildContext context,
    TextEditingController controller,
    String title,
    List<String> options,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: options.map((option) {
                      return _OptionTile(
                        label: option,
                        onTap: () {
                          controller.text = option;
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: option.length),
                          );
                          Navigator.pop(ctx);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _attachedUrls.add(url);
        _urlController.clear();
      });
    }
  }

  void _removeUrl(int i) => setState(() => _attachedUrls.removeAt(i));
  void _removeFile(int i) => setState(() => _attachedFiles.removeAt(i));

  void _simulateFilePick() {
    setState(
      () => _attachedFiles.add('document_${_attachedFiles.length + 1}.pdf'),
    );
  }

  void _save() {
    if (_subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subject is required'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request saved successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF16A34A),
      ),
    );
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'New Help Desk Request',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Subject ────────────────────────────────────────────────
            _Card(
              child: _buildTextField(
                controller: _subjectController,
                label: 'Subject',
                hint: 'Enter subject',
                isRequired: true,
              ),
            ),
            const SizedBox(height: 10),

            // ── Basic Fields ───────────────────────────────────────────
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOptionsField(
                    controller: _primaryContactController,
                    label: 'Primary Point of Contact',
                    hint: 'e.g. Curtis Feitty',
                    options: _contactOptions,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionsField(
                    controller: _queueController,
                    label: 'Queue',
                    hint: 'e.g. Default',
                    options: _queueOptions,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionsField(
                    controller: _severityController,
                    label: 'Severity',
                    hint: 'e.g. Low, Medium, High',
                    options: _severityOptions,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionsField(
                    controller: _assignedToController,
                    label: 'Assigned To',
                    hint: 'e.g. John Dunbar',
                    options: _contactOptions,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionsField(
                    controller: _categoryController,
                    label: 'Category',
                    hint: 'e.g. Benefits, Payroll',
                    options: _categoryOptions,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionsField(
                    controller: _productGroupController,
                    label: 'Product Group',
                    hint: 'e.g. Human Resources',
                    options: _productGroupOptions,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionsField(
                    controller: _channelTypeController,
                    label: 'Channel Type',
                    hint: 'e.g. Chat, Email, Phone',
                    options: _channelTypeOptions,
                  ),
                  const SizedBox(height: 12),
                  _CriticalToggle(
                    value: _critical,
                    onChanged: (v) => setState(() => _critical = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Description ────────────────────────────────────────────
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Detailed Description',
                    hint: 'Type # to bring up a list of SmartText.',
                    maxLines: 8,
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${1000 - _descLength} characters remaining',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Attachments ────────────────────────────────────────────
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attachments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Category text field with options
                  _buildOptionsField(
                    controller: _attachmentCategoryController,
                    label: 'Category',
                    hint: 'e.g. Inline Attachments, Internal',
                    options: _attachmentCategoryOptions,
                  ),
                  const SizedBox(height: 14),

                  // Drag & Drop zone
                  _DragDropZone(
                    attachedFiles: _attachedFiles,
                    onFilePick: _simulateFilePick,
                    onRemoveFile: _removeFile,
                  ),
                  const SizedBox(height: 14),

                  // URL row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            labelText: 'URL',
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            hintText: 'Paste a URL...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _addUrl(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _addUrl,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                          ),
                          child: const Text(
                            'Add URL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Attached URLs list
                  if (_attachedUrls.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...List.generate(
                      _attachedUrls.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.link_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _attachedUrls[i],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _removeUrl(i),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Bottom buttons ─────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Save Request',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared field builders ──────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, isRequired: isRequired),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required List<String> options,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, isRequired: isRequired),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                _removeOverlay();
                _showOptions(context, controller, label, options);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Drag & Drop Zone ─────────────────────────────────────────────────────────

class _DragDropZone extends StatefulWidget {
  final List<String> attachedFiles;
  final VoidCallback onFilePick;
  final void Function(int) onRemoveFile;

  const _DragDropZone({
    required this.attachedFiles,
    required this.onFilePick,
    required this.onRemoveFile,
  });

  @override
  State<_DragDropZone> createState() => _DragDropZoneState();
}

class _DragDropZoneState extends State<_DragDropZone> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onFilePick,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: _hovering
                  ? AppColors.primary.withValues(alpha: 0.04)
                  : const Color(0xFFFAFBFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovering ? AppColors.primary : AppColors.border,
                width: _hovering ? 1.5 : 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Drag and Drop',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          text: 'Select',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                          children: const [
                            TextSpan(
                              text: ' or drop files here.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Attached files list
        if (widget.attachedFiles.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...List.generate(widget.attachedFiles.length, (i) {
            final file = widget.attachedFiles[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      file,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onRemoveFile(i),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}

// ─── Critical Toggle ──────────────────────────────────────────────────────────

class _CriticalToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CriticalToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: 'Critical'),
        const SizedBox(height: 6),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFD1D5DB),
        ),
      ],
    );
  }
}

// ─── Field Label ─────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FieldLabel({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        children: isRequired
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─── Option Tile (for bottom sheet options) ────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OptionTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.check_rounded,
              size: 18,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
