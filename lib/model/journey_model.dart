class JourneyModel {
  String? id;
  String? customerId;
  String? pickerId;
  String? startTime;
  String? endTime;
  num? totalTime;
  num? idleTime;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<StoreVisits>? storeVisits;

  JourneyModel({
    this.id,
    this.customerId,
    this.pickerId,
    this.startTime,
    this.endTime,
    this.totalTime,
    this.idleTime,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.storeVisits,
  });

  JourneyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    pickerId = json['pickerId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    totalTime = json['totalTime'];
    idleTime = json['idleTime'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['storeVisits'] != null) {
      storeVisits = <StoreVisits>[];
      json['storeVisits'].forEach((v) {
        storeVisits!.add(new StoreVisits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['pickerId'] = this.pickerId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['totalTime'] = this.totalTime;
    data['idleTime'] = this.idleTime;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['storeVisits'] =
        this.storeVisits?.map((v) => v.toJson()).toList() ?? [];
    return data;
  }
}

class StoreVisits {
  String? id;
  String? journeyId;
  String? storeId;
  String? storeName;
  String? entryTime;
  String? exitTime;
  num? duration;
  String? scanType;
  String? createdAt;
  String? updatedAt;

  StoreVisits({
    this.id,
    this.journeyId,
    this.storeId,
    this.storeName,
    this.entryTime,
    this.exitTime,
    this.duration,
    this.scanType,
    this.createdAt,
    this.updatedAt,
  });

  StoreVisits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    journeyId = json['journeyId'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    entryTime = json['entryTime'];
    exitTime = json['exitTime'];
    duration = json['duration'];
    scanType = json['scanType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['journeyId'] = this.journeyId;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['entryTime'] = this.entryTime;
    data['exitTime'] = this.exitTime;
    data['duration'] = this.duration;
    data['scanType'] = this.scanType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
