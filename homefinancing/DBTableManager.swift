//
//  DBTableManager.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

class DBTableManager : GCBaseStorage {
    static let sharedInstance = DBTableManager()
    fileprivate override init() {}
    
    func createAllTables() {
        if !UserDefaults.hasInitDBTables() {
            var success:Bool = true
            success = self.createTable(withModelClass: object_getClass(AccountModel()))
            success = self.createTable(withModelClass: object_getClass(MemberModel()))
            if success {
                UserDefaults.saveHasInitDBTables(true)
            }
        }
    }
}
