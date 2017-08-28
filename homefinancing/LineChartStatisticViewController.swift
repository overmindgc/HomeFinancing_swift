//
//  LineChartStatisticViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/18/16.
//  Copyright © 2016 wph. All rights reserved.
//

class LineChartStatisticViewController: HFBaseViewController,UITableViewDelegate,UITableViewDataSource {

    let tableCellIndentifier = "tableCellIndentifier"
    let tableHeaderHeight:CGFloat = 30
    
    @IBOutlet weak var topTitleLabel: UILabel!
    
    @IBOutlet weak var avgPayValueLabel: UILabel!
    @IBOutlet weak var avgIncomeValueLabel: UILabel!
    @IBOutlet weak var yearLeftLabel: UILabel!
    
    @IBOutlet weak var sepLineView: UIView!
    
    fileprivate var lineChartView: PNLineChart?
    fileprivate var legendView: UIView = UIView()
    fileprivate var currOffset:Int = 0
    
    fileprivate var tableView:UITableView?
    fileprivate var tableSource:Array<LineChartTableSourceStruct>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartHeight:CGFloat = (SCREEN_HEIGHT - sepLineView.frame.origin.y - 44) / 2
        
        lineChartView = PNLineChart(frame:CGRect(x: 0,y: sepLineView.frame.origin.y - 50,width: SCREEN_WIDTH,height: chartHeight))
        lineChartView?.yLabelFormat = "%1.f"
        lineChartView?.axisColor = UIColor.gray
        lineChartView?.xLabelColor = UIColor.gray
        lineChartView?.yLabelColor = UIColor.gray
        lineChartView?.backgroundColor = UIColor.white
        lineChartView?.setXLabels(["1月","","3月","","5月","","7月","","9月","","11月",""], withWidth: 25)
        lineChartView?.isShowCoordinateAxis = true
//        lineChartView?.chartMarginLeft = 0
        lineChartView?.chartMarginRight = 5
        
        lineChartView?.legendStyle = PNLegendItemStyle.serial
        lineChartView?.legendFont = UIFont.boldSystemFont(ofSize: 12)
        lineChartView?.legendFontColor = UIColor.gray
        self.view.addSubview(lineChartView!)
        
        let tableY = sepLineView.frame.origin.y + chartHeight - 30
        tableView = UITableView(frame: CGRect(x: 0,y: tableY,width: SCREEN_WIDTH,height: chartHeight + 5))
        tableView?.delegate = self
        tableView?.dataSource = self
        
        self.view.addSubview(tableView!)
        
