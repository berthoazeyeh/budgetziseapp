// import 'package:easy_localization/easy_localization.dart' show tr;
// import 'package:flutter/material.dart';
// import 'package:flutter_laravel_form_validation/validator.dart';

// typedef ValidatorFn = String? Function(String?);

// Map<String, String> buildFLVCustomMessages(String? field, [String extra = '']) {
//   final list = [
//     'required',
//     'min',
//     'same',
//     'max',
//     'endsWith',
//     'lowercase',
//     'uppercase',
//     'startsWith',
//     'contain',
//     'email',
//     'numeric',
//     'integer',
//     'double',
//     'alphaNum',
//     'between',
//     'contains',
//     'haveAlpha',
//     'ip',
//     'inRes',
//     'notIn',
//     'lt',
//     'gt',
//     'lte',
//     'gte',
//     'url',
//     'regex',
//   ];
//   /*
// 	final map = {
// 		"required": LocaleKeys.FLValidator_required.tr(namedArgs: { 'field': field, 'extra': extra }),
// 		"min": LocaleKeys.FLValidator_min,
// 		"same": LocaleKeys.FLValidator_same,
// 		"max": LocaleKeys.FLValidator_max,
// 		"endsWith": LocaleKeys.FLValidator_endsWith,
// 		"lowercase": LocaleKeys.FLValidator_lowercase,
// 		"uppercase": LocaleKeys.FLValidator_uppercase,
// 		"startsWith": LocaleKeys.FLValidator_startsWith,
// 		"contain": LocaleKeys.FLValidator_contain,
// 		"email": LocaleKeys.FLValidator_email,
// 		"numeric": LocaleKeys.FLValidator_numeric,
// 		"integer": LocaleKeys.FLValidator_integer,
// 		"double": LocaleKeys.FLValidator_double,
// 		"alphaNum": LocaleKeys.FLValidator_alphaNum,
// 		"between": LocaleKeys.FLValidator_between,
// 		"contains": LocaleKeys.FLValidator_contains,
// 		"haveAlpha": LocaleKeys.FLValidator_haveAlpha,
// 		"ip": LocaleKeys.FLValidator_ip,
// 		"inRes": LocaleKeys.FLValidator_inRes,
// 		"notIn": LocaleKeys.FLValidator_notIn,
// 		"lt": LocaleKeys.FLValidator_lt,
// 		"gt": LocaleKeys.FLValidator_gt,
// 		"lte": LocaleKeys.FLValidator_lte,
// 		"gte": LocaleKeys.FLValidator_gte,
// 		"url": LocaleKeys.FLValidator_url,
// 		"regex": LocaleKeys.FLValidator_regex,
// 	}; */

//   return list.fold<Map<String, String>>({}, (map, key) {
//     map.putIfAbsent(
//       key,
//       () => tr(
//         'FLValidator.$key',
//         namedArgs: {'field': field ?? '', 'extra': extra},
//       ),
//     );
//     return map;
//   });
// }

// class MyFormGroup {
//   final formKey = GlobalKey<FormState>();
//   final Map<String, MyFormControl> _fields;
//   final Map<String, ValidatorFn?> _validators;

//   MyFormGroup(this._fields)
//       : _validators = _fields.map<String, ValidatorFn>(
//           (key, field) => MapEntry(
//             key,
//             Valiadator().make(
//               field.rules,
//               attribute: field.label ?? key,
//               customMessages: buildFLVCustomMessages(field.label),
//             )!,
//           ),
//         );

//   TextEditingController getController(String name) => _fields[name]!.controller;

//   ValidatorFn? getValidation(String name) => _validators[name];

//   bool validateForm() => formKey.currentState?.validate() ?? false;

//   Map<String, dynamic> get values =>
//       _fields.map((key, field) => MapEntry(key, field.value));

//   dynamic value(String name) => _fields[name]!.value;

//   void resetForm() => formKey.currentState?.reset();
// }

// class MyFormControl<T> {
//   final String? label;
//   final List<dynamic> rules;
//   final TextEditingController controller;
//   final ValidatorFn validator;

//   MyFormControl({
//     T? defaultValue,
//     this.label,
//     this.rules = const [],
//   })  : controller = TextEditingController(text: defaultValue?.toString()),
//         validator = Valiadator().make(
//           rules,
//           attribute: label,
//           customMessages: buildFLVCustomMessages(label),
//         )!;

//   void dispose() => controller.dispose();

//   String get valueAsString => controller.text;

//   int get valueAsInt => int.parse(controller.text);

//   int? get valueAsNullableInt => int.tryParse(controller.text);

//   num get valueAsNum => num.parse(controller.text);

//   num? get valueAsNullableNum => num.tryParse(controller.text);

//   double get valueAsDouble => double.parse(controller.text);

//   double? get valueAsNullableDouble => double.tryParse(controller.text);

//   bool get valueAsBool => bool.parse(controller.text);

//   bool? get valueAsNullableBool => bool.tryParse(controller.text);

//   T? get value {
//     final text = controller.text;
//     switch (T.toString()) {
//       case 'String':
//       case 'String?':
//         return text as T?;
//       case 'int':
//       case 'int?':
//         return int.tryParse(text) as T?;
//       case 'double':
//       case 'double?':
//         return double.tryParse(text) as T?;
//       case 'num':
//       case 'num?':
//         return num.tryParse(text) as T?;
//       case 'bool':
//       case 'bool?':
//         return bool.tryParse(text, caseSensitive: false) as T?;
//       default:
//         return text.toString() as T?;
//     }
//   }
// }
