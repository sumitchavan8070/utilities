import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:utilities/components/button_loader.dart';
import 'package:utilities/packages/dynamic_form/OnboardingQuestionsController.dart';
import 'package:utilities/packages/dynamic_form/custom_question_card.dart';
import 'package:utilities/packages/dynamic_form/dynamic_form_selection_widget.dart';
import 'package:utilities/packages/dynamic_form/onboarding_questions_model.dart';
import 'package:utilities/theme/app_colors.dart';

final _feedbackQuestionsController = Get.put(OnboardingQuestionsController());

final amountFromat = RegExp(r'[^0-9]');

class DynamicFormView extends StatefulWidget {
  const DynamicFormView({
    super.key,
    required this.type,
    this.showCardBg = true,
    this.showStepper = true,
    this.showIndex = true,
  });

  final String type;
  final bool showCardBg;
  final bool showStepper;
  final bool showIndex;

  @override
  State<DynamicFormView> createState() => _DynamicFormViewState();
}

class _DynamicFormViewState extends State<DynamicFormView> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  Map<int, Map<String, dynamic>> answer = {};

  List<Map<String, dynamic>> transformMapToList(Map<int, Map<String, dynamic>> rxMap) {
    List<Map<String, dynamic>> resultList = rxMap.values.toList();

    // for (var map in resultList) {
    //   if (map.containsKey('answer') && map['answer'] is String?) {
    //     map['answer'] = map['answer'];
    //   }
    // }

    return resultList;
  }

  @override
  void initState() {
    super.initState();
    if (_feedbackQuestionsController.state?.result == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _feedbackQuestionsController.getFeedbackQuestions(type: widget.type);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _feedbackQuestionsController.obx(
      (state) {
        final questions = state?.result?.casParser?.questions;
        debugPrint(" model data ${_feedbackQuestionsController.state?.result?.casParser}");
        return Column(
          children: [
            const SizedBox(height: 20),
            if (widget.showStepper)
              _feedbackQuestionsController.obx((state) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(questions?.length ?? 0, (index) {
                    bool isActive = index == currentPage;
                    return Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryColor : AppColors.lavenderMist,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    );
                  }),
                );
              }),
            Flexible(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: List.generate(questions?.length ?? 0, (index) {
                  final stepQuestion = questions?[index];

                  return DynamicFormWidgetSelector(
                    showCardBg: widget.showCardBg,
                    showIndex: widget.showIndex,
                    questions: stepQuestion,
                    answer: answer,
                    i: index,
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage != 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 50),
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          side: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Text(
                        "Back",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 50),
                      elevation: 0,
                      backgroundColor: AppColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        side: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                    onPressed: () async {
                      if (_feedbackQuestionsController.isLoading.value == true) {
                        return;
                      }
                      final data = transformMapToList(answer);
                      debugPrint("---- $data");

                      FocusManager.instance.primaryFocus?.unfocus();

                      for (int i = 0; i < (questions?[currentPage].length ?? 0); i++) {
                        final question = questions?[currentPage][i];

                        if (question?.requiredStatus == "0") {
                          continue;
                        }
                        if (answer.containsKey(question?.id) == false) {
                          // show error
                          final optionError = "Required question no ${currentPage + 1}";
                          // coreMessenger(optionError);

                          return;
                        }

                        if (answer[question?.id]?["answer"] == null) {
                          // show error
                          final optionError = "Required question no ${currentPage + 1}";
                          // coreMessenger(optionError);
                          return;
                        }
                      }

                      if (currentPage == (questions?.length ?? 0) - 1) {
                        if (widget.type.toLowerCase() == "sip suggestion" ||
                            widget.type.toLowerCase() == "lumpsum suggestion") {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: SuggestionLoadingDialog(),
                              );
                            },
                          );
                        }

                        final response = await _feedbackQuestionsController.submitFeedbackQuestions(
                          type: widget.type,
                          answerMap: transformMapToList(answer),
                        );
                        if (response == null) {
                          // coreMessenger(response?['message'] ?? "Something went wrong!");
                          return;
                        }

                        // setPortfolioRoute(CorePortfolioRoutePaths.casStatementInfoView);
                        // CoreNavigator.pushNamedAndRemoveUntil(
                        //   CorePortfolioRoutePaths.casStatementInfoView,
                        //   (route) => route.isCurrent,
                        // );
                      }
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    },
                    child: ButtonLoader(
                      buttonString: currentPage == (questions?.length ?? 0) - 1 ? "Submit" : "Next",
                      isLoading: _feedbackQuestionsController.isLoading,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
      onLoading: const Center(child: CircularProgressIndicator()),
      onError: (error) {
        return Text("data");
        // return RefreshApiWidget(
        //   error: true,
        //   onTap: () {
        //     _feedbackQuestionsController.getFeedbackQuestions(type: widget.type);
        //   },
        // );
      },
    );
  }
}

class DynamicFormWidgetSelector extends StatelessWidget {
  const DynamicFormWidgetSelector({
    super.key,
    required this.questions,
    required this.answer,
    required this.showCardBg,
    this.showIndex = true,
    required this.i,
  });

  final List<Questions>? questions;
  final Map<int, Map<String, dynamic>> answer;
  final bool showCardBg;
  final bool showIndex;
  final int i;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(questions?.length ?? 0, (index) {
          final question = questions?[index];

          return CustomQuestionCard(
            index: index + 1,
            showCardBg: false,
            title: question?.question,
            data: i == 0 ? "Lets start," : "Great,",
            child: DynamicFormSelectionWidget(
              option: question?.options,
              answer: answer,
              questionID: question?.id ?? -1,
              list: List.generate(
                question?.options?.length ?? 0,
                (index) {
                  final option = question?.options?[index];
                  return option?.option.toString() ?? "-";
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class KeyValuePair<T, R> {
  KeyValuePair({
    required this.key,
    required this.value,
    this.path,
  });

  final T key;
  final R value;
  final String? path;
}

class SuggestionLoadingDialog extends StatefulWidget {
  const SuggestionLoadingDialog({super.key});

  @override
  State<SuggestionLoadingDialog> createState() => _SuggestionLoadingDialogState();
}

class _SuggestionLoadingDialogState extends State<SuggestionLoadingDialog> {
  Timer? timer;
  int index = 0;
  final loaderTexts = [
    KeyValuePair(key: "Request Received", value: "Confirming your request"),
    KeyValuePair(key: "Analyzing Profile", value: "Assessing your risk and tenure."),
    KeyValuePair(key: "Processing Funds", value: "Shortlisting funds based on your profile."),
  ];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (index + 1 >= loaderTexts.length) {
        timer.cancel();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            ++index;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            loaderTexts[index].key,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 20),
          LottieBuilder.asset(
            'assets/lottieFiles/generating.json',
            height: 160,
          ),
          const SizedBox(width: 12),
          ...List.generate(loaderTexts.length, (listIndex) {
            if (index == listIndex) {
              return FadeInDemo(
                child: Text(
                  loaderTexts[index].value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.boulder),
                ),
              );
            }

            return const SizedBox.shrink();
          })
        ],
      ),
    );
  }
}

class FadeInDemo extends StatefulWidget {
  const FadeInDemo({super.key, required this.child});

  final Widget child;

  @override
  FadeInDemoState createState() => FadeInDemoState();
}

class FadeInDemoState extends State<FadeInDemo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;

  late final Animation<Offset> _offsetAnimation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.8),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
          opacity: _curve,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.child,
            ),
          )),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
