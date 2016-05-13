//
//  HFTableViewCell.swift
//  homefinancing
//
//  Created by 辰 宫 on 4/6/16.
//  Copyright © 2016 wph. All rights reserved.
//

class HFTableViewCell: UITableViewCell {

    // Class 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initBaseViews()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.initBaseViews()
    }
    
    func initBaseViews() {
        self.backgroundColor = UIColor.whiteColor()
    }
}
