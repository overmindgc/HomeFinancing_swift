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
    
    private var centerColorView: UIView!
    private var verLineView:UIView!
    
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
        self.selectionStyle = UITableViewCellSelectionStyle.Gray
        
        verLineView = UIView(frame: CGRectMake(SCREEN_WIDTH/2 - 0.5 + tableOffset,0,1,colorCellHeight))
        verLineView.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(verLineView)
        
        payLabel = UILabel(frame: CGRectMake(tableOffset,0,SCREEN_WIDTH/2 - paddingCenter - centerColorViewWidth/2,colorCellHeight))
        payLabel.textAlignment = NSTextAlignment.Right
        payLabel.textColor = UIColor.grayColor()
        payLabel.font = UIFont.boldSystemFontOfSize(13)
        payLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(payLabel)
        
        centerColorView = UIView(frame: CGRectMake(SCREEN_WIDTH/2 - centerColorViewWidth/2 + tableOffset,colorCellHeight/2 - centerColorViewWidth/2,centerColorViewWidth,centerColorViewWidth))
        centerColorView.backgroundColor = appPayColor
        centerColorView.layer.cornerRadius = centerColorViewWidth / 2
        self.addSubview(centerColorView)
        
        incomeLabel = UILabel(frame: CGRectMake(SCREEN_WIDTH/2 + centerColorViewWidth/2 + paddingCenter + tableOffset,0,SCREEN_WIDTH - SCREEN_WIDTH/2 - centerColorViewWidth/2,colorCellHeight))
        incomeLabel.textAlignment = NSTextAlignment.Left
        incomeLabel.textColor = UIColor.grayColor()
        incomeLabel.font = UIFont.boldSystemFontOfSize(13)
        incomeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(incomeLabel)
        
    }
    
    var currentType:AccountType? {
        didSet {
            if currentType == AccountType.pay {
                centerColorView.backgroundColor = appPayColor
                payLabel.hidden = false
                incomeLabel.hidden = true
            } else {
                centerColorView.backgroundColor = appIncomeColor
                payLabel.hidden = true
                incomeLabel.hidden = false
            }
        }
    }
    
    var hideButtomVLine:Bool? {
        didSet {
            if hideButtomVLine == true {
                verLineView.frame = CGRectMake(SCREEN_WIDTH/2 - 0.5 + tableOffset,0,1,colorCellHeight / 2)
            } else {
                verLineView.frame = CGRectMake(SCREEN_WIDTH/2 - 0.5 + tableOffset,0,1,colorCellHeight)
            }
        }
    }
    
}
