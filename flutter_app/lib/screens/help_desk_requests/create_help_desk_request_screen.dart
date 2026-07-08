//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../app/constants/app_colors.dart';

// ─── Attached file model ──────────────────────────────────────────────────────

class _AttachedFile {
  final String name;
  final String path;
  final int bytes;

  const _AttachedFile({
    required this.name,
    required this.path,
    required this.bytes,
  });

  String get sizeLabel {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String get extension => name.contains('.') ? name.split('.').last.toUpperCase() : 'FILE';
}

// ─── Options ──────────────────────────────────────────────────────────────────

const List<String> _channelTypeOptions = [
  'Chat', 'Web Conference', 'Digital Audio and Video', 'E-Mail',
  'IoT', 'LinkedIn', 'Microsoft Teams', 'None', 'Phone',
  'SMS', 'Slack', 'Social', 'Web', 'Cobrowse',
];
const List<String> _queueOptions = [
  'Benefits Queue', 'Canada - HR Default', 'Default',
  'Disciplinary Actions', 'Escalation HR ODA Queue',
  'Germany - HR Auto Assign', 'Grievances', 'HR Administration',
  'HR UK Queue', 'Health and Safety Queue', 'Initial HR ODA Queue',
  'Labor Relations', 'LiveChat', 'Payroll Queue',
];
const List<String> _severityOptions = ['High', 'Medium', 'Low'];
const List<String> _attachmentCategoryOptions = [
  'Inline Attachments', 'Internal', 'Miscellaneous',
];
const List<String> _contactOptions = [
  'Curtis Feitty', 'Janice AgentHRHD', 'John Dunbar',
];
const List<String> _categoryOptions = [
  'Benefits', 'Payroll', 'Workplace Relations', 'HR Administration',
];
const List<String> _productGroupOptions = [
  'Human Resources', 'Payroll', 'Benefits', 'Employee Relations',
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
  final _assignedToController = TextEditingController();
  final _queueController = TextEditingController();
  final _categoryController = TextEditingController();
  final _productGroupController = TextEditingController();
  final _channelTypeController = TextEditingController();

  String _queue = _queueOptions.first;
  String _severity = 'Low';
  String _attachmentCategory = 'Miscellaneous';
  bool _critical = false;
  bool _isPickingFile = false;

  final List<_AttachedFile> _attachedFiles = [];
  final List<String> _attachedUrls = [];

  int get _descLength => _descriptionController.text.length;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() => setState(() {}));
    _queueController.text = _queue;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _primaryContactController.dispose();
    _assignedToController.dispose();
    _queueController.dispose();
    _categoryController.dispose();
    _productGroupController.dispose();
    _channelTypeController.dispose();
    super.dispose();
  }

  // ── File picker ─────────────────────────────────────────────────────────────

  Future<void> _pickFiles() async {
    if (_isPickingFile) return;
    setState(() => _isPickingFile = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        withData: false,
        withReadStream: false,
      );

      if (result == null || result.files.isEmpty) {
        // User cancelled — do nothing
        return;
      }

      final newFiles = result.files
          .where((f) => f.path != null && f.name.isNotEmpty)
          .map((f) => _AttachedFile(
                name: f.name,
                path: f.path!,
                bytes: f.size,
              ))
          .toList();

      // Avoid duplicates by name
      setState(() {
        for (final file in newFiles) {
          if (!_attachedFiles.any((a) => a.name == file.name)) {
            _attachedFiles.add(file);
          }
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open file picker: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  void _removeFile(int i) => setState(() => _attachedFiles.removeAt(i));

  void _addUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _attachedUrls.add(url);
        _urlController.clear();
      });
    }
  }

  void _save() {
    if (_subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Subject is required'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFFDC2626),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Request saved successfully'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xFF16A34A),
    ));
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
        title: const Text('New Help Desk Request',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
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
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
              child: const Text('Save',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Subject ──────────────────────────────────────────────────
          _Card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const _FieldLabel(label: 'Subject', isRequired: true),
              const SizedBox(height: 6),
              _textField(controller: _subjectController, hint: 'Enter subject'),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('Required',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ),
            ]),
          ),
          const SizedBox(height: 10),

          // ── Basic Information ─────────────────────────────────────────
          _Card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Basic Information'),
              const SizedBox(height: 16),

              const _FieldLabel(label: 'Primary Point of Contact'),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(
                  child: _ComboField(
                    controller: _primaryContactController,
                    hint: 'Select or type contact name',
                    options: _contactOptions,
                    onSelected: (v) => setState(() {
                      _primaryContactController.text = v;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                _LookupBtn(onTap: () {}),
              ]),
              const SizedBox(height: 14),

              const _FieldLabel(label: 'Assigned To'),
              const SizedBox(height: 6),
              _ComboField(
                controller: _assignedToController,
                hint: 'Select or type name',
                options: _contactOptions,
                onSelected: (v) =>
                    setState(() => _assignedToController.text = v),
              ),
              const SizedBox(height: 14),

              const _FieldLabel(label: 'Queue'),
              const SizedBox(height: 6),
              _ComboField(
                controller: _queueController,
                hint: 'Select queue',
                options: _queueOptions,
                onSelected: (v) => setState(() {
                  _queue = v;
                  _queueController.text = v;
                }),
              ),
              const SizedBox(height: 14),

              const _FieldLabel(label: 'Category'),
              const SizedBox(height: 6),
              _ComboField(
                controller: _categoryController,
                hint: 'Select category',
                options: _categoryOptions,
                onSelected: (v) =>
                    setState(() => _categoryController.text = v),
              ),
              const SizedBox(height: 14),

              const _FieldLabel(label: 'Product Group'),
              const SizedBox(height: 6),
              _ComboField(
                controller: _productGroupController,
                hint: 'Select product group',
                options: _productGroupOptions,
                onSelected: (v) =>
                    setState(() => _productGroupController.text = v),
              ),
              const SizedBox(height: 14),

              const _FieldLabel(label: 'Channel Type'),
              const SizedBox(height: 6),
              _ComboField(
                controller: _channelTypeController,
                hint: 'Select channel type',
                options: _channelTypeOptions,
                onSelected: (v) =>
                    setState(() => _channelTypeController.text = v),
              ),
              const SizedBox(height: 14),

              const _FieldLabel(label: 'Severity'),
              const SizedBox(height: 6),
              _dropdownField(
                value: _severity,
                items: _severityOptions,
                onChanged: (v) =>
                    setState(() => _severity = v ?? _severity),
              ),
              const SizedBox(height: 14),

              _CriticalToggle(
                value: _critical,
                onChanged: (v) => setState(() => _critical = v),
              ),
            ]),
          ),
          const SizedBox(height: 10),

          // ── Description ───────────────────────────────────────────────
          _Card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Description'),
              const SizedBox(height: 16),
              const _FieldLabel(label: 'Detailed Description'),
              const SizedBox(height: 6),
              TextField(
                controller: _descriptionController,
                maxLines: 8,
                maxLength: 1000,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Type # to bring up a list of SmartText.',
                  hintStyle: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5)),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Type # to bring up a list of SmartText.',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  Text('${1000 - _descLength} characters remaining',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.primary)),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 10),

          // ── Attachments ───────────────────────────────────────────────
          _Card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Attachments'),
              const SizedBox(height: 16),

              const _FieldLabel(label: 'Category'),
              const SizedBox(height: 6),
              _dropdownField(
                value: _attachmentCategory,
                items: _attachmentCategoryOptions,
                onChanged: (v) => setState(
                    () => _attachmentCategory = v ?? _attachmentCategory),
              ),
              const SizedBox(height: 14),

              // ── Drag & Drop zone ──────────────────────────────────────
              _DragDropZone(
                isLoading: _isPickingFile,
                onTap: _pickFiles,
              ),
              const SizedBox(height: 12),

              // ── Attached files list ───────────────────────────────────
              if (_attachedFiles.isNotEmpty) ...[
                const _FieldLabel(label: 'Attached Files'),
                const SizedBox(height: 8),
                ..._attachedFiles.asMap().entries.map(
                      (e) => _FileRow(
                        file: e.value,
                        onRemove: () => _removeFile(e.key),
                      ),
                    ),
                const SizedBox(height: 10),
              ],

              // ── URL row ───────────────────────────────────────────────
              const _FieldLabel(label: 'URL'),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(
                  child: _textField(
                    controller: _urlController,
                    hint: 'Paste a URL...',
                    onSubmitted: (_) => _addUrl(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _addUrl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: const Text('Add URL',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),

              // Attached URLs
              if (_attachedUrls.isNotEmpty) ...[
                const SizedBox(height: 12),
                ..._attachedUrls.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(children: [
                        const Icon(Icons.link_rounded,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(e.value,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.primary),
                              overflow: TextOverflow.ellipsis),
                        ),
                        GestureDetector(
                          onTap: () => setState(
                              () => _attachedUrls.removeAt(e.key)),
                          child: const Icon(Icons.close_rounded,
                              size: 16,
                              color: AppColors.textSecondary),
                        ),
                      ]),
                    )),
              ],
            ]),
          ),
          const SizedBox(height: 20),

          // ── Bottom buttons ────────────────────────────────────────────
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.maybePop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Cancel',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
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
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Save Request',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  // ─── Builders ──────────────────────────────────────────────────────────────

  Widget _textField({
    required TextEditingController controller,
    String? hint,
    void Function(String)? onSubmitted,
  }) =>
      TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              fontSize: 13, color: AppColors.textSecondary),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      );

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textPrimary),
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                size: 20, color: AppColors.textSecondary),
            items: items
                .map((i) => DropdownMenuItem(
                    value: i,
                    child: Text(i,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14))))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      );

  Widget _sectionTitle(String text) => Row(children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
      ]);
}

