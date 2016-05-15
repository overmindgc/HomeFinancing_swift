//
//  AccountModel.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

class AccountModel: GCDBModel {
    var id:String?
    var bookId:String?
    var accountDate:String?//yyyy-MM-dd
    var accountMonthDate:String?//yyyy-MM
    var accountYearDate:String?//yyyy
    var createDate:String?
    var updateDate:String?
    var typeId:String?
    var typeName:String?
    var amount:String?
    var memberId:String?
    var memberName:String?
    var remark:String?
    var payOrIncome:String?
}
