//
//  PieChartStatisticViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/2/16.
//  Copyright © 2016 wph. All rights reserved.
//

class PieChartStatisticViewController: UIViewController,PNChartDelegate {
    
    internal var currentMonthStr: String?
    internal var currentMonthOffset:Int?
    internal var currentYearOffset:Int?
    
    private var currentYearStr: String?
    private var currentMemberId: String?
    private var currentMemberName: String?
    
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
    
    private var legendView: UIView?
    
    private let nowDate = NSDate()
    
    private var sourceArray: [PieChartGroupModel]?
    private var totalAmount:CGFloat = 0
    
    private var memberModelArray:Array<MemberModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.delegate = self
        pieChartView.shouldHighlightSectorOnTouch = true
        pieChartView.strokeChart()
        
        pieChartView.legendStyle = PNLegendItemStyle.Serial
        pieChartView.legendFont = UIFont.boldSystemFontOfSize(12)
        pieChartView.legendFontColor = UIColor.grayColor()
        
        //init values
        
        itemTipView.layer.borderColor = appPayColor.CGColor
        
        
        refreshChartData()
    }
    
    func refreshChartData() {
        var paramMonth:String?
        var paramYear:String?
        if monthYearSegmented.selectedSegmentIndex == 0 {
            let threeMonthTuple = threeMonthCnStrBycurrMonthStr(currentMonthStr!)
            self.navigationItem.title = threeMonthTuple.current + "分布统计"
            lastButton.setTitle(threeMonthTuple.last, forState: UIControlState.Normal)
            nextButton.setTitle(threeMonthTuple.next, forState: UIControlState.Normal)
            paramMonth = currentMonthStr
            paramYear = nil
        } else {
            let threeYearTuple = threeYearStrBycurrMonthStr(currentMonthStr!)
            self.navigationItem.title = threeYearTuple.current + "分布统计"
            lastButton.setTitle(threeYearTuple.last, forState: UIControlState.Normal)
            nextButton.setTitle(threeYearTuple.next, forState: UIControlState.Normal)
            paramMonth = nil
            currentYearStr = currentMonthStr?.split("-")[0]
            paramYear = currentYearStr
        }
        
        var payOrIncome:String?
        if payIncomeSegmemted.selectedSegmentIndex == 0 {
            payOrIncome = String(AccountType.pay)
        } else {
            payOrIncome = String(AccountType.income)
        }
        sourceArray = ChartStorageService.sharedInstance.getPieChartData(paramMonth, yearStr: paramYear, memberId: currentMemberId, payOrIncome: payOrIncome).array
        if sourceArray == nil {
            sourceArray = []
        }
        
        var items:[PNPieChartDataItem] = []
        totalAmount = 0
        for pieGroupModel in sourceArray! {
            let sum:Float = Float(pieGroupModel.sum_result)!
            totalAmount += CGFloat(sum)
            let item = PNPieChartDataItem()
            item.color = randomColor(hue: .Random, luminosity: .Bright)
            item.value = CGFloat(sum)
            item.textDescription = pieGroupModel.typeName
            items.append(item)
        }
        
        totalPayIncomeAmountLabel.text = "￥" + String(Int(totalAmount))
        pieChartView.updateChartData(items)
        pieChartView.strokeChart()
    
        legendView?.removeFromSuperview()
        
        legendView = pieChartView.getLegendWithMaxWidth(SCREEN_WIDTH * 0.9)
        if legendView != nil {
            legendView!.frame = CGRectMake(SCREEN_WIDTH/2 - legendView!.frame.size.width/2, 450, legendView!.frame.size.width, legendView!.frame.size.height)
            self.view.addSubview(legendView!)
        }
        
    }
    
    //MARK: - functions
    func threeMonthCnStrBycurrMonthStr(monthStr:String) -> (last:String,current:String,next:String) {
        let currMonthDate = NSDate.dateWithStandardFormatString(monthStr + "-10");
        let lastMonthDate = NSDate.dateByOffsetMonth(currMonthDate, offsetDay: -1)
        let nextMonthDate = NSDate.dateByOffsetMonth(currMonthDate, offsetDay: 1)
        
        return (NSDate.monthCnStringWithStandardFormat(lastMonthDate),NSDate.monthCnStringWithStandardFormat(currMonthDate),NSDate.monthCnStringWithStandardFormat(nextMonthDate))
    }
    
    func threeYearStrBycurrMonthStr(monthStr:String) -> (last:String,current:String,next:String) {
        let currYearDate = NSDate.dateWithStandardFormatString(monthStr + "-10");
        let lastYearDate = NSDate.dateByOffsetYear(currYearDate, offsetDay: -1)
        let nextYearDate = NSDate.dateByOffsetYear(currYearDate, offsetDay: 1)
        
        return (NSDate.yearStringWithStandardFormat(lastYearDate),NSDate.yearStringWithStandardFormat(currYearDate),NSDate.yearStringWithStandardFormat(nextYearDate))
    }
    

    // MARK: - PNChartDelegate
    func userClickedOnPieIndexItem(pieIndex: Int) {
        let pieGroupModel = sourceArray![pieIndex]
        let result:Float = Float(pieGroupModel.sum_result)!
        let percent:String = String(Int(CGFloat(result) / totalAmount * 100)) + "%"
        tipTitleLabel.text = pieGroupModel.typeName! + " " + percent
        tipValueLabel.text = "￥" + String(pieGroupModel.sum_result)
    }
    
    //MARK: - Actions
    
    @IBAction func lastClickAction(sender: AnyObject) {
        var lastMonthDate:NSDate
        if monthYearSegmented.selectedSegmentIndex == 0 {
            currentMonthOffset! -= 1
            lastMonthDate = NSDate.dateByOffsetMonth(nowDate, offsetDay: currentMonthOffset!)
        } else {
            currentYearOffset! -= 1
            lastMonthDate = NSDate.dateByOffsetYear(nowDate, offsetDay: currentYearOffset!)
        }
        
        currentMonthStr = NSDate.yearMonthStringWithStandardFormat(lastMonthDate)
        if payIncomeSegmemted.selectedSegmentIndex == 0 {
            tipTitleLabel.text = "支出 --%"
        } else {
            tipTitleLabel.text = "收入 --%"
        }
        tipValueLabel.text = "￥---"
        refreshChartData()
        
    }
    
    @IBAction func nextClickAction(sender: AnyObject) {
        var nextMonthDate:NSDate
        if monthYearSegmented.selectedSegmentIndex == 0 {
            currentMonthOffset! += 1
            nextMonthDate = NSDate.dateByOffsetMonth(nowDate, offsetDay: currentMonthOffset!)
        } else {
            currentYearOffset! += 1
            nextMonthDate = NSDate.dateByOffsetYear(nowDate, offsetDay: currentYearOffset!)
        }
        
        currentMonthStr = NSDate.yearMonthStringWithStandardFormat(nextMonthDate)
        if payIncomeSegmemted.selectedSegmentIndex == 0 {
            tipTitleLabel.text = "支出 --%"
        } else {
            tipTitleLabel.text = "收入 --%"
        }
        tipValueLabel.text = "￥---"
        refreshChartData()
        
    }
    
    @IBAction func yearMonthValueChanged(sender: AnyObject) {
        currentYearOffset = 0
        refreshChartData()
    }
    
    @IBAction func payIncomeValueChange(sender: AnyObject) {
        if payIncomeSegmemted.selectedSegmentIndex == 0 {
            tipTitleLabel.textColor = appPayColor
            tipTitleLabel.text = "支出 --%"
            itemTipView.layer.borderColor = appPayColor.CGColor
            totalPayIncomeLabel.text = "总支出"
            totalPayIncomeLabel.textColor = appPayColor
        } else {
            tipTitleLabel.textColor = appIncomeColor
            tipTitleLabel.text = "收入 --%"
            itemTipView.layer.borderColor = appIncomeColor.CGColor
            totalPayIncomeLabel.text = "总收入"
            totalPayIncomeLabel.textColor = appIncomeColor
        }
        tipValueLabel.text = "￥---"
        refreshChartData()
    }
    
    @IBAction func memberSelectAction(sender: AnyObject) {
        memberModelArray = MemberStorageService.sharedInstance.getAllMemberList()
        let allMemberModel:MemberModel = MemberModel()
        allMemberModel.id = "1001"
        allMemberModel.name = "全家"
        memberModelArray?.insert(allMemberModel, atIndex: 0)
        
        let allModel:MemberModel = MemberModel()
        allModel.id = nil
        allModel.name = "全部"
        memberModelArray?.insert(allModel, atIndex: 0)
        
        //配置零：内容配置
        var menuArray:Array<KxMenuItem> = []
        for memberModel in memberModelArray! {
            let menuItem = KxMenuItem.init(memberModel.name,itemId: memberModel.id , image: UIImage(named: "person_small"), target: self, action: #selector(self.selectMemberClick(_:)))
            menuArray.append(menuItem)
        }
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont.systemFontOfSize(15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(arrowSize: 12,  //指示箭头大小
            marginXSpacing: 7,  //MenuItem左右边距
            marginYSpacing: 7,  //MenuItem上下边距
            intervalSpacing: 20,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: KxColor(R: 0.5, G: 0.5, B: 0.5),  //menuItem字体颜色
            menuBackgroundColor: KxColor(R: 1, G: 1, B: 1)  //菜单的底色
        )
        
        
        //菜单展示
        KxMenu.showMenuInView(self.view, fromRect: sender.frame, menuItems: menuArray, withOptions: options)
    }
    
    func selectMemberClick(sender: AnyObject)
    {
        let item:KxMenuItem = sender as! KxMenuItem
        currentMemberId = item.itemId
        currentMemberName = item.title
        memberButton.setTitle(currentMemberName, forState: UIControlState.Normal)
        refreshChartData()
    }
    
}
