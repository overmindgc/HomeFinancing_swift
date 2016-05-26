//
//  MemberStorageService.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/14/16.
//  Copyright © 2016 wph. All rights reserved.
//

class MemberStorageService: GCBaseStorage {
    static let sharedInstance = MemberStorageService()
    private override init() {}
    
    let defaultMemberArray = [["id":"1002","name":"爸爸"],
                              ["id":"1003","name":"妈妈"],
                              ["id":"1004","name":"孩子"]]
    
    
    internal func initMemberData() {
        if NSUserDefaults.hasInitMemberData() == false {
            var modelArray = [MemberModel]()
            for memberDict:Dictionary in defaultMemberArray {
                let memberModel:MemberModel = MemberModel(dict: memberDict)
                modelArray.append(memberModel)
            }
            self.insertToTableWithArray(modelArray)
            NSUserDefaults.saveHasInitMemberData(true)
        }
    }
    
    internal func getAllMemberList() -> Array<MemberModel> {
        initMemberData()
        let resultArray = self.selectModelArrayByClass(object_getClass(MemberModel()), params: nil, orderBy: "id", isDesc: false)
        let modelArray = resultArray as! Array<MemberModel>
        for model in modelArray {
            model.totalPay = getMemberSumAllPayAmountWithId(model.id!)
        }
        return modelArray
    }
    
    internal func saveMemberModel(model:MemberModel) {
        self.insertToTableWithModel(model)
    }
    
    internal func editMemberNameWithId(memberId:String,memberName:String) {
        self.updateFromTableByClass(object_getClass(MemberModel()), set: ["name":memberName], params: ["id":memberId])
    }
    
    internal func deleteMemberWithId(memberId:String) {
        self.deleteFromTableByClass(object_getClass(MemberModel()), params: ["id":memberId])
    }
    
    internal func getMemberSumAllPayAmountWithId(memberId:String) -> String? {
       return self.sumResultByClass(object_getClass(AccountModel()), sumStr: "amount", params: ["memberId":memberId,"payOrIncome":"pay"])
    }
}