// ─── Drag & Drop Zone ─────────────────────────────────────────────────────────

class _DragDropZone extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _DragDropZone({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  ),
                  SizedBox(width: 12),
                  Text('Opening file picker...',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              )
            : Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF5FC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.cloud_upload_outlined,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Drag and Drop',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      RichText(
                        text: const TextSpan(
                          text: 'Select',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                          children: [
                            TextSpan(
                              text: ' or drop files here.',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary, size: 20),
              ]),
      ),
    );
  }
}

// ─── File Row ─────────────────────────────────────────────────────────────────

class _FileRow extends StatelessWidget {
  final _AttachedFile file;
  final VoidCallback onRemove;

  const _FileRow({required this.file, required this.onRemove});

  Color get _extColor {
    switch (file.extension.toLowerCase()) {
      case 'PDF': return const Color(0xFFDC2626);
      case 'DOC':
      case 'DOCX': return const Color(0xFF2563EB);
      case 'XLS':
      case 'XLSX': return const Color(0xFF16A34A);
      case 'PNG':
      case 'JPG':
      case 'JPEG': return const Color(0xFF9333EA);
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
              color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Row(children: [
        // File type badge
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _extColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            file.extension.length > 4
                ? file.extension.substring(0, 4)
                : file.extension,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: _extColor),
          ),
        ),
        const SizedBox(width: 12),
        // File info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.name,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                file.sizeLabel,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        // Remove
        GestureDetector(
          onTap: onRemove,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.close_rounded,
                size: 16, color: AppColors.textSecondary),
          ),
        ),
      ]),
    );
  }
}

