//
//  ChartStorageService.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/15/16.
//  Copyright © 2016 wph. All rights reserved.
//

class ChartStorageService: GCBaseStorage {
    static let sharedInstance = ChartStorageService()
    private override init() {}
    
    internal func getPieChartData(monthStr:String?,yearStr:String?,memberId:String?,payOrIncome:String?) -> (array:Array<PieChartGroupModel>?,maxModel:PieChartGroupModel?) {
        var paramDict:Dictionary<String,String> = Dictionary()
        if monthStr != nil {
            paramDict["accountMonthDate"] = monthStr
        }
        if yearStr != nil {
            paramDict["accountYearDate"] = yearStr
        }
        if memberId != nil {
            paramDict["memberId"] = memberId
        }
        if payOrIncome != nil {
            paramDict["payOrIncome"] = payOrIncome
        }
        let resultArray:Array<PieChartGroupModel> = self.groupSumModelArrayByClass(object_getClass(AccountModel()), resultClass: object_getClass(PieChartGroupModel()), sumStr: "amount", params: paramDict, groupStr: "typeId") as! Array<PieChartGroupModel>
        var maxModel:PieChartGroupModel?
        for model in resultArray {
            maxModel = model
        }
        
        return (resultArray,maxModel);
    }
    
    internal func getPieChartLeftData(monthStr:String?,yearStr:String?) -> String {
        var paramDict:Dictionary<String,String> = Dictionary()
        
        if monthStr != nil {
            paramDict["accountMonthDate"] = monthStr
        }
        if yearStr != nil {
            paramDict["accountYearDate"] = yearStr
        }
        
        paramDict["payOrIncome"] = String(AccountType.pay)
        
        var sumPayStr:String? = self.sumResultByClass(object_getClass(AccountModel()), sumStr: "amount", params: paramDict)
        if sumPayStr == nil {
            sumPayStr = "0"
        }
        
        paramDict["payOrIncome"] = String(AccountType.income)
        
        var sumIncomeStr:String? = self.sumResultByClass(object_getClass(AccountModel()), sumStr: "amount", params: paramDict)
        
        if sumIncomeStr == nil {
            sumIncomeStr = "0"
        }

        let leftStr = String(Int(sumIncomeStr!)! - Int(sumPayStr!)!)
        
        return leftStr;
    }
    
    internal func getLineChartTopStatisticData(yearStr:String?) -> (payAvg:String,incomeAvg:String,yearLeft:String) {
        var paramDict:Dictionary<String,String> = Dictionary()
        if yearStr != nil {
            paramDict["accountYearDate"] = yearStr
        }
        
        paramDict["payOrIncome"] = String(AccountType.pay)

        var sumPayStr:String? = self.sumResultByClass(object_getClass(AccountModel()), sumStr: "amount", params: paramDict)
        if sumPayStr == nil {
            sumPayStr = "0"
        }
        let avgPayStr = String(Int(sumPayStr!)! / 12)
        
        paramDict["payOrIncome"] = String(AccountType.income)

        var sumIncomeStr:String? = self.sumResultByClass(object_getClass(AccountModel()), sumStr: "amount", params: paramDict)
        
        if sumIncomeStr == nil {
            sumIncomeStr = "0"
        }
        let avgIncomeStr  = String(Int(sumIncomeStr!)! / 12)
        let leftStr = String(Int(sumIncomeStr!)! - Int(sumPayStr!)!)
        
        return (avgPayStr,avgIncomeStr,leftStr);
    }
    
    internal func getLineChartData(yearStr:String?,payOrIncome:String?) -> Array<Int>? {
        var paramDict:Dictionary<String,String> = Dictionary()

        if yearStr != nil {
            paramDict["accountYearDate"] = yearStr
        }

        if payOrIncome != nil {
            paramDict["payOrIncome"] = payOrIncome
        }
        
        let resultArray:[AccountModel] = self.groupSumModelArrayByClass(object_getClass(AccountModel()), resultClass: object_getClass(AccountModel()), sumStr: "amount", params: paramDict, groupStr: "accountMonthDate") as! Array<AccountModel>
        
        var valueArray:[Int] = []
        for index in 1..<13 {
            valueArray.append(monthValueFromSource(index, sourceArray: resultArray))
        }
        
        return valueArray;
    }
    
    internal func getLineChartTableSource(yearStr:String?) -> Array<LineChartTableSourceStruct>? {
        var paramDict:Dictionary<String,String> = Dictionary()
        
        if yearStr != nil {
            paramDict["accountYearDate"] = yearStr
        }
        paramDict["payOrIncome"] = String(AccountType.pay)

        let resultPayArray:[AccountModel] = self.groupSumModelArrayByClass(object_getClass(AccountModel()), resultClass: object_getClass(AccountModel()), sumStr: "amount", params: paramDict, groupStr: "accountMonthDate") as! Array<AccountModel>
        paramDict["payOrIncome"] = String(AccountType.income)
        
        let resultIncomeArray:[AccountModel] = self.groupSumModelArrayByClass(object_getClass(AccountModel()), resultClass: object_getClass(AccountModel()), sumStr: "amount", params: paramDict, groupStr: "accountMonthDate") as! Array<AccountModel>
        
        var sourceStructArray:[LineChartTableSourceStruct] = []
        var payMonthValueArray:[Int] = []
        var incomeMonthValueArray:[Int] = []
        for index in 1..<13 {
            let payValue = monthValueFromSource(index, sourceArray: resultPayArray)
            let incomeValue = monthValueFromSource(index, sourceArray: resultIncomeArray)
            payMonthValueArray.append(payValue)
            incomeMonthValueArray.append(incomeValue)
            let monthStr = String(index) + "月"
            let left = incomeValue - payValue
            var isNeg = false
            if left < 0 {
                isNeg = true
            }
            
            let sourceStruct = LineChartTableSourceStruct(monthCnStr: monthStr,monthIncome: incomeValue,monthPay: payValue,monthLeft: left,isNegative: isNeg)
            sourceStructArray.append(sourceStruct)
        }
        
        return sourceStructArray;
    }
    
    private func monthValueFromSource(month:Int,sourceArray:Array<AccountModel> ) -> Int {
        
        for valueModel in sourceArray {
            let currMonthStr = valueModel.accountMonthDate?.split("-")[1]
            let currMonth:Int = Int(currMonthStr!)!
            if month == currMonth {
                return Int(valueModel.sum_result)!
            }
        }
        
        return 0
    }
    
}
