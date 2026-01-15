import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive font size using device scale
    double scaledFont(double base) {
      return base * MediaQuery.of(context).textScaleFactor;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            // Ensure text field cannot overflow horizontally
            maxWidth: constraints.maxWidth,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword ? obscureText : false,
            validator: validator,
            style: TextStyle(
              fontSize: scaledFont(15),
              color: AppColors.secondary,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              labelText: label,
              labelStyle: TextStyle(
                fontSize: scaledFont(15),
                color: AppColors.hint,
              ),
              prefixIcon: Icon(icon, color: AppColors.primary, size: scaledFont(22)),
              // Password eye icon
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.hint,
                        size: scaledFont(21),
                      ),
                      onPressed: onToggleVisibility,
                      splashRadius: 20,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.secondary, width: 2),
              ),
              errorMaxLines: 2, // Avoid overflow with error messages
            ),
          ),
        );
      },
    );
  }
}
