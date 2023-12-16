import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ActionButtonRow extends StatelessWidget {
  final VoidCallback onResetPressed;
  final VoidCallback onScreenshotPressed; //
  final bool showButtons;

  const ActionButtonRow({
    required this.onResetPressed,
    required this.onScreenshotPressed,
    this.showButtons = true, // Default value is true
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.4;
    final buttonHeight = MediaQuery.of(context).size.height * 0.1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: showButtons
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCustomButton(
                  onPressed: onResetPressed,
                  backgroundColor: Colors.white,
                  icon: Icons.restart_alt,
                  buttonWidth: buttonWidth,
                  buttonHeight: buttonHeight,
                  tooltip: 'Reset default settings'.tr(),
                  heroTag: 'resetButton',
                  isLeftButton: true,
                  semanticLabel:
                      'Reset Button: Resets default settings', // Add semantic label
                ),
                _buildCustomButton(
                  onPressed: onScreenshotPressed,
                  backgroundColor: Colors.white,
                  icon: Icons.share,
                  buttonWidth: buttonWidth,
                  buttonHeight: buttonHeight,
                  tooltip: 'Share a screenshot of your results!'.tr(),
                  heroTag: 'shareButton',
                  isLeftButton: false,
                  semanticLabel:
                      'Share Button: Shares a screenshot of results', // Add semantic label
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCustomButton({
    required VoidCallback onPressed,
    required Color backgroundColor,
    required IconData icon,
    required double buttonWidth,
    required double buttonHeight,
    required String tooltip,
    required String heroTag,
    bool isLeftButton = true,
    required String semanticLabel,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Tooltip(
          message: tooltip,
          child: Semantics(
            // Wrap the button with Semantics and set the label
            label: semanticLabel,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                minimumSize: Size(buttonWidth, buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 20.0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(1.0),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [
                      backgroundColor.withOpacity(0.9),
                      backgroundColor.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: InkWell(
                  splashColor: isLeftButton ? Colors.red : Colors.blueGrey,
                  onTap: onPressed,
                  borderRadius: BorderRadius.circular(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                      child: Icon(
                        icon,
                        color: Colors.black87,
                        size: buttonHeight * 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
