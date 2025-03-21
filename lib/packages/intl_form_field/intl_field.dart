import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utilities/packages/smooth_rectangular_border.dart';
import 'package:utilities/theme/app_colors.dart';

import 'countries.dart';
import 'county_picker.dart';
import 'phone_number.dart';

class IntlPhoneField extends StatefulWidget {
  final GlobalKey<FormFieldState>? formFieldKey;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;
  final bool readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<Country>? onCountryChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final String? initialValue;
  final String languageCode;
  final String? initialCountryCode;
  final InputDecoration decoration;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final String searchText;
  final bool autofocus;
  final AutovalidateMode? autovalidateMode;
  final Color? cursorColor;
  final EdgeInsets flagsButtonMargin;
  final Decoration? dropdownContainerDecoration;
  final bool? showBorder;

  const IntlPhoneField({
    Key? key,
    this.formFieldKey,
    this.initialCountryCode,
    this.languageCode = 'en',
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.onCountryChanged,
    this.onSaved,
    this.inputFormatters,
    this.enabled = true,
    @Deprecated('Use searchFieldInputDecoration of PickerDialogStyle instead')
    this.searchText = 'Search country',
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.cursorColor,
    this.flagsButtonMargin = const EdgeInsets.symmetric(horizontal: 10),
    this.dropdownContainerDecoration,
    this.showBorder,
  }) : super(key: key);

  @override
  State<IntlPhoneField> createState() => _IntlPhoneFieldState();
}

class _IntlPhoneFieldState extends State<IntlPhoneField> {
  late List<Country> _countryList;
  late Country _selectedCountry;
  late List<Country> filteredCountries;
  late String number;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    _countryList = countries;
    filteredCountries = _countryList;
    number = widget.initialValue ?? '';
    if (widget.initialCountryCode == null && number.startsWith('+')) {
      number = number.substring(1);
      _selectedCountry = countries.firstWhere(
          (country) => number.startsWith(country.fullCountryCode),
          orElse: () => _countryList.first);

      number = number.replaceFirst(RegExp("^${_selectedCountry.fullCountryCode}"), "");
    } else {
      _selectedCountry = _countryList.firstWhere(
          (item) => item.code == (widget.initialCountryCode ?? 'IN'),
          orElse: () => _countryList.first);

      if (number.startsWith('+')) {
        number = number.replaceFirst(RegExp("^\\+${_selectedCountry.fullCountryCode}"), "");
      } else {
        number = number.replaceFirst(RegExp("^${_selectedCountry.fullCountryCode}"), "");
      }
    }
  }

  Future<void> _changeCountry() async {
    filteredCountries = _countryList;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      shape: const SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius.vertical(
          top: SmoothRadius(cornerRadius: 16, cornerSmoothing: 1.0),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => CountryPickerDialog(
          languageCode: widget.languageCode.toLowerCase(),
          filteredCountries: filteredCountries,
          searchText: widget.searchText,
          countryList: _countryList,
          selectedCountry: _selectedCountry,
          onCountryChanged: (Country country) {
            _selectedCountry = country;
            widget.onCountryChanged?.call(country);
            setState(() {});
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final outlineDecorationBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
      borderRadius: BorderRadius.circular(10),
    );
    return TextFormField(
      key: widget.formFieldKey,
      initialValue: (widget.controller == null) ? number : null,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      readOnly: widget.readOnly,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      cursorColor: widget.cursorColor ?? Colors.black,
      onTap: widget.onTap,
      controller: widget.controller,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onSubmitted,
      decoration: widget.decoration.copyWith(
        prefixIcon: _buildFlagsButton(),
        fillColor: AppColors.alabaster,
        counterText: '',
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.mistBlueLight, fontWeight: FontWeight.w300),
        // border: OutlineInputBorder(
        //   borderSide: const BorderSide(color: AppColors.lightGrey, width: 3),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        border: outlineDecorationBorder,
        enabledBorder: widget.showBorder ?? false ? outlineDecorationBorder : InputBorder.none,
        disabledBorder: widget.showBorder ?? false ? outlineDecorationBorder : InputBorder.none,
        focusedBorder: widget.showBorder ?? false ? outlineDecorationBorder : InputBorder.none,
        errorBorder: widget.showBorder ?? false ? outlineDecorationBorder : InputBorder.none,
        focusedErrorBorder: widget.showBorder ?? false ? outlineDecorationBorder : InputBorder.none,
      ),
      style: widget.style,
      onSaved: (value) {
        widget.onSaved?.call(
          PhoneNumber(
            countryISOCode: _selectedCountry.code,
            countryCode: '+${_selectedCountry.dialCode}${_selectedCountry.regionCode}',
            number: value!,
          ),
        );
      },
      onChanged: (value) async {
        final phoneNumber = PhoneNumber(
          countryISOCode: _selectedCountry.code,
          countryCode: '+${_selectedCountry.fullCountryCode}',
          number: value,
        );

        widget.onChanged?.call(phoneNumber);
      },
      validator: widget.validator,
      maxLength: _selectedCountry.maxLength,
      keyboardType: TextInputType.phone,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      autovalidateMode: widget.autovalidateMode,
    );
  }

  Container _buildFlagsButton() {
    return Container(
      margin: widget.flagsButtonMargin,
      decoration: widget.dropdownContainerDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: InkWell(
        onTap: widget.enabled ? _changeCountry : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4),
            Text(
              _selectedCountry.code,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.mistBlueLight, fontWeight: FontWeight.w300),
            ),
            Text(
              '(+${_selectedCountry.dialCode})',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.mistBlueLight, fontWeight: FontWeight.w300),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.mistBlueLight,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}

enum IconPosition {
  leading,
  trailing,
}
