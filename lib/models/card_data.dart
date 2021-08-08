class CardData {
  String? bANKNAME;
  String? cARDNUMBER;
  int? sECURITYCODECVC;
  String? vALIDTHRU;
  String? cARDHOLDERNAME;
  String? tYPE;
  double? aVAILBALANCE;
  List<AllTransactions>? allTransactions;
  List<Members>? members;

  CardData(
      {this.bANKNAME,
      this.cARDNUMBER,
      this.sECURITYCODECVC,
      this.vALIDTHRU,
      this.cARDHOLDERNAME,
      this.tYPE,
      this.aVAILBALANCE,
      this.allTransactions,
      this.members});

  CardData.fromJson(Map<String, dynamic> json) {
    bANKNAME = json['BANK_NAME'];
    cARDNUMBER = json['CARD_NUMBER'];
    sECURITYCODECVC = json['SECURITY_CODE_CVC'];
    vALIDTHRU = json['VALID_THRU'];
    cARDHOLDERNAME = json['CARDHOLDER_NAME'];
    tYPE = json['TYPE'];
    aVAILBALANCE = json['AVAIL_BALANCE'];
    if (json['all_transactions'] != null) {
      allTransactions = [];
      json['all_transactions'].forEach((v) {
        allTransactions?.add(new AllTransactions.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members?.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BANK_NAME'] = this.bANKNAME;
    data['CARD_NUMBER'] = this.cARDNUMBER;
    data['SECURITY_CODE_CVC'] = this.sECURITYCODECVC;
    data['VALID_THRU'] = this.vALIDTHRU;
    data['CARDHOLDER_NAME'] = this.cARDHOLDERNAME;
    data['TYPE'] = this.tYPE;
    data['AVAIL_BALANCE'] = this.aVAILBALANCE;
    if (this.allTransactions != null) {
      data['all_transactions'] = this.allTransactions?.map((v) => v.toJson()).toList();
    }
    if (this.members != null) {
      data['members'] = this.members?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllTransactions {
  int? timestamp;
  String? location;
  String? storeName;
  double? amount;
  String? by;
  String? email;

  AllTransactions({this.timestamp, this.location, this.storeName, this.amount, this.by, this.email});

  AllTransactions.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    location = json['location'];
    storeName = json['store_name'];
    amount = json['amount'];
    by = json['by'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['location'] = this.location;
    data['store_name'] = this.storeName;
    data['amount'] = this.amount;
    data['by'] = this.by;
    data['email'] = this.email;
    return data;
  }
}

class Transactions {
  int? timestamp;
  String? location;
  String? storeName;
  double? amount;
  String? by;
  String? email;

  Transactions({this.timestamp, this.location, this.storeName, this.amount, this.by, this.email});

  Transactions.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    location = json['location'];
    storeName = json['store_name'];
    amount = json['amount'];
    by = json['by'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['location'] = this.location;
    data['store_name'] = this.storeName;
    data['amount'] = this.amount;
    data['by'] = this.by;
    data['email'] = this.email;
    return data;
  }
}

class Members {
  String? emailId;
  String? name;
  int? addedAt;
  String? colorHEX;
  String? avatarCode;
  List<Transactions>? transactions;
  String? category;
  Permissions? permissions;

  Members(
      {this.emailId,
      this.name,
      this.addedAt,
      this.colorHEX,
      this.avatarCode,
      this.transactions,
      this.category,
      this.permissions});

  Members.fromJson(Map<String, dynamic> json) {
    emailId = json['email_id'];
    name = json['name'];
    addedAt = json['addedAt'];
    colorHEX = json['colorHEX'];
    avatarCode = json['avatarCode'];
    if (json['transactions'] != null) {
      transactions = [];
      json['transactions'].forEach((v) {
        transactions?.add(Transactions.fromJson(v));
      });
    }
    category = json['category'];
    permissions = json['permissions'] != null ? new Permissions.fromJson(json['permissions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_id'] = this.emailId;
    data['name'] = this.name;
    data['addedAt'] = this.addedAt;
    data['colorHEX'] = this.colorHEX;
    data['avatarCode'] = this.avatarCode;
    if (this.transactions != null) {
      data['transactions'] = this.transactions?.map((v) => v.toJson()).toList();
    }
    data['category'] = this.category;
    if (this.permissions != null) {
      data['permissions'] = this.permissions?.toJson();
    }
    return data;
  }
}

class Permissions {
  double? perTransactionLimit;
  double? dailyLimit;
  double? monthlyLimit;
  String? timingFrom;
  String? timingTo;
  List<String>? categories;

  Permissions(
      {this.perTransactionLimit, this.dailyLimit, this.monthlyLimit, this.timingFrom, this.timingTo, this.categories});

  Permissions.fromJson(Map<String, dynamic> json) {
    perTransactionLimit = json['per_transaction_limit'];
    dailyLimit = json['daily_limit'];
    monthlyLimit = json['monthly_limit'];
    timingFrom = json['timing_from'];
    timingTo = json['timing_to'];
    categories = json['categories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['per_transaction_limit'] = this.perTransactionLimit;
    data['daily_limit'] = this.dailyLimit;
    data['monthly_limit'] = this.monthlyLimit;
    data['timing_from'] = this.timingFrom;
    data['timing_to'] = this.timingTo;
    data['categories'] = this.categories;
    return data;
  }
}
