//
//  NSUserDefaultsExtension.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

extension NSUserDefaults {
    public class func hasInitDBTables() -> Bool {
        let flag:Bool = NSUserDefaults.standardUserDefaults().boolForKey("talbes_has_init")
        return flag
    }
    
    public class func saveHasInitDBTables(flag:Bool) {
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(flag, forKey: "talbes_has_init")
        userDefault.synchronize()
    }
    
    public class func saveMonthBudget(budget:Int) {
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefault.setInteger(budget, forKey: "month_budget_num")
        userDefault.synchronize()
    }
    
    public class func currentMonthBudget() -> Int {
        let budget:Int = NSUserDefaults.standardUserDefaults().integerForKey("month_budget_num")
        return budget
    }
    
    public class func hasInitMemberData() -> Bool {
        let flag:Bool = NSUserDefaults.standardUserDefaults().boolForKey("member_data_has_init")
        return flag
    }
    
    public class func saveHasInitMemberData(flag:Bool) {
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(flag, forKey: "member_data_has_init")
        userDefault.synchronize()
    }
}