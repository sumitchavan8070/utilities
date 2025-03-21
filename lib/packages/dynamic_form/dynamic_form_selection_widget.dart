import 'package:flutter/material.dart';
import 'package:utilities/packages/dynamic_form/onboarding_questions_model.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';

class DynamicFormSelectionWidget extends StatefulWidget {
  const DynamicFormSelectionWidget({
    super.key,
    required this.list,
    required this.answer,
    required this.questionID,
    required this.option,
  });

  final List<String> list;
  final Map<int, Map<String, dynamic>> answer;
  final num questionID;
  final List<Options>? option;

  @override
  State<DynamicFormSelectionWidget> createState() => _DynamicFormSelectionWidgetState();
}

class _DynamicFormSelectionWidgetState extends State<DynamicFormSelectionWidget> {
  onOptionSelect({
    required Options? option,
    required num? questionId,
    required Map<int, Map<String, dynamic>> answerMap,
  }) {
    final int qId = questionId?.toInt() ?? 0;
    answerMap[qId] ??= {};
    answerMap[qId]?.update("question_id", (value) => questionId, ifAbsent: () => questionId);
    answerMap[qId]?.update("option_id", (value) => option?.id, ifAbsent: () => option?.id);
    answerMap[qId]?.update("answer", (value) => option?.option, ifAbsent: () => option?.option);

    debugPrint(answerMap.toString());
  }

  getSelectedValue({
    required num? optionId,
    required num? questionId,
    required Map<int, Map<String, dynamic>> answerMap,
  }) {
    final value = answerMap[questionId?.toInt() ?? 0];

    return value?.containsKey("option_id") == true && value?["option_id"] == optionId;
  }

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List.generate(
        widget.list.length,
        (index) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();

              setState(() {
                onOptionSelect(
                  answerMap: widget.answer,
                  option: widget.option?[index],
                  questionId: widget.questionID,
                );
              });
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                decoration: CoreBoxDecoration.getBoxDecoration(
                  addBorder: true,
                  border: Border.all(
                    color: getSelectedValue(
                      answerMap: widget.answer,
                      optionId: widget.option?[index].id,
                      questionId: widget.questionID,
                    )
                        ? AppColors.primaryColor
                        : AppColors.silverChalice30,
                  ),
                  color: getSelectedValue(
                    answerMap: widget.answer,
                    optionId: widget.option?[index].id,
                    questionId: widget.questionID,
                  )
                      ? AppColors.lavenderMist
                      : Colors.white,
                  removeShadow: true,
                  borderRadius: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.list[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: getSelectedValue(
                          answerMap: widget.answer,
                          optionId: widget.option?[index].id,
                          questionId: widget.questionID,
                        )
                            ? AppColors.primaryColor
                            : AppColors.monsoon),
                  ),
                )
                // widget.list[index],
                ),
          );
        },
      ),
    );
  }
}
