class HistoryModel {
  String? id;
  String? customerId;
  String? startTime;
  String? endTime;
  num? totalTime;
  num? idleTime;
  String? status;
  Count? cCount;
  Customer? customer;
  String? formattedDuration;
  String? formattedIdleTime;
  String? formattedTimeInStores;
  num? storeCount;

  HistoryModel({
    this.id,
    this.customerId,
    this.startTime,
    this.endTime,
    this.totalTime,
    this.idleTime,
    this.status,
    this.cCount,
    this.customer,
    this.formattedDuration,
    this.formattedIdleTime,
    this.formattedTimeInStores,
    this.storeCount,
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    totalTime = json['totalTime'];
    idleTime = json['idleTime'];
    status = json['status'];
    cCount = json['_count'] != null ? new Count.fromJson(json['_count']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    formattedDuration = json['formattedDuration'];
    formattedIdleTime = json['formattedIdleTime'];
    formattedTimeInStores = json['formattedTimeInStores'];
    storeCount = json['storeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['totalTime'] = this.totalTime;
    data['idleTime'] = this.idleTime;
    data['status'] = this.status;
    if (this.cCount != null) {
      data['_count'] = this.cCount!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['formattedDuration'] = this.formattedDuration;
    data['formattedIdleTime'] = this.formattedIdleTime;
    data['formattedTimeInStores'] = this.formattedTimeInStores;
    data['storeCount'] = this.storeCount;
    return data;
  }
}

class Count {
  num? storeVisits;

  Count({this.storeVisits});

  Count.fromJson(Map<String, dynamic> json) {
    storeVisits = json['storeVisits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeVisits'] = this.storeVisits;
    return data;
  }
}

class Customer {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;

  Customer({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    return data;
  }
}
