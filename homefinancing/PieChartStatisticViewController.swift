//
//  PieChartStatisticViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/2/16.
//  Copyright © 2016 wph. All rights reserved.
//

class PieChartStatisticViewController: UIViewController,PNChartDelegate {
    
    internal var currentMonthStr: String?
    
    private var currentYearStr: String?
    private var currentMemberId: String?
    
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var monthYearSegmented: UISegmentedControl!
    
    @IBOutlet weak var pieChartView :PNPieChart!
    
    @IBOutlet weak var itemTipView: UIView!
    
    @IBOutlet weak var leftAmountLabel: UILabel!
    
    @IBOutlet weak var payIncomeSegmemted: UISegmentedControl!
    
    @IBOutlet weak var memberButton: UIButton!
    
    @IBOutlet weak var totalPayIncomeLabel: UILabel!
    
    @IBOutlet weak var totalPayIncomeAmountLabel: UILabel!
    
    @IBOutlet weak var tipBgView: UIView!
    
    @IBOutlet weak var tipTitleLabel: UILabel!
    
    @IBOutlet weak var tipValueLabel: UILabel!
    
    @IBOutlet weak var blankTipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.delegate = self
        pieChartView.shouldHighlightSectorOnTouch = true
        pieChartView.strokeChart()
        
        pieChartView.legendStyle = PNLegendItemStyle.Serial
        pieChartView.legendFont = UIFont.boldSystemFontOfSize(12)
        pieChartView.legendFontColor = UIColor.grayColor()
        
        //init values
        let threeMonthTuple = threeMonthCnStrBycurrMonthStr(currentMonthStr!)
        self.navigationItem.title = threeMonthTuple.current + "分布统计"
        lastButton.setTitle(threeMonthTuple.last, forState: UIControlState.Normal)
        nextButton.setTitle(threeMonthTuple.next, forState: UIControlState.Normal)
        itemTipView.layer.borderColor = appPayColor.CGColor
        
        
        refreshChartData()
    }
    
    func refreshChartData() {
        var payOrIncome:String?
        if payIncomeSegmemted.selectedSegmentIndex == 0 {
            payOrIncome = String(AccountType.pay)
        } else {
            payOrIncome = String(AccountType.income)
        }
        let sourceArray = ChartStorageService.sharedInstance.getPieChartData(currentMonthStr, yearStr: currentYearStr, memberId: currentMemberId, payOrIncome: payOrIncome).array
        
        var items:[PNPieChartDataItem] = []
        for pieGroupModel in sourceArray! {
            let sum:Float = Float(pieGroupModel.sum_result)!
            let item = PNPieChartDataItem()
            item.color = randomColor(hue: .Random, luminosity: .Bright)
            item.value = CGFloat(sum)
            item.textDescription = pieGroupModel.typeName
            items.append(item)
        }
        if items.count > 0 {
            pieChartView.updateChartData(items)
            
            let legend = pieChartView.getLegendWithMaxWidth(SCREEN_WIDTH * 0.9)
            legend.frame = CGRectMake(SCREEN_WIDTH/2 - legend.frame.size.width/2, 450, legend.frame.size.width, legend.frame.size.height)
            self.view.addSubview(legend)
        }
        
    }
    
    //MARK: - functions
    func threeMonthCnStrBycurrMonthStr(monthStr:String) -> (last:String,current:String,next:String) {
        let currMonthDate = NSDate.dateWithStandardFormatString(monthStr + "-10");
        let lastMonthDate = NSDate.dateByOffsetMonth(currMonthDate, offsetDay: -1)
        let nextMonthDate = NSDate.dateByOffsetMonth(currMonthDate, offsetDay: 1)
        
        return (NSDate.monthCnStringWithStandardFormat(lastMonthDate),NSDate.monthCnStringWithStandardFormat(currMonthDate),NSDate.monthCnStringWithStandardFormat(nextMonthDate))
    }
    

    // MARK: - PNChartDelegate
    func userClickedOnPieIndexItem(pieIndex: Int) {
        
    }
    
    //MARK: - Actions
    
    @IBAction func lastClickAction(sender: AnyObject) {
    }
    
    @IBAction func nextClickAction(sender: AnyObject) {
    }
    
    @IBAction func yearMonthValueChanged(sender: AnyObject) {
    }
    
    @IBAction func payIncomeValueChange(sender: AnyObject) {
    }
    
    @IBAction func memberSelectAction(sender: AnyObject) {
    }
    
}
