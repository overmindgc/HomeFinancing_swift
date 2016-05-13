//
//  StringExtension.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/11/16.
//  Copyright © 2016 wph. All rights reserved.
//

extension String{
    
    func split(s:String)->[String]{
        if s.isEmpty{
            var spiltedString=[String]()
            for y in self.characters{
                spiltedString.append(String(y))
            }
            return spiltedString
        }
        return self.componentsSeparatedByString(s)
    }
}
