class DefaultCustomDrawerModelTow {
  DefaultCustomDrawerModelTow({
      this.status, 
      this.result,});

  DefaultCustomDrawerModelTow.fromJson(dynamic json) {
    status = json['status'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  num? status;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }

}

class Result {
  Result({
      this.inIosReview,
      this.menuItems, 
      this.contact,});

  Result.fromJson(dynamic json) {
    inIosReview = json['inIosReview'];
    if (json['menuItems'] != null) {
      menuItems = [];
      json['menuItems'].forEach((v) {
        menuItems?.add(MenuItems.fromJson(v));
      });
    }
    contact = json['contact'] != null ? Contact.fromJson(json['contact']) : null;
  }
  num? inIosReview;
  List<MenuItems>? menuItems;
  Contact? contact;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inIosReview'] = inIosReview;
    if (menuItems != null) {
      map['menuItems'] = menuItems?.map((v) => v.toJson()).toList();
    }
    if (contact != null) {
      map['contact'] = contact?.toJson();
    }
    return map;
  }

}

class Contact {
  Contact({
      this.whatsappIcon, 
      this.whatsappNumber, 
      this.callIcon, 
      this.callNumber, 
      this.mailIcon, 
      this.mail,});

  Contact.fromJson(dynamic json) {
    whatsappIcon = json['whatsappIcon'];
    whatsappNumber = json['whatsappNumber'];
    callIcon = json['callIcon'];
    callNumber = json['callNumber'];
    mailIcon = json['mailIcon'];
    mail = json['mail'];
  }
  String? whatsappIcon;
  String? whatsappNumber;
  String? callIcon;
  String? callNumber;
  String? mailIcon;
  String? mail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['whatsappIcon'] = whatsappIcon;
    map['whatsappNumber'] = whatsappNumber;
    map['callIcon'] = callIcon;
    map['callNumber'] = callNumber;
    map['mailIcon'] = mailIcon;
    map['mail'] = mail;
    return map;
  }

}

class MenuItems {
  MenuItems({
      this.title, 
      this.path, 
      this.icon,});

  MenuItems.fromJson(dynamic json) {
    title = json['title'];
    path = json['path'];
    icon = json['icon'];
  }
  String? title;
  String? path;
  String? icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['path'] = path;
    map['icon'] = icon;
    return map;
  }

}