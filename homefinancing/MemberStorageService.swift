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
            var modelArray:Array<MemberModel> = []
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
        let modelArray = self.selectModelArrayByClass(object_getClass(MemberModel()), params: nil, orderBy: "id", isDesc: false)
        return modelArray as! Array<MemberModel>
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
}
