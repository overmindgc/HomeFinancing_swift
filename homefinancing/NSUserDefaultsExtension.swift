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
}