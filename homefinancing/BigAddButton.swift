//
//  BigAddButton.swift
//  homefinancing
//
//  Created by 辰 宫 on 3/18/16.
//  Copyright © 2016 wph. All rights reserved.
//

class BigAddButton: UIButton {
    
    let buttonWidth:CGFloat = 94
    
    var plusLabel:UILabel!
    var addLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        plusLabel = UILabel(frame:CGRectMake(0,0,buttonWidth,35))
        plusLabel.textAlignment = NSTextAlignment.Center
        plusLabel.font = UIFont.boldSystemFontOfSize(30)
        plusLabel.textColor = UIColor.whiteColor()
        plusLabel.text = "+"
        self.addSubview(plusLabel)
        
        addLabel = UILabel(frame:CGRectMake(0,20,buttonWidth,40))
        addLabel.textAlignment = NSTextAlignment.Center
        addLabel.font = UIFont.systemFontOfSize(16)
        addLabel.textColor = UIColor.whiteColor()
        addLabel.text = "记一笔"
        self.addSubview(addLabel)
    }
    
    
}
