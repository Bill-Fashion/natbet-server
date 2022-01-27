class UserHistory {
  String? userId;
  int? leftBet;
  int? leftPrize;
  int? rightBet;
  int? rightPrize;

  UserHistory(
      {this.userId,
      this.leftBet,
      this.leftPrize,
      this.rightBet,
      this.rightPrize});

  UserHistory.fromJson(Map<String, dynamic> json)
      : this(
          leftBet: json['leftBetBudget']! as int,
          leftPrize: json['leftPrize']! as int,
          rightBet: json['rightBetBudget']! as int,
          rightPrize: json['rightPrize']! as int,
        );

  Map<String, dynamic> toJson() {
    return {
      'leftBet': leftBet,
      'leftPrize': leftPrize,
      'rightBet': rightBet,
      'rightPrize': rightPrize,
    };
  }
}
