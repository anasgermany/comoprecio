import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Animated search bar widget
class SearchBarWidget extends StatefulWidget {
  final String? initialQuery;
  final bool autofocus;
  final Function(String)? onSubmitted;

  const SearchBarWidget({
    super.key,
    this.initialQuery,
    this.autofocus = false,
    this.onSubmitted,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onSubmitted(String query) {
    if (query.trim().isEmpty) return;
    
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(query);
    } else {
      context.push('/search?q=${Uri.encodeComponent(query)}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused ? AppColors.primary : AppColors.surfaceVariant,
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSubmitted,
        style: AppTypography.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Buscar producto, marca o UPC...',
          hintStyle: AppTypography.bodyLarge.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 52,
            minHeight: 52,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
