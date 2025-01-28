class PickerModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? address;
  String? avatar;
  double? avgRating;
  String? status;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  PickerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.address,
    this.avatar,
    this.avgRating,
    this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  PickerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    address = json['address'];
    avatar = json['avatar'];
    avgRating = json['avgRating'];
    status = json['status'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['address'] = address;
    data['avatar'] = avatar;
    data['avgRating'] = avgRating;
    data['status'] = status;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
