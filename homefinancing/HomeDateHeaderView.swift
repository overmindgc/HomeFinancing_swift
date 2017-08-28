//
//  HomeDateCell.swift
//  homefinancing
//
//  Created by 辰 宫 on 4/6/16.
//  Copyright © 2016 wph. All rights reserved.
//

class HomeDateHeaderView: UIView {

    static let dateCellHeight:CGFloat = 55
    
    var payMoneyLabel: UILabel!
    var dateLabel: UILabel!
    var incomeMoneyLabel: UILabel!
    
    fileprivate var payLabel: UILabel!
    fileprivate var centerDateView: UIView!
    fileprivate var incomeLabel: UILabel!
    fileprivate var verLineView:UIView!
    
    let tableOffset:CGFloat = 0
    let centerDateViewWidth:CGFloat = 40
    let payIncomeLabelWidth:CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        self.backgroundColor = UIColor.white
        verLineView = UIView(frame: CGRect(x: SCREEN_WIDTH/2 - 0.5 + tableOffset,y: 0,width: 1,height: HomeDateHeaderView.dateCellHeight))
        verLineView.backgroundColor = UIColor.lightGray
        self.addSubview(verLineView)
        
        payMoneyLabel = UILabel(frame: CGRect(x: tableOffset,y: 0,width: SCREEN_WIDTH/2 - payIncomeLabelWidth - centerDateViewWidth/2,height: HomeDateHeaderView.dateCellHeight))
        payMoneyLabel.textAlignment = NSTextAlignment.right
        payMoneyLabel.textColor = UIColor.gray
        payMoneyLabel.font = UIFont.boldSystemFont(ofSize: 14)
        payMoneyLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(payMoneyLabel)
        
        payLabel = UILabel(frame: CGRect(x: payMoneyLabel.frame.size.width,y: 0,width: payIncomeLabelWidth,height: HomeDateHeaderView.dateCellHeight))
        payLabel.textAlignment = NSTextAlignment.center
        payLabel.textColor = appPayColor
        payLabel.font = UIFont.boldSystemFont(ofSize: 14)
        payLabel.text = "支出"
        self.addSubview(payLabel)
        
        centerDateView = UIView(frame: CGRect(x: SCREEN_WIDTH/2 - centerDateViewWidth/2 + tableOffset,y: HomeDateHeaderView.dateCellHeight/2 - centerDateViewWidth/2,width: centerDateViewWidth,height: centerDateViewWidth))
        centerDateView.backgroundColor = UIColor.lightGray
        centerDateView.layer.cornerRadius = centerDateViewWidth / 2
        self.addSubview(centerDateView)
        
        dateLabel = UILabel(frame: CGRect(x: 0,y: 0,width: centerDateViewWidth,height: centerDateViewWidth))
        dateLabel.textAlignment = NSTextAlignment.center
        dateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        dateLabel.textColor = UIColor.white
        centerDateView.addSubview(dateLabel)
        
        incomeLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH/2 + centerDateViewWidth/2 + tableOffset,y: 0,width: payIncomeLabelWidth,height: HomeDateHeaderView.dateCellHeight))
        incomeLabel.textAlignment = NSTextAlignment.center
        incomeLabel.textColor = appIncomeColor
        incomeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        incomeLabel.text = "收入"
        self.addSubview(incomeLabel)
        
        incomeMoneyLabel = UILabel(frame: CGRect(x: incomeLabel.frame.origin.x + incomeLabel.frame.size.width - tableOffset,y: 0,width: SCREEN_WIDTH - incomeLabel.frame.origin.x - incomeLabel.frame.size.width,height: HomeDateHeaderView.dateCellHeight))
        incomeMoneyLabel.textAlignment = NSTextAlignment.left
        incomeMoneyLabel.textColor = UIColor.gray
        incomeMoneyLabel.font = UIFont.boldSystemFont(ofSize: 14)
        incomeMoneyLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(incomeMoneyLabel)
        
    }
    
}
