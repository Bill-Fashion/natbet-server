class LogicService {
  double calculateOdds(int leftBudget, int rightBudget, int sideOdds) {
    var prizePool = leftBudget + rightBudget;
    if (sideOdds == 0) {
      double oddsString = prizePool / leftBudget;
      return oddsString;
    } else {
      double oddsString = prizePool / rightBudget;

      return oddsString;
    }
  }

  int calculatePrize(double odds, int currentCoinsUserBet) {
    int result = (currentCoinsUserBet * odds).round();
    return result;
  }
}
