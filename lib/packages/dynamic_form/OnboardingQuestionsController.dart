import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/packages/dynamic_form/onboarding_questions_model.dart';

class OnboardingQuestionsController extends GetxController
    with StateMixin<OnboardingQuestionsModel> {
  RxBool isLoading = RxBool(false);

  getFeedbackQuestions({required String type}) async {
    const apiEndPoint = APIEndPoints.feedbackQuestions;

    debugPrint("--- $apiEndPoint FeedbackQuestionsController => getFeedbackQuestions > Start ---");

    final postData = {
      "subject_group": type,
    };

    change(null, status: RxStatus.loading());
    try {
      final response = """
        {
    "result": {
        "cas_parser": {
            "title": "Get a Portfolio Checkup with Our Experts",
            "description": "Invest Regular Savings and Build Wealth",
            "icon": "http://betafolio.mysiponline.com/app/question_icon/wealth.png",
            "questions": [
                [
                    {
                        "id": 71,
                        "question": "Select the purpose of your investment. ",
                        "subject": "cas_parser",
                        "field_type": "input",
                        "input_type": "",
                        "required_status": "1",
                        "main_q_status": 0,
                        "related_options": "0",
                        "status": 1,
                        "step": 1,
                        "created_at": "2024-08-29T04:57:46.000000Z",
                        "updated_at": "2024-12-09T05:46:20.000000Z",
                        "parent_id": null,
                        "sort": 1,
                        "goal_id": null,
                        "stepper_title": "Risk Type",
                        "options": [
                            {
                                "id": 185,
                                "question_id": 71,
                                "option": "Invest For Wealth Creation",
                                "description": "",
                                "sort": 1,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/185.png"
                            },
                            {
                                "id": 186,
                                "question_id": 71,
                                "option": "Invest For retirement",
                                "description": "",
                                "sort": 2,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/186.png"
                            },
                            {
                                "id": 187,
                                "question_id": 71,
                                "option": "Invest For Childâ€™s Future",
                                "description": "",
                                "sort": 3,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/187.png"
                            }
                        ]
                    },
                    {
                        "id": 71,
                        "question": "smt chnages  ",
                        "subject": "cas_parser",
                        "field_type": "radio",
                        "input_type": "",
                        "required_status": "1",
                        "main_q_status": 0,
                        "related_options": "0",
                        "status": 1,
                        "step": 1,
                        "created_at": "2024-08-29T04:57:46.000000Z",
                        "updated_at": "2024-12-09T05:46:20.000000Z",
                        "parent_id": null,
                        "sort": 1,
                        "goal_id": null,
                        "stepper_title": "Risk Type",
                        "options": [
                            {
                                "id": 185,
                                "question_id": 71,
                                "option": "Invest For Wealth Creation",
                                "description": "",
                                "sort": 1,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/185.png"
                            },
                            {
                                "id": 186,
                                "question_id": 71,
                                "option": "Invest For retirement",
                                "description": "",
                                "sort": 2,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/186.png"
                            },
                            {
                                "id": 187,
                                "question_id": 71,
                                "option": "Invest For Childâ€™s Future",
                                "description": "",
                                "sort": 3,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/187.png"
                            }
                        ]
                    }
                ],
                [
                    {
                        "id": 70,
                        "question": "Now select the risk factor that you are comfortable with.",
                        "subject": "cas_parser",
                        "field_type": "radio",
                        "input_type": "",
                        "required_status": "1",
                        "main_q_status": 0,
                        "related_options": "0",
                        "status": 1,
                        "step": 2,
                        "created_at": "2024-08-29T04:56:48.000000Z",
                        "updated_at": "2024-12-09T05:46:00.000000Z",
                        "parent_id": null,
                        "sort": 1,
                        "goal_id": null,
                        "stepper_title": "Purpose",
                        "options": [
                            {
                                "id": 183,
                                "question_id": 70,
                                "option": "20-30% fall with maximum recovery period 2-3 Yrs.",
                                "description": "",
                                "sort": 1,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/183.png"
                            },
                            {
                                "id": 184,
                                "question_id": 70,
                                "option": "10-20% Fall with maximum recovery period of 1-2 yr.",
                                "description": "",
                                "sort": 2,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/184.png"
                            },
                            {
                                "id": 188,
                                "question_id": 70,
                                "option": "Lesser than 5% fall with maximum recovery in 3-5 months.",
                                "description": "",
                                "sort": 3,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/188.png"
                            }
                        ]
                    }
                ],
                [
                    {
                        "id": 72,
                        "question": "Now select your investment style. ",
                        "subject": "cas_parser",
                        "field_type": "radio",
                        "input_type": "",
                        "required_status": "1",
                        "main_q_status": 0,
                        "related_options": "0",
                        "status": 1,
                        "step": 3,
                        "created_at": "2024-08-29T05:58:31.000000Z",
                        "updated_at": "2024-12-09T05:46:49.000000Z",
                        "parent_id": null,
                        "sort": 1,
                        "goal_id": null,
                        "stepper_title": "Strategy",
                        "options": [
                            {
                                "id": 189,
                                "question_id": 72,
                                "option": "Quality Investing: Good Growth while maintaining Risk.",
                                "description": "",
                                "sort": 1,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/189.png"
                            },
                            {
                                "id": 190,
                                "question_id": 72,
                                "option": "Aggressive Investing: Maximize returns while accepting short term market volatility risk",
                                "description": "",
                                "sort": 2,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/190.png"
                            },
                            {
                                "id": 191,
                                "question_id": 72,
                                "option": "Conservative Investing: Keep risk to minimum with good growth.",
                                "description": "",
                                "sort": 3,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/191.png"
                            },
                            {
                                "id": 192,
                                "question_id": 72,
                                "option": "I am not sure, please suggest.",
                                "description": "",
                                "sort": 4,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/192.png"
                            }
                        ]
                    }
                ],
                [
                    {
                        "id": 73,
                        "question": "Now select your tenure.",
                        "subject": "cas_parser",
                        "field_type": "radio",
                        "input_type": "",
                        "required_status": "1",
                        "main_q_status": 0,
                        "related_options": "0",
                        "status": 1,
                        "step": 4,
                        "created_at": "2024-08-29T06:00:37.000000Z",
                        "updated_at": "2024-12-08T22:04:05.000000Z",
                        "parent_id": null,
                        "sort": null,
                        "goal_id": null,
                        "stepper_title": "Tenure",
                        "options": [
                            {
                                "id": 193,
                                "question_id": 73,
                                "option": "Short Term (Less than 5 years)",
                                "description": "",
                                "sort": 1,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/193.png"
                            },
                            {
                                "id": 194,
                                "question_id": 73,
                                "option": "Mid Term (5-10 Years)",
                                "description": "",
                                "sort": 2,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/194.png"
                            },
                            {
                                "id": 195,
                                "question_id": 73,
                                "option": "Long Term (More than 10 years)",
                                "description": "",
                                "sort": 3,
                                "logo": "https://folio.mysiponline.com/app/goal_icons/195.png"
                            }
                        ]
                    }
                ]
            ]
        }
    },

    "status": 1,
    "message": "success"
}
      """;
      // final response = await postRequest(
      //   apiEndPoint: apiEndPoint,
      //   postData: postData,
      //   requestFrom: RequestFrom.portfolio,
      // );
      final jsonResponse = jsonDecode(response);

      final modal = OnboardingQuestionsModel.fromJson(jsonResponse);

      debugPrint(" from controller model data ${modal.result?.casParser}");
      change(modal, status: RxStatus.success());
      debugPrint("-------- FeedbackQuestionsController => getFeedbackQuestions > Success --------");
      if (state?.status == 0) {
        change(null, status: RxStatus.error("status code is 200 {status is 0} "));
      }
    } on DioError catch (dioError) {
      debugPrint(
          "---------- FeedbackQuestionsController => getFeedbackQuestions > DioError ----------\n${dioError
              .error}");
      change(null, status: RxStatus.error(dioError.toString()));
    } catch (error) {
      debugPrint(
          "---------- FeedbackQuestionsController => getFeedbackQuestions > Error \n$error----------");
      change(null, status: RxStatus.error(error.toString()));
    } finally {
      debugPrint("---------- FeedbackQuestionsController => getFeedbackQuestions > End ----------");
    }
  }

  submitFeedbackQuestions({
    required List<Map<String, dynamic>> answerMap,
    required String type,
  }) async {
    const apiEndPoint = "feedback/submitFeedback";
    dynamic response;
    isLoading.value = true;

    debugPrint(
        "--- $apiEndPoint FeedbackQuestionsController => submitFeedbackQuestions > Start ---");

    change(null, status: RxStatus.loading());
    final postData = {
      'subject': type,
      "answerList": answerMap,
    };

    try {
      response = """""";

      // response = await postRequest(
      //   apiEndPoint: apiEndPoint,
      //   postData: postData,
      //   requestFrom: RequestFrom.portfolio,
      // );
      debugPrint("----- FeedbackQuestionsController => submitFeedbackQuestions > Success -----");
    } on DioError catch (dioError) {
      debugPrint(
          "---------- FeedbackQuestionsController => submitFeedbackQuestions > DioError ----------\n${dioError
              .error}");
      change(null, status: RxStatus.error(dioError.toString()));
    } catch (error) {
      debugPrint(
          "---------- FeedbackQuestionsController => submitFeedbackQuestions > Error \n$error----------");
      change(null, status: RxStatus.error(error.toString()));
    } finally {
      debugPrint(
          "---------- FeedbackQuestionsController => submitFeedbackQuestions > End ----------");
    }
    return response.data;
  }
}
//
// class OnboardingQuestionsController extends GetxController
//     with StateMixin<OnboardingQuestionsModel> {
//   RxBool isLoading = RxBool(false);
//
//   getFeedbackQuestions({required String type}) async {
//     const apiEndPoint = "feedback/getQuestion";
//
//     change(null, status: RxStatus.loading());
//     debugPrint("---------- $apiEndPoint getFeedbackQuestions Start ----------");
//
//     final postData = {
//       "subject": type,
//     };
//
//     try {
//       final response = await postRequest(
//         apiEndPoint: apiEndPoint,
//         postData: postData,
//         requestFrom: RequestFrom.portfolio,
//       );
//
//       debugPrint("FeedbackQuestionsController => getFeedbackQuestions > Success ");
//
//       if (response?.statusCode != 200) {
//         throw 'API ERROR ${response?.statusCode} Message ${response?.statusMessage}';
//       }
//
//       final modal = OnboardingQuestionsModel.fromJson(response?.data);
//       change(modal, status: RxStatus.success());
//     } catch (error) {
//       debugPrint("---------- $apiEndPoint getFeedbackQuestions End With Error ----------");
//       debugPrint("FeedbackQuestionsController => getFeedbackQuestions > Error $error ");
//       change(null, status: RxStatus.error(error.toString()));
//     } finally {
//       debugPrint("---------- $apiEndPoint getFeedbackQuestions End ----------");
//     }
//   }
//
//   submitFeedbackQuestions({
//     required List<Map<String, dynamic>> answerMap,
//     required String type,
//   }) async {
//     const apiEndPoint = "feedback/submitFeedback";
//     dynamic response;
//     isLoading.value = true;
//     debugPrint("---------- $apiEndPoint submitFeedbackQuestions Start ----------");
//
//     final postData = {
//       'subject': type,
//       "answerList": answerMap,
//     };
//
//     try {
//       response = await postRequest(
//           apiEndPoint: apiEndPoint, postData: postData, requestFrom: RequestFrom.portfolio);
//
//       debugPrint(
//           "FeedbackQuestionsController => submitFeedbackQuestions > Success ${response.data}");
//
//       if (response.statusCode != 200) {
//         throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
//       }
//     } catch (error) {
//       debugPrint("---------- $apiEndPoint submitFeedbackQuestions End With Error ----------");
//       debugPrint("FeedbackQuestionsController => submitFeedbackQuestions > Error $error ");
//     } finally {
//       isLoading.value = false;
//       debugPrint("---------- $apiEndPoint submitFeedbackQuestions End ----------");
//     }
//
//     return response.data;
//   }
// }
