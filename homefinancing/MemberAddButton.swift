//
//  MemberAddButton.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/14/16.
//  Copyright © 2016 wph. All rights reserved.
//

class MemberAddButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    func initViews() {
        self.backgroundColor = appPayColor
        self.setTitle("+增加成员", forState: UIControlState.Normal)
        self.layer.cornerRadius = 5
    }
}
