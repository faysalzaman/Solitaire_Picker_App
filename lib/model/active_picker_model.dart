class ActivePickerModel {
  String? id;
  String? customerId;
  String? pickerId;
  String? status;
  double? customerLat;
  double? customerLng;
  String? location;
  String? createdAt;
  String? updatedAt;
  Customer? customer;

  ActivePickerModel({
    this.id,
    this.customerId,
    this.pickerId,
    this.status,
    this.customerLat,
    this.customerLng,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.customer,
  });

  ActivePickerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    pickerId = json['pickerId'];
    status = json['status'];
    customerLat = json['customerLat'];
    customerLng = json['customerLng'];
    location = json['location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['pickerId'] = this.pickerId;
    data['status'] = this.status;
    data['customerLat'] = this.customerLat;
    data['customerLng'] = this.customerLng;
    data['location'] = this.location;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Customer {
  String? id;
  String? name;
  String? phone;

  Customer({this.id, this.name, this.phone});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}
