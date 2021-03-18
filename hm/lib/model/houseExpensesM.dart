import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/roomM.dart';

class HouseExpensesM{
  HouseExpensesM({
    this.mark,
    this.expense,
    this.expenseDate,
});
  String mark;
  FeeTypeCost expense;
  MyTimeM expenseDate;

  initialize(String mark, FeeTypeCost expense, MyTimeM expenseDate){
    this.expense = expense;
    this.mark = mark;
    this.expenseDate = expenseDate;
  }

  factory HouseExpensesM.fromJson(Map<String, dynamic> json){
    return HouseExpensesM(
      mark: json['mark'],
      expenseDate: json['expenseDate'] != null ? MyTimeM.fromJson(json['expenseDate']) : null,
      expense: json['expense'] != null ? FeeTypeCost.fromJson(json['expense']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> houseExpenses = Map<String, dynamic>();
    houseExpenses["mark"] = this.mark;
    if (this.expense != null) {
      houseExpenses['expense'] = this.expense.toJson();
    }
    if (this.expenseDate != null) {
      houseExpenses['expenseDate'] = this.expenseDate.toJson();
    }
    return houseExpenses;
  }

}