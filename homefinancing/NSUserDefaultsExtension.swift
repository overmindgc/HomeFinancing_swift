//
//  NSUserDefaultsExtension.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

extension UserDefaults {
    public class func hasInitDBTables() -> Bool {
        let flag:Bool = UserDefaults.standard.bool(forKey: "talbes_has_init")
        return flag
    }
    
    public class func saveHasInitDBTables(_ flag:Bool) {
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(flag, forKey: "talbes_has_init")
        userDefault.synchronize()
    }
    
    public class func saveMonthBudget(_ budget:Int) {
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(budget, forKey: "month_budget_num")
        userDefault.synchronize()
    }
    
    public class func currentMonthBudget() -> Int {
        let budget:Int = UserDefaults.standard.integer(forKey: "month_budget_num")
        return budget
    }
    
    public class func hasInitMemberData() -> Bool {
        let flag:Bool = UserDefaults.standard.bool(forKey: "member_data_has_init")
        return flag
    }
    
    public class func saveHasInitMemberData(_ flag:Bool) {
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(flag, forKey: "member_data_has_init")
        userDefault.synchronize()
    }
}
