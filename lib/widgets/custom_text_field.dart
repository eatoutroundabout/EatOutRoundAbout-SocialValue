import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final Color? labelColor;
  final int? maxLines;
  final bool? validate;
  final bool? isPassword;
  final bool? isEmail;
  final bool? enabled;
  final double? textFieldWidth;
  final Widget? dropdown;

  CustomTextField({ this.textFieldWidth,this.hint, this.isEmail, this.label, this.controller, this.textInputType, this.labelColor, this.maxLines, this.validate, this.isPassword, this.enabled, this.dropdown});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != '')
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 15),
            child: Text(label!, style: TextStyle(color: labelColor ?? primaryColor)),
          ),
        dropdown == null
            ? Container(
              width: textFieldWidth?? textFieldWidth,
              child: TextFormField(
                  enabled: enabled ?? true,
                  obscureText: isPassword ?? false,
                  maxLines: maxLines ?? 1,
                  keyboardType: textInputType,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => validate ?? false
                      ? isEmail ?? false
                          ? miscService.validateEmail(value!)
                          : miscService.validateText(value!)
                      : null,
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    isDense: true,
                  ),
                ),
            )
            : dropdown!,
      ],
    );
  }
}