// ─── Combo Field ──────────────────────────────────────────────────────────────

class _ComboField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const _ComboField({
    required this.controller,
    required this.hint,
    required this.options,
    required this.onSelected,
  });

  @override
  State<_ComboField> createState() => _ComboFieldState();
}

class _ComboFieldState extends State<_ComboField> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlay;
  List<String> _filtered = [];

  void _open(String query) {
    _filtered = query.isEmpty
        ? widget.options
        : widget.options
            .where((o) => o.toLowerCase().contains(query.toLowerCase()))
            .toList();

    _close();
    if (_filtered.isEmpty) return;

    _overlay = OverlayEntry(
      builder: (_) => Positioned(
        width: 280,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 52),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (_, i) => InkWell(
                  onTap: () {
                    widget.onSelected(_filtered[i]);
                    _close();
                  },
                  borderRadius: i == 0
                      ? const BorderRadius.vertical(top: Radius.circular(10))
                      : i == _filtered.length - 1
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(10))
                          : BorderRadius.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Text(_filtered[i],
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textPrimary)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        onChanged: _open,
        onTap: () => _open(widget.controller.text),
        onTapOutside: (_) => _close(),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
              fontSize: 13, color: AppColors.textSecondary),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 20, color: AppColors.textSecondary),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }
}

// ─── Lookup Button ────────────────────────────────────────────────────────────

class _LookupBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _LookupBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.badge_outlined,
              color: AppColors.primary, size: 22),
        ),
      );
}

// ─── Critical Toggle ──────────────────────────────────────────────────────────

class _CriticalToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CriticalToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: value ? const Color(0xFFFEF2F2) : const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value
              ? const Color(0xFFDC2626).withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Row(children: [
        Icon(Icons.warning_amber_rounded,
            size: 20,
            color: value
                ? const Color(0xFFDC2626)
                : AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Critical',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: value
                        ? const Color(0xFFDC2626)
                        : AppColors.textPrimary)),
            Text(
              value ? 'Marked as critical' : 'Not critical',
              style: TextStyle(
                  fontSize: 11,
                  color: value
                      ? const Color(0xFFDC2626).withValues(alpha: 0.7)
                      : AppColors.textSecondary),
            ),
          ]),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFFDC2626),
          activeTrackColor:
              const Color(0xFFDC2626).withValues(alpha: 0.3),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFD1D5DB),
        ),
      ]),
    );
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FieldLabel({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary),
          children: isRequired
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w700),
                  )
                ]
              : [],
        ),
      );
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
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
                offset: Offset(0, 2)),
          ],
        ),
        child: child,
      );
}