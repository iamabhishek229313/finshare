class UserData {
  String? name;
  int? phone;
  String? email;
  String? userId;
  int? createdAt;
  List<String>? cards;
  List<String>? invites;
  List<String>? invitesSent;

  UserData(
      {this.name, this.phone, this.email, this.userId, this.createdAt, this.cards, this.invites, this.invitesSent});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    cards = json['cards'].cast<String>();
    invites = json['invites'].cast<String>();
    invitesSent = json['invitesSent'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['user_id'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['cards'] = this.cards;
    data['invites'] = this.invites;
    data['invitesSent'] = this.invitesSent;
    return data;
  }
}
