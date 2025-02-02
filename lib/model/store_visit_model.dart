class StoreVisitModel {
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

  StoreVisitModel({
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

  StoreVisitModel.fromJson(Map<String, dynamic> json) {
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
