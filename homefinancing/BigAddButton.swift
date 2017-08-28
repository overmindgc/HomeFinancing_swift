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
        plusLabel = UILabel(frame:CGRect(x: 0,y: 0,width: buttonWidth,height: 35))
        plusLabel.textAlignment = NSTextAlignment.center
        plusLabel.font = UIFont.boldSystemFont(ofSize: 30)
        plusLabel.textColor = UIColor.white
        plusLabel.text = "+"
        self.addSubview(plusLabel)
        
        addLabel = UILabel(frame:CGRect(x: 0,y: 20,width: buttonWidth,height: 40))
        addLabel.textAlignment = NSTextAlignment.center
        addLabel.font = UIFont.systemFont(ofSize: 16)
        addLabel.textColor = UIColor.white
        addLabel.text = "记一笔"
        self.addSubview(addLabel)
    }
    
    
}