        refreshChartData(Date.yearStringWithStandardFormat(Date()))
    }
    
    func refreshChartData(_ yearStr:String) {
        let statisticResult = ChartStorageService.sharedInstance.getLineChartTopStatisticData(yearStr)
        tableSource = ChartStorageService.sharedInstance.getLineChartTableSource(yearStr)
        tableView?.reloadData()
        
        avgPayValueLabel.text = "￥" + statisticResult.payAvg
        avgIncomeValueLabel.text = "￥" + statisticResult.incomeAvg
        yearLeftLabel.text = "￥" + statisticResult.yearLeft
//        let payDataArray = [4000, 5000, 5500, 3500, 1000, 4500, 6000, 6600, 5000, 4500, 5000, 6500]
//        let incomeDataArray = [7000, 8000, 8000, 8500, 8000, 8500, 8000, 8600, 8000, 8500, 8000, 8500]
        
        let payDataArray = ChartStorageService.sharedInstance.getLineChartData(yearStr,payOrIncome:String(describing: AccountType.pay))
        let incomeDataArray = ChartStorageService.sharedInstance.getLineChartData(yearStr,payOrIncome:String(describing: AccountType.income))
        
        let payLineData = PNLineChartData()
        let incomeLineData = PNLineChartData()
        payLineData.dataTitle = "支出"
        payLineData.color = appPayColor
        payLineData.alpha = 0.6
        payLineData.inflexionPointStyle = PNLineChartPointStyle.triangle
        payLineData.itemCount = UInt(payDataArray!.count)
        payLineData.getData = { (index) in
            let yValue:CGFloat = CGFloat(payDataArray![Int(index)])
            return PNLineChartDataItem(y: yValue,andRawY: yValue)
        }
        
        incomeLineData.dataTitle = "收入"
        incomeLineData.color = appIncomeColor
        incomeLineData.alpha = 0.6
        incomeLineData.inflexionPointStyle = PNLineChartPointStyle.triangle
        incomeLineData.itemCount = UInt(incomeDataArray!.count)
        incomeLineData.getData = { (index) in
            let yValue:CGFloat = CGFloat(incomeDataArray![Int(index)])
            return PNLineChartDataItem(y: yValue,andRawY: yValue)
        }
        
        lineChartView?.chartData = [payLineData,incomeLineData]
        lineChartView?.stroke()
        
        legendView.removeFromSuperview()
        let legendY:CGFloat = lineChartView!.frame.height + 70
        legendView = (lineChartView?.getLegendWithMaxWidth(420))!
        legendView.frame = CGRect(x: 30, y: legendY, width: legendView.frame.size.width, height: legendView.frame.size.height)
        self.view.addSubview(legendView)
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableSource?.count)!
    }
    //绘制cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let itemCell = LineChartTableCell(style: UITableViewCellStyle.default, reuseIdentifier: tableCellIndentifier)
        itemCell.accessoryType = UITableViewCellAccessoryType.none
        let sourceStruct:LineChartTableSourceStruct = tableSource![row]
        itemCell.monthLabel.text = sourceStruct.monthCnStr
        itemCell.incomeLabel.text = "￥" + String(sourceStruct.monthIncome!)
        itemCell.payLabel.text = "￥" + String(sourceStruct.monthPay!)
        itemCell.leftLabel.text = "￥" + String(sourceStruct.monthLeft!)
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        currCell.isSelected = false
    }
    
    //每个cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return lineChartTableCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView(frame:CGRect(x: 0,y: 0,width: tableHeaderHeight,height: SCREEN_WIDTH))
        bgView.backgroundColor = UIColor.white
        
        let monthLabel = UILabel(frame: CGRect(x: 0,y: 0,width: lineChartTableCellMonthLabelWidth,height: tableHeaderHeight))
        monthLabel.textAlignment = NSTextAlignment.center
        monthLabel.textColor = appPayColor
        monthLabel.font = UIFont.boldSystemFont(ofSize: 13)
        monthLabel.text = "月份"
        bgView.addSubview(monthLabel)
        
        let incomeLabel = UILabel(frame: CGRect(x: lineChartTableCellMonthLabelWidth,y: 0,width: lineChartTableCellValueLabelWidth,height: tableHeaderHeight))
        incomeLabel.textAlignment = NSTextAlignment.center
        incomeLabel.textColor = appPayColor
        incomeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        incomeLabel.adjustsFontSizeToFitWidth = true
        incomeLabel.text = "月收入"
        bgView.addSubview(incomeLabel)
        
        let payLabel = UILabel(frame: CGRect(x: lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth,y: 0,width: lineChartTableCellValueLabelWidth,height: tableHeaderHeight))
        payLabel.textAlignment = NSTextAlignment.center
        payLabel.textColor = appPayColor
        payLabel.font = UIFont.boldSystemFont(ofSize: 13)
        payLabel.adjustsFontSizeToFitWidth = true
        payLabel.text = "月支出"
        bgView.addSubview(payLabel)
        
        let leftLabel = UILabel(frame: CGRect(x: lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth * 2,y: 0,width: lineChartTableCellValueLabelWidth,height: tableHeaderHeight))
        leftLabel.textAlignment = NSTextAlignment.center
        leftLabel.textColor = appPayColor
        leftLabel.font = UIFont.boldSystemFont(ofSize: 13)
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.text = "月结余"
        bgView.addSubview(leftLabel)
        
        let lineTopView = UIView(frame:CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: 0.5))
        lineTopView.backgroundColor = UIColor.groupTableViewBackground
        bgView.addSubview(lineTopView)
        let lineBottomView = UIView(frame:CGRect(x: 0,y: tableHeaderHeight - 0.5,width: SCREEN_WIDTH,height: 0.5))
        lineBottomView.backgroundColor = UIColor.groupTableViewBackground
        bgView.addSubview(lineBottomView)
        
        return bgView
    }
    
    //MARK: - Actions
    
    @IBAction func lastClickAction(_ sender: AnyObject) {
        currOffset -= 1
        let currYearStr = Date.yearStringWithStandardFormat(Date.dateByOffsetDay(Date(), offsetDay: 365 * currOffset))
        refreshChartData(currYearStr)
        topTitleLabel.text = currYearStr + "年收支趋势"
    }
    
    @IBAction func nextClickAction(_ sender: AnyObject) {
        currOffset += 1
        let currYearStr = Date.yearStringWithStandardFormat(Date.dateByOffsetDay(Date(), offsetDay: 365 * currOffset))
        refreshChartData(currYearStr)
        topTitleLabel.text = currYearStr + "年收支趋势"
    }
}
