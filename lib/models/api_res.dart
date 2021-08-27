class APIRES {
  String? id;
  int? ifiID;
  String? vboID;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? shortCode;

  APIRES({this.id, this.ifiID, this.vboID, this.name, this.status, this.createdAt, this.updatedAt, this.shortCode});

  APIRES.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ifiID = json['ifiID'];
    vboID = json['vboID'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    shortCode = json['shortCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ifiID'] = this.ifiID;
    data['vboID'] = this.vboID;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['shortCode'] = this.shortCode;
    return data;
  }
}

class AccountProducts {
  String? id;
  String? productName;
  String? productID;
  String? type;
  String? programIDs;
  int? ifiID;

  AccountProducts({this.id, this.productName, this.productID, this.type, this.programIDs, this.ifiID});

  AccountProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    productID = json['productID'];
    type = json['type'];
    programIDs = json['programIDs'];
    ifiID = json['ifiID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['productID'] = this.productID;
    data['type'] = this.type;
    data['programIDs'] = this.programIDs;
    data['ifiID'] = this.ifiID;
    return data;
  }
}

class PaymentProducts {
  String? id;
  String? productName;
  String? description;
  String? productID;
  String? type;
  String? programIDs;
  int? ifiID;

  PaymentProducts(
      {this.id, this.productName, this.description, this.productID, this.type, this.programIDs, this.ifiID});

  PaymentProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    description = json['description'];
    productID = json['productID'];
    type = json['type'];
    programIDs = json['programIDs'];
    ifiID = json['ifiID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['description'] = this.description;
    data['productID'] = this.productID;
    data['type'] = this.type;
    data['programIDs'] = this.programIDs;
    data['ifiID'] = this.ifiID;
    return data;
  }
}
