//
//  HomeItemCell.swift
//  homefinancing
//
//  Created by 辰 宫 on 4/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

let colorCellHeight:CGFloat = 40

class HomeItemCell: HFTableViewCell {
    
    var payLabel: UILabel!
    var incomeLabel: UILabel!
    
    fileprivate var centerColorView: UIView!
    fileprivate var verLineView:UIView!
    
    let tableOffset:CGFloat = 0
    let centerColorViewWidth:CGFloat = 20
    let paddingCenter:CGFloat = 15
    
    // Class 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initViews()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        self.selectionStyle = UITableViewCellSelectionStyle.gray
        
        verLineView = UIView(frame: CGRect(x: SCREEN_WIDTH/2 - 0.5 + tableOffset,y: 0,width: 1,height: colorCellHeight))
        verLineView.backgroundColor = UIColor.lightGray
        self.addSubview(verLineView)
        
        payLabel = UILabel(frame: CGRect(x: tableOffset,y: 0,width: SCREEN_WIDTH/2 - paddingCenter - centerColorViewWidth/2,height: colorCellHeight))
        payLabel.textAlignment = NSTextAlignment.right
        payLabel.textColor = UIColor.gray
        payLabel.font = UIFont.boldSystemFont(ofSize: 13)
        payLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(payLabel)
        
        centerColorView = UIView(frame: CGRect(x: SCREEN_WIDTH/2 - centerColorViewWidth/2 + tableOffset,y: colorCellHeight/2 - centerColorViewWidth/2,width: centerColorViewWidth,height: centerColorViewWidth))
        centerColorView.backgroundColor = appPayColor
        centerColorView.layer.cornerRadius = centerColorViewWidth / 2
        self.addSubview(centerColorView)
        
        incomeLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH/2 + centerColorViewWidth/2 + paddingCenter + tableOffset,y: 0,width: SCREEN_WIDTH - SCREEN_WIDTH/2 - centerColorViewWidth/2,height: colorCellHeight))
        incomeLabel.textAlignment = NSTextAlignment.left
        incomeLabel.textColor = UIColor.gray
        incomeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        incomeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(incomeLabel)
        
    }
    
    var currentType:AccountType? {
        didSet {
            if currentType == AccountType.pay {
                centerColorView.backgroundColor = appPayColor
                payLabel.isHidden = false
                incomeLabel.isHidden = true
            } else {
                centerColorView.backgroundColor = appIncomeColor
                payLabel.isHidden = true
                incomeLabel.isHidden = false
            }
        }
    }
    
    var hideButtomVLine:Bool? {
        didSet {
            if hideButtomVLine == true {
                verLineView.frame = CGRect(x: SCREEN_WIDTH/2 - 0.5 + tableOffset,y: 0,width: 1,height: colorCellHeight / 2)
            } else {
                verLineView.frame = CGRect(x: SCREEN_WIDTH/2 - 0.5 + tableOffset,y: 0,width: 1,height: colorCellHeight)
            }
        }
    }
    
}
