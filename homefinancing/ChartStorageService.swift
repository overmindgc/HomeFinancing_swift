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
    
    
}
