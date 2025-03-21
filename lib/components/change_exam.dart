import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utilities/common/controller/update_exam_name.dart';
import 'package:utilities/common_assets_path.dart';
import 'package:utilities/components/enums.dart';
import 'package:utilities/components/message_scaffold.dart';
import 'package:utilities/packages/dialogs.dart';

final _updateExamNameController = Get.put(UpdateExamNameController());

class ChangeExam {
  static Future<void> changeExams({
    required BuildContext context,
  }) async {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Dialogs.selectTestPrepDialog(
          context,
          data: [
            CommonAssetPath.ielts,
            CommonAssetPath.pte,
            CommonAssetPath.toefl,
            CommonAssetPath.duolingo
          ],
          examCallBack: (selectedExam) {
            final examNameExt = selectedExam?.split('/').last;
            final examName = examNameExt?.split('.').first;
            final selectedExamName = examName?.toUpperCase();

            if (selectedExamName != null) {
              var data = [];
              if (selectedExamName == "PTE") {
                data = ["Core", "Academic"];
              } else if (selectedExamName == "DUOLINGO") {
                data = ["Academic"];
              } else {
                data = ["General", "Academic"];
              }
              // Navigator.of(context).pop();
              Future.delayed(const Duration(milliseconds: 100), () {
                Dialogs.selectTestCatDialog(
                  context,
                  data: data,
                  examCatCallBack: (selectedExamCategory) {
                    final selectedExamCat = selectedExamCategory;
                    debugPrint(
                        "selectedExam:::::$selectedExamName ___________ examCat:::::::::::$selectedExamCat");
                    _updateExamNameController
                        .updateExamName(
                      testType: selectedExamName,
                      subTestType: selectedExamCat,
                    )
                        .then(
                      (value) {
                        debugPrint("value:::::::::$value");
                        if (value['status'].toString() == "200") {
                          messageScaffold(
                              context: context,
                              content: "Exam Switch Successfully",
                              messageScaffoldType: MessageScaffoldType.success);
                        } else {
                          messageScaffold(
                              context: context,
                              content: "Something went wrong!",
                              messageScaffoldType: MessageScaffoldType.error);
                        }
                      },
                    );
                  },
                );
              });
            }
          },
        );
      },
    );
  }
}
