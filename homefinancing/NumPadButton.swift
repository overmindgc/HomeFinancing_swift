//
//  NumPadButton.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/8/16.
//  Copyright © 2016 wph. All rights reserved.
//

class NumPadButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    func initViews() {
        self.backgroundColor = appDarkBackgroundColor
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(25)
        self.setBackgroundImage(UIImage(named: "dark_selected_bg"), forState: UIControlState.Highlighted)
    }
}
