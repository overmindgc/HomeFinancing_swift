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
    
    private var lineChartView: PNLineChart?
    private var legendView: UIView = UIView()
    private var currOffset:Int = 0
    
    private var tableView:UITableView?
    private var tableSource:Array<LineChartTableSourceStruct>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartHeight:CGFloat = (SCREEN_HEIGHT - sepLineView.frame.origin.y - 44) / 2
        
        lineChartView = PNLineChart(frame:CGRectMake(0,sepLineView.frame.origin.y - 50,SCREEN_WIDTH,chartHeight))
        lineChartView?.yLabelFormat = "%1.f"
        lineChartView?.axisColor = UIColor.grayColor()
        lineChartView?.xLabelColor = UIColor.grayColor()
        lineChartView?.yLabelColor = UIColor.grayColor()
        lineChartView?.backgroundColor = UIColor.whiteColor()
        lineChartView?.setXLabels(["1月","","3月","","5月","","7月","","9月","","11月",""], withWidth: 25)
        lineChartView?.showCoordinateAxis = true
//        lineChartView?.chartMarginLeft = 0
        lineChartView?.chartMarginRight = 5
        
        lineChartView?.legendStyle = PNLegendItemStyle.Serial
        lineChartView?.legendFont = UIFont.boldSystemFontOfSize(12)
        lineChartView?.legendFontColor = UIColor.grayColor()
        self.view.addSubview(lineChartView!)
        
        let tableY = sepLineView.frame.origin.y + chartHeight - 30
        tableView = UITableView(frame: CGRectMake(0,tableY,SCREEN_WIDTH,chartHeight + 5))
        tableView?.delegate = self
        tableView?.dataSource = self
        
        self.view.addSubview(tableView!)
        
        refreshChartData(NSDate.yearStringWithStandardFormat(NSDate()))
    }
    
    func refreshChartData(yearStr:String) {
        let statisticResult = ChartStorageService.sharedInstance.getLineChartTopStatisticData(yearStr)
        tableSource = ChartStorageService.sharedInstance.getLineChartTableSource(yearStr)
        tableView?.reloadData()
        
        avgPayValueLabel.text = "￥" + statisticResult.payAvg
        avgIncomeValueLabel.text = "￥" + statisticResult.incomeAvg
        yearLeftLabel.text = "￥" + statisticResult.yearLeft
//        let payDataArray = [4000, 5000, 5500, 3500, 1000, 4500, 6000, 6600, 5000, 4500, 5000, 6500]
//        let incomeDataArray = [7000, 8000, 8000, 8500, 8000, 8500, 8000, 8600, 8000, 8500, 8000, 8500]
        
        let payDataArray = ChartStorageService.sharedInstance.getLineChartData(yearStr,payOrIncome:String(AccountType.pay))
        let incomeDataArray = ChartStorageService.sharedInstance.getLineChartData(yearStr,payOrIncome:String(AccountType.income))
        
        let payLineData = PNLineChartData()
        let incomeLineData = PNLineChartData()
        payLineData.dataTitle = "支出"
        payLineData.color = appPayColor
        payLineData.alpha = 0.6
        payLineData.inflexionPointStyle = PNLineChartPointStyle.Triangle
        payLineData.itemCount = UInt(payDataArray!.count)
        payLineData.getData = { (index) in
            let yValue:CGFloat = CGFloat(payDataArray![Int(index)])
            return PNLineChartDataItem(y: yValue,andRawY: yValue)
        }
        
        incomeLineData.dataTitle = "收入"
        incomeLineData.color = appIncomeColor
        incomeLineData.alpha = 0.6
        incomeLineData.inflexionPointStyle = PNLineChartPointStyle.Triangle
        incomeLineData.itemCount = UInt(incomeDataArray!.count)
        incomeLineData.getData = { (index) in
            let yValue:CGFloat = CGFloat(incomeDataArray![Int(index)])
            return PNLineChartDataItem(y: yValue,andRawY: yValue)
        }
        
        lineChartView?.chartData = [payLineData,incomeLineData]
        lineChartView?.strokeChart()
        
        legendView.removeFromSuperview()
        let legendY:CGFloat = lineChartView!.frame.height + 70
        legendView = (lineChartView?.getLegendWithMaxWidth(420))!
        legendView.frame = CGRectMake(30, legendY, legendView.frame.size.width, legendView.frame.size.height)
        self.view.addSubview(legendView)
    }

    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableSource?.count)!
    }
    //绘制cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let itemCell = LineChartTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableCellIndentifier)
        itemCell.accessoryType = UITableViewCellAccessoryType.None
        let sourceStruct:LineChartTableSourceStruct = tableSource![row]
        itemCell.monthLabel.text = sourceStruct.monthCnStr
        itemCell.incomeLabel.text = "￥" + String(sourceStruct.monthIncome!)
        itemCell.payLabel.text = "￥" + String(sourceStruct.monthPay!)
        itemCell.leftLabel.text = "￥" + String(sourceStruct.monthLeft!)
        return itemCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        currCell.selected = false
    }
    
    //每个cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return lineChartTableCellHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView(frame:CGRectMake(0,0,tableHeaderHeight,SCREEN_WIDTH))
        bgView.backgroundColor = UIColor.whiteColor()
        
        let monthLabel = UILabel(frame: CGRectMake(0,0,lineChartTableCellMonthLabelWidth,tableHeaderHeight))
        monthLabel.textAlignment = NSTextAlignment.Center
        monthLabel.textColor = appPayColor
        monthLabel.font = UIFont.boldSystemFontOfSize(13)
        monthLabel.text = "月份"
        bgView.addSubview(monthLabel)
        
        let incomeLabel = UILabel(frame: CGRectMake(lineChartTableCellMonthLabelWidth,0,lineChartTableCellValueLabelWidth,tableHeaderHeight))
        incomeLabel.textAlignment = NSTextAlignment.Center
        incomeLabel.textColor = appPayColor
        incomeLabel.font = UIFont.boldSystemFontOfSize(13)
        incomeLabel.adjustsFontSizeToFitWidth = true
        incomeLabel.text = "月收入"
        bgView.addSubview(incomeLabel)
        
        let payLabel = UILabel(frame: CGRectMake(lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth,0,lineChartTableCellValueLabelWidth,tableHeaderHeight))
        payLabel.textAlignment = NSTextAlignment.Center
        payLabel.textColor = appPayColor
        payLabel.font = UIFont.boldSystemFontOfSize(13)
        payLabel.adjustsFontSizeToFitWidth = true
        payLabel.text = "月支出"
        bgView.addSubview(payLabel)
        
        let leftLabel = UILabel(frame: CGRectMake(lineChartTableCellMonthLabelWidth + lineChartTableCellValueLabelWidth * 2,0,lineChartTableCellValueLabelWidth,tableHeaderHeight))
        leftLabel.textAlignment = NSTextAlignment.Center
        leftLabel.textColor = appPayColor
        leftLabel.font = UIFont.boldSystemFontOfSize(13)
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.text = "月结余"
        bgView.addSubview(leftLabel)
        
        let lineTopView = UIView(frame:CGRectMake(0,0,SCREEN_WIDTH,0.5))
        lineTopView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        bgView.addSubview(lineTopView)
        let lineBottomView = UIView(frame:CGRectMake(0,tableHeaderHeight - 0.5,SCREEN_WIDTH,0.5))
        lineBottomView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        bgView.addSubview(lineBottomView)
        
        return bgView
    }
    
    //MARK: - Actions
    
    @IBAction func lastClickAction(sender: AnyObject) {
        currOffset -= 1
        let currYearStr = NSDate.yearStringWithStandardFormat(NSDate.dateByOffsetDay(NSDate(), offsetDay: 365 * currOffset))
        refreshChartData(currYearStr)
        topTitleLabel.text = currYearStr + "年收支趋势"
    }
    
    @IBAction func nextClickAction(sender: AnyObject) {
        currOffset += 1
        let currYearStr = NSDate.yearStringWithStandardFormat(NSDate.dateByOffsetDay(NSDate(), offsetDay: 365 * currOffset))
        refreshChartData(currYearStr)
        topTitleLabel.text = currYearStr + "年收支趋势"
    }
}
