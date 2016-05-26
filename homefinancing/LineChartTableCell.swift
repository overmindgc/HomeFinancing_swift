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
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        monthLabel = UILabel(frame: CGRectMake(0,0,lineChartTableCellMonthLabelWidth,lineChartTableCellHeight))
        monthLabel.textAlignment = NSTextAlignment.Center
        monthLabel.textColor = appGrayTextColor
        monthLabel.font = UIFont.boldSystemFontOfSize(13)
        self.addSubview(monthLabel)
        
        incomeLabel = UILabel(frame: CGRectMake(lineChartTableCellMonthLabelWidth,0,lineChartTableCellValueLabelWidth,lineChartTableCellHeight))
        incomeLabel.textAlignment = NSTextAlignment.Center
        incomeLabel.textColor = appGrayTextColor
        incomeLabel.font = UIFont.boldSystemFontOfSize(13)
        incomeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(incomeLabel)
        
        payLabel = UILabel(frame: CGRectMake(lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth,0,lineChartTableCellValueLabelWidth,lineChartTableCellHeight))
        payLabel.textAlignment = NSTextAlignment.Center
        payLabel.textColor = appGrayTextColor
        payLabel.font = UIFont.boldSystemFontOfSize(13)
        payLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(payLabel)

        leftLabel = UILabel(frame: CGRectMake(lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth * 2,0,lineChartTableCellValueLabelWidth,lineChartTableCellHeight))
        leftLabel.textAlignment = NSTextAlignment.Center
        leftLabel.textColor = appGrayTextColor
        leftLabel.font = UIFont.boldSystemFontOfSize(13)
        leftLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(leftLabel)
        
    }
}
