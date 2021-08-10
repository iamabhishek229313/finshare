import 'package:finshare/models/card_data.dart';

class Invitation {
  String? cardNumber;
  String? from;
  String? to;
  int? createdAt;
  String? status;
  Members? members;

  Invitation({this.cardNumber, this.from, this.to, this.createdAt, this.status, this.members});

  Invitation.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    from = json['from'];
    to = json['to'];
    createdAt = json['createdAt'];
    status = json['status'];
    members = json['members'] != null ? new Members.fromJson(json['members']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNumber'] = this.cardNumber;
    data['from'] = this.from;
    data['to'] = this.to;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.members != null) {
      data['members'] = this.members?.toJson();
    }
    return data;
  }
}
