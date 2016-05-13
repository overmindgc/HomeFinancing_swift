//
//  AccountTypeSquareButton.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

class AccountTypeSquareButton: UIButton {
    
    static internal let buttonPadding:CGFloat = 17
    static internal let buttonWidth:CGFloat = (SCREEN_WIDTH / 4 * 3 - buttonPadding * 4) / 3
    static internal let buttonHeight:CGFloat = 30
    
    var buttonIndex:Int?
    
    var accountType:AccountType = AccountType.pay
    
    var buttonId:String?
    var buttonTitle:String?
    
    lazy var selectImageView: UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }
    
    init(frame: CGRect,type: AccountType,title: String) {
        super.init(frame: frame)
        accountType = type
        buttonTitle = title
        self.initViews()
    }
    
    func initViews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.cornerRadius = 3
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.setTitle(buttonTitle, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        self.addTarget(self, action: #selector(AccountTypeSquareButton.clickAction), forControlEvents: UIControlEvents.TouchUpInside)
        let imgWidth:CGFloat = 16
        let imgHeight:CGFloat = 15
        selectImageView.frame = CGRectMake(self.frame.size.width - 13, self.frame.size.height - 11, imgWidth, imgHeight)
        self.addSubview(selectImageView)
    }
    
    var selectedSquare:Bool = false {
        didSet {
            if selectedSquare == true {
                if accountType == AccountType.pay {
                    self.layer.borderColor = appPayColor.CGColor
                    self.setTitleColor(appPayColor, forState: UIControlState.Normal)
                    selectImageView.hidden = false
                    selectImageView.image = UIImage(named: "star_blue")
                } else {
                    self.layer.borderColor = appIncomeColor.CGColor
                    self.setTitleColor(appIncomeColor, forState: UIControlState.Normal)
                    selectImageView.hidden = false
                    selectImageView.image = UIImage(named: "star_yellow")
                }
            } else {
                self.layer.borderColor = UIColor.lightGrayColor().CGColor
                self.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
                selectImageView.hidden = true
            }
        }
    }
    
//    func clickAction() {
//        selectedSquare = !selectedSquare
//    }
    
}
