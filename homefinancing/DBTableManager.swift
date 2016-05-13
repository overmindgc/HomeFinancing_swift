//
//  DBTableManager.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

class DBTableManager : GCBaseStorage {
    static let sharedInstance = DBTableManager()
    private override init() {}
    
    func createAllTables() {
        if !NSUserDefaults.hasInitDBTables() {
            let success:Bool = self.createTableWithModelClass(object_getClass(AccountModel()))
            if success {
                NSUserDefaults.saveHasInitDBTables(true)
            }
        }
    }
}
