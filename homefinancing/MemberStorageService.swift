//
//  MemberStorageService.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/14/16.
//  Copyright © 2016 wph. All rights reserved.
//

class MemberStorageService: GCBaseStorage {
    static let sharedInstance = MemberStorageService()
    fileprivate override init() {}
    
    internal func initMemberData() {
        if UserDefaults.hasInitMemberData() == false {
            var modelArray = [MemberModel]()
            for memberDict:Dictionary in defaultMemberArray {
                let memberModel:MemberModel = MemberModel(dict: memberDict)
                modelArray.append(memberModel)
            }
            self.insertToTable(with: modelArray)
            UserDefaults.saveHasInitMemberData(true)
        }
    }
    
    internal func getAllMemberList() -> Array<MemberModel> {
        initMemberData()
        let resultArray = self.selectModelArray(by: object_getClass(MemberModel()), params: nil, orderBy: "id", isDesc: false)
        let modelArray = resultArray as! Array<MemberModel>
        for model in modelArray {
            model.totalPay = getMemberSumAllPayAmountWithId(model.id!)
        }
        return modelArray
    }
    
    internal func saveMemberModel(_ model:MemberModel) {
        self.insertToTable(withModel: model)
    }
    
    internal func editMemberNameWithId(_ memberId:String,memberName:String) {
        self.updateFromTable(by: object_getClass(MemberModel()), set: ["name":memberName], params: ["id":memberId])
    }
    
    internal func deleteMemberWithId(_ memberId:String) {
        self.deleteFromTable(by: object_getClass(MemberModel()), params: ["id":memberId])
    }
    
    internal func getMemberSumAllPayAmountWithId(_ memberId:String) -> String? {
       return self.sumResult(by: object_getClass(AccountModel()), sumStr: "amount", params: ["memberId":memberId,"payOrIncome":"pay"])
    }
}
