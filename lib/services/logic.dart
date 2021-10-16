class LogicService {
  double calculateOdds(int leftBudget, int rightBudget, int sideOdds) {
    var prizePool = leftBudget + rightBudget;
    if (sideOdds == 0) {
      String oddsString = (prizePool / leftBudget).toStringAsFixed(2);
      return double.parse(oddsString);
    } else {
      String oddsString = (prizePool / rightBudget).toStringAsFixed(2);
      return double.parse(oddsString);
    }
  }

  int calculatePrize(double odds, int currentCoinsUserBet) {
    int result = (currentCoinsUserBet * odds).round();
    return result;
  }
}
