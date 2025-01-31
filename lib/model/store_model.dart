class StoreModel {
  String? id;
  String? storeName;
  String? description;
  String? location;
  String? logo;
  String? category;
  String? qrCode;
  String? nfcTag;
  num? visitCount;
  String? operatingHours;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  StoreModel({
    this.id,
    this.storeName,
    this.description,
    this.location,
    this.logo,
    this.category,
    this.qrCode,
    this.nfcTag,
    this.visitCount,
    this.operatingHours,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    description = json['description'];
    location = json['location'];
    logo = json['logo'];
    category = json['category'];
    qrCode = json['qrCode'];
    nfcTag = json['nfcTag'];
    visitCount = json['visitCount'];
    operatingHours = json['operatingHours'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['storeName'] = this.storeName;
    data['description'] = this.description;
    data['location'] = this.location;
    data['logo'] = this.logo;
    data['category'] = this.category;
    data['qrCode'] = this.qrCode;
    data['nfcTag'] = this.nfcTag;
    data['visitCount'] = this.visitCount;
    data['operatingHours'] = this.operatingHours;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
