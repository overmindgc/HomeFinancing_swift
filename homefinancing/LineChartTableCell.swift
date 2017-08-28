//
//  LineChartTableCell.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/26/16.
//  Copyright © 2016 wph. All rights reserved.
//

let lineChartTableCellHeight:CGFloat = 35
let lineChartTableCellMonthLabelWidth:CGFloat = 70
let lineChartTableCellValueLabelWidth:CGFloat = (SCREEN_WIDTH - lineChartTableCellMonthLabelWidth) / 3

class LineChartTableCell: HFTableViewCell {
    var monthLabel: UILabel!
    var incomeLabel: UILabel!
    var payLabel: UILabel!
    var leftLabel: UILabel!
    
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
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        monthLabel = UILabel(frame: CGRect(x: 0,y: 0,width: lineChartTableCellMonthLabelWidth,height: lineChartTableCellHeight))
        monthLabel.textAlignment = NSTextAlignment.center
        monthLabel.textColor = appGrayTextColor
        monthLabel.font = UIFont.boldSystemFont(ofSize: 13)
        self.addSubview(monthLabel)
        
        incomeLabel = UILabel(frame: CGRect(x: lineChartTableCellMonthLabelWidth,y: 0,width: lineChartTableCellValueLabelWidth,height: lineChartTableCellHeight))
        incomeLabel.textAlignment = NSTextAlignment.center
        incomeLabel.textColor = appGrayTextColor
        incomeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        incomeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(incomeLabel)
        
        payLabel = UILabel(frame: CGRect(x: lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth,y: 0,width: lineChartTableCellValueLabelWidth,height: lineChartTableCellHeight))
        payLabel.textAlignment = NSTextAlignment.center
        payLabel.textColor = appGrayTextColor
        payLabel.font = UIFont.boldSystemFont(ofSize: 13)
        payLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(payLabel)

        leftLabel = UILabel(frame: CGRect(x: lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth * 2,y: 0,width: lineChartTableCellValueLabelWidth,height: lineChartTableCellHeight))
        leftLabel.textAlignment = NSTextAlignment.center
        leftLabel.textColor = appGrayTextColor
        leftLabel.font = UIFont.boldSystemFont(ofSize: 13)
        leftLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(leftLabel)
        
    }
}
