class OnboardingQuestionsModel {
  OnboardingQuestionsModel({
    this.result,
    this.lists,
    this.status,
    this.message,
  });

  OnboardingQuestionsModel.fromJson(dynamic json) {
    try {
      result = json['result'] != null ? Result.fromJson(json['result']) : null;
      lists = json['lists'] != null ? List<String>.from(json['lists']) : [];
      status = json['status'];
      message = json['message'];
    } catch (e) {
      print('Error parsing OnboardingQuestionsModel: $e');
    }
  }

  Result? result;
  List<String>? lists;
  num? status;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (result != null) {
      map['result'] = result?.toJson();
    }
    map['lists'] = lists;
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}

class Result {
  Result({
    this.casParser,
  });

  Result.fromJson(dynamic json) {
    try {
      casParser = json['cas_parser'] != null ? CasParser.fromJson(json['cas_parser']) : null;
    } catch (e) {
      print('Error parsing Result: $e');
    }
  }

  CasParser? casParser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (casParser != null) {
      map['cas_parser'] = casParser?.toJson();
    }
    return map;
  }
}

class CasParser {
  CasParser({
    this.title,
    this.description,
    this.icon,
    this.questions,
  });

  CasParser.fromJson(dynamic json) {
    try {
      title = json['title'];
      description = json['description'];
      icon = json['icon'];
      if (json['questions'] != null) {
        questions = [];
        for (var v in json['questions']) {
          List<Questions> innerList = [];
          for (var innerV in v) {
            innerList.add(Questions.fromJson(innerV));
          }
          questions?.add(innerList);
        }
      }
    } catch (e) {
      print('Error parsing CasParser: $e');
    }
  }

  String? title;
  String? description;
  String? icon;
  List<List<Questions>>? questions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['icon'] = icon;
    if (questions != null) {
      map['questions'] = questions!.map((innerList) =>
          innerList.map((v) => v.toJson()).toList()).toList();
    }
    return map;
  }
}

class Questions {
  Questions({
    this.id,
    this.question,
    this.subject,
    this.fieldType,
    this.inputType,
    this.requiredStatus,
    this.mainQStatus,
    this.relatedOptions,
    this.status,
    this.step,
    this.createdAt,
    this.updatedAt,
    this.parentId,
    this.sort,
    this.goalId,
    this.stepperTitle,
    this.options,
  });

  Questions.fromJson(dynamic json) {
    try {
      id = json['id'];
      question = json['question'];
      subject = json['subject'];
      fieldType = json['field_type'];
      inputType = json['input_type'];
      requiredStatus = json['required_status'];
      mainQStatus = json['main_q_status'];
      relatedOptions = json['related_options'];
      status = json['status'];
      step = json['step'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
      parentId = json['parent_id'];
      sort = json['sort'];
      goalId = json['goal_id'];
      stepperTitle = json['stepper_title'];
      if (json['options'] != null) {
        options = [];
        for (var v in json['options']) {
          options?.add(Options.fromJson(v));
        }
      }
    } catch (e) {
      print('Error parsing Questions: $e');
    }
  }

  num? id;
  String? question;
  String? subject;
  String? fieldType;
  String? inputType;
  String? requiredStatus;
  num? mainQStatus;
  String? relatedOptions;
  num? status;
  num? step;
  String? createdAt;
  String? updatedAt;
  dynamic parentId;
  num? sort;
  dynamic goalId;
  String? stepperTitle;
  List<Options>? options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['question'] = question;
    map['subject'] = subject;
    map['field_type'] = fieldType;
    map['input_type'] = inputType;
    map['required_status'] = requiredStatus;
    map['main_q_status'] = mainQStatus;
    map['related_options'] = relatedOptions;
    map['status'] = status;
    map['step'] = step;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['parent_id'] = parentId;
    map['sort'] = sort;
    map['goal_id'] = goalId;
    map['stepper_title'] = stepperTitle;
    if (options != null) {
      map['options'] = options?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Options {
  Options({
    this.id,
    this.questionId,
    this.option,
    this.description,
    this.sort,
    this.logo,
  });

  Options.fromJson(dynamic json) {
    try {
      id = json['id'];
      questionId = json['question_id'];
      option = json['option'];
      description = json['description'];
      sort = json['sort'];
      logo = json['logo'];
    } catch (e) {
      print('Error parsing Options: $e');
    }
  }

  num? id;
  num? questionId;
  String? option;
  dynamic description;
  num? sort;
  String? logo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['question_id'] = questionId;
    map['option'] = option;
    map['description'] = description;
    map['sort'] = sort;
    map['logo'] = logo;
    return map;
  }
}
