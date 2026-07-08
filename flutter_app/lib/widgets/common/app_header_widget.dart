import 'package:flutter/material.dart';

/// Shared application header used across all screens (except the dashboard).
///
/// Displays:
/// - Mannai Corporation logo (centred)
/// - "Hi Curtis Feitty" greeting (small, bold, blue)
/// - [title] of the current screen (large, extra-bold, blue)
///
/// Optionally shows a back-arrow on the left when [showBack] is true.
class AppHeaderWidget extends StatelessWidget {
  /// The screen / section title shown prominently below the greeting.
  final String title;

  /// Whether to show a leading back arrow. Defaults to true.
  final bool showBack;

  /// Actions placed on the right side of the header (e.g. search icon).
  final List<Widget> actions;

  const AppHeaderWidget({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFC9DFF6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Back arrow (left-aligned)
          if (showBack)
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F4E8C).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF1F4E8C),
                    size: 18,
                  ),
                ),
              ),
            ),

          // Right-side actions
          if (actions.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              child: Row(children: actions),
            ),

          // Centred logo + greeting + title
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/mannai_logo.jpeg',
                height: 48,
                fit: BoxFit.contain,
                color: const Color(0xFFC9DFF6),
                colorBlendMode: BlendMode.multiply,
              ),
              const SizedBox(height: 12),
              const Text(
                'Hi Curtis Feitty',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F4E8C),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F4E8C),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
