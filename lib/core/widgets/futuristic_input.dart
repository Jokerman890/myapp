import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

class FuturisticInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;
  final double? height;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextStyle? style;
  final TextStyle? hintStyle;

  const FuturisticInput({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines,
    this.height,
    this.prefix,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.style,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Glowing Border Animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.turquoise.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          
          // Input Field
          TextField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            style: style ?? Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle ?? TextStyle(
                color: AppColors.lightGray.withOpacity(0.5),
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              prefixIcon: prefix != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: prefix,
                    )
                  : null,
              suffixIcon: suffix != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: suffix,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class FuturisticLanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Map<String, String> languages;
  final ValueChanged<String?> onChanged;

  const FuturisticLanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          dropdownColor: AppColors.darkPurple,
          style: Theme.of(context).textTheme.bodyLarge,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.white.withOpacity(0.7),
          ),
          items: languages.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
