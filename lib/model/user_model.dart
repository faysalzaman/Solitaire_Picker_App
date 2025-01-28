class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? avatar;
  String? status;
  double? avgRating;
  bool? isActive;
  bool? hasFingerprint;
  bool? hasNfcCard;
  String? updatedAt;
  String? createdAt;
  String? token;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.avatar,
      this.status,
      this.avgRating,
      this.isActive,
      this.hasFingerprint,
      this.hasNfcCard,
      this.updatedAt,
      this.createdAt,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    avatar = json['avatar'];
    status = json['status'];
    avgRating = json['avgRating'];
    isActive = json['isActive'] ?? false;
    hasFingerprint = json['hasFingerprint'] ?? false;
    hasNfcCard = json['hasNfcCard'] ?? false;
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['avatar'] = avatar;
    data['status'] = status;
    data['avgRating'] = avgRating;
    data['isActive'] = isActive;
    data['hasFingerprint'] = hasFingerprint;
    data['hasNfcCard'] = hasNfcCard;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    data['token'] = token;
    return data;
  }
}
