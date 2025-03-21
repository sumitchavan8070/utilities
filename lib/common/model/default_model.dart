class DefaultModel {
  DefaultModel({
    this.result,
    this.message,
    this.status,
  });

  DefaultModel.fromJson(dynamic json) {
    try {
      result = json['result'] != null ? Result.fromJson(json['result']) : null;
      message = json['message'];
      status = json['status'];
    } catch (e) {
      print('Error parsing DefaultModel: $e');
    }
  }

  Result? result;
  String? message;
  num? status;

  Map<String, dynamic> toJson() {
    try {
      final map = <String, dynamic>{};
      if (result != null) {
        map['result'] = result?.toJson();
      }
      map['message'] = message;
      map['status'] = status;
      return map;
    } catch (e) {
      print('Error serializing DefaultModel: $e');
      return {};
    }
  }
}

class Result {
  Result({
    this.forceUpdate,
    this.softUpdate,
    this.buildNo,
    this.downloadUrl,
    this.path,
    this.paymentType,
    this.privacy,
    this.terms,
    this.isServerMaintenance,
    this.title,
    this.message,
  });

  Result.fromJson(dynamic json) {
    try {
      forceUpdate = json['force_update'];
      softUpdate = json['soft_update'];
      buildNo = json['build_no'];
      downloadUrl = json['download_url'];
      path = json['path'];
      paymentType = json['payment_type'];
      privacy = json['privacy'];
      terms = json['terms'];
      isServerMaintenance = json['is_server_maintenance'];
      title = json['title'];
      message = json['message'];
    } catch (e) {
      print('Error parsing Result: $e');
    }
  }

  num? forceUpdate;
  num? softUpdate;
  num? buildNo;
  String? downloadUrl;
  String? path;
  String? privacy;
  String? terms;
  int? paymentType;
  num? isServerMaintenance;
  String? title;
  String? message;

  Map<String, dynamic> toJson() {
    try {
      final map = <String, dynamic>{};
      map['force_update'] = forceUpdate;
      map['soft_update'] = softUpdate;
      map['build_no'] = buildNo;
      map['download_url'] = downloadUrl;
      map['path'] = path;
      map['payment_type'] = paymentType;
      map['privacy'] = privacy;
      map['terms'] = terms;
      map['is_server_maintenance'] = isServerMaintenance;
      map['title'] = title;
      map['message'] = message;
      return map;
    } catch (e) {
      print('Error serializing Result: $e');
      return {};
    }
  }
}
