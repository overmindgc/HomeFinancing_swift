//
//  HomeViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 16/2/20.
//  Copyright © 2016年 wph. All rights reserved.
//

class HomeViewController: HFBaseViewController,UITableViewDelegate,UITableViewDataSource {

    let tableCellIndentifierDate = "tableCellIndentifierDate"
    let tableCellIndentifierItem = "tableCellIndentifierItem"
    
    @IBOutlet weak var tableView: HFBaseTableView!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var topCenterView: UIButton!
    @IBOutlet weak var topPercentLabel: UILabel!
    @IBOutlet weak var topCnDateView: UILabel!
    
    var tableSource:Array<AccountGroupStruct> = []
    
    var progress:KDCircularProgress!
    
    var blankView:UIView?
    var blankLabel:UILabel?
    
    var currentSearchMonthStr:String?
    
    let nowDate = NSDate()
    
    var currentMonthOffset:Int = 0
    
    var currentSelectAccountModel:AccountModel?
    
    var currentMonthPayAmount:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = appPayColor
        self.navigationController?.title = "主页"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let colorDict:[String:AnyObject] = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = colorDict
        self.navigationController?.navigationBar.hideBottomHairline()
        
        payLabel.adjustsFontSizeToFitWidth = true;
        incomeLabel.adjustsFontSizeToFitWidth = true;
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        progress.startAngle = -90
        progress.progressThickness = 0.35
        progress.trackThickness = 0.35
        progress.clockwise = false
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .NoGlow
        progress.angle = 0
        progress.setColors(appIncomeColor)
        progress.trackColor = appLitePayColor
        topCenterView.addSubview(progress)
        topCenterView.addTarget(self, action: #selector(self.budgetCircleClickAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let blankImage = UIImage(named: "blank_bill")
        let imageWidth:CGFloat = (blankImage?.size.width)!
        let imageHeight:CGFloat = (blankImage?.size.height)!
        blankView = UIView(frame:CGRectMake(0,0,SCREEN_WIDTH,self.tableView.frame.size.height))
        let blankImageView = UIImageView(frame:CGRectMake(SCREEN_WIDTH/2 - imageWidth/2,self.tableView.frame.size.height/2 - imageHeight/2 - 100,imageWidth,imageHeight))
        blankImageView.image = blankImage
        blankView?.addSubview(blankImageView)
        blankLabel = UILabel(frame:CGRectMake(0,blankImageView.frame.origin.y + blankImageView.frame.size.height,SCREEN_WIDTH,100))
        blankLabel?.textAlignment = NSTextAlignment.Center
        blankLabel?.font = UIFont.boldSystemFontOfSize(17)
        blankLabel?.textColor = UIColor.lightGrayColor()
        
        blankLabel?.numberOfLines = 0
        blankView?.addSubview(blankLabel!)
        self.tableView.addSubview(blankView!)
        
        currentSearchMonthStr = NSDate.yearMonthStringWithStandardFormat(nowDate)
        
        let dateCnStr = NSDate.yearMonthCnStringWithStandardFormat(nowDate)
        topCnDateView.text = dateCnStr
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshTableData(_:)), name: CREATE_UPDATE_DEL_ACCOUNT_SUCCESS_NOTICATION, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshBudgetCircle), name: CHANGE_MONTH_BUDGET_NUM_SUCCESS_NOTIFICATION, object: nil)
        
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTableData(notification:NSNotification) {
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    func getTableDataWithMonth(monthStr:String)
    {
        let resultTuple = DataStorageService.sharedInstance.getHomeTableSourceListByMonth(monthStr)
        tableSource = resultTuple.array
        payLabel.text = resultTuple.payTotal
        incomeLabel.text = resultTuple.incomeTotal
        currentMonthPayAmount = resultTuple.payTotal
        let monthOnlyStr:String?
        if NSDate.yearMonthStringWithStandardFormat(NSDate()) == monthStr {
            monthOnlyStr = "当月"
        } else {
            let offset = monthStr.startIndex.advancedBy(5)
            monthOnlyStr = monthStr.substringFromIndex(offset) + "月"
        }
        surplusLabel.text = monthOnlyStr! + "结余：￥" + resultTuple.surplus
        if tableSource.count > 0 {
            blankView?.hidden = true
        } else {
            if currentMonthOffset == 0 {
                blankLabel?.text = "当月还没有账单\n\n快来记一笔吧"
            } else {
                blankLabel?.text = "当月还没有账单"
            }
            blankView?.hidden = false
        }
        tableView.reloadData()
        
        refreshBudgetCircle()
    }
    
    func refreshBudgetCircle() {
        let budget = NSUserDefaults.currentMonthBudget()
        let monthPay:Int = Int(currentMonthPayAmount!)!
        if budget == 0 || monthPay > budget {
            progress.changeCircleValueWithDecimalPercent(0)
            topPercentLabel.text = "0%"
        } else {
            let percent:CGFloat = (CGFloat(budget) - CGFloat(monthPay)) / CGFloat(budget)
            progress.changeCircleValueWithDecimalPercent(percent)
            let percentInteger:Int = Int(percent * 100)
            topPercentLabel.text = String(percentInteger) + "%"
        }
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableSource.count
    }
    //每一块有多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupStruct:AccountGroupStruct = tableSource[section]
        return groupStruct.accountModelArray.count
    }
    //绘制cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let itemCell = HomeItemCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableCellIndentifierItem)
        itemCell.accessoryType = UITableViewCellAccessoryType.None
        let groupStruct:AccountGroupStruct = tableSource[section]
        let accountModel = groupStruct.accountModelArray[row]
        if accountModel.payOrIncome == String(AccountType.pay) {
            itemCell.currentType = AccountType.pay
            itemCell.payLabel.text = "￥" + accountModel.amount! + " " + accountModel.typeName!
        } else {
            itemCell.currentType = AccountType.income
            itemCell.incomeLabel.text = accountModel.typeName! + " " + "￥" + accountModel.amount!
        }
        if section == tableSource.count - 1 && row == groupStruct.accountModelArray.count - 1{
            itemCell.hideButtomVLine = true
        } else {
            itemCell.hideButtomVLine = false
        }
        return itemCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currCell:HFTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! HFTableViewCell
        currCell.selected = false
        let groupStruct:AccountGroupStruct = tableSource[indexPath.section]
        let accountModel = groupStruct.accountModelArray[indexPath.row]
        currentSelectAccountModel = accountModel
        self.performSegueWithIdentifier("accountDetailSegue", sender: self)
    }
    
    //每个cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return colorCellHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HomeDateHeaderView.dateCellHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let groupStruct:AccountGroupStruct = tableSource[section]
        let headerView:HomeDateHeaderView = HomeDateHeaderView(frame:CGRectMake(0,0,HomeDateHeaderView.dateCellHeight,SCREEN_WIDTH))
        headerView.payMoneyLabel.text = "￥" + groupStruct.payAmount!
        headerView.incomeMoneyLabel.text = "￥" + groupStruct.incomeAmount!
        headerView.dateLabel.text = groupStruct.centerDateStr
        return headerView
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == tableSource.count - 1 {
//            return colorCellHeight
//        } else {
//            return 0
//        }
//    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let bgView:UIView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,colorCellHeight))
//        let circleWidht:CGFloat = colorCellHeight / 2
//        let circleView:UIView = UIView(frame: CGRectMake(SCREEN_WIDTH/2 - circleWidht/2,0,circleWidht,circleWidht))
//        circleView.backgroundColor = UIColor.lightGrayColor()
//        circleView.layer.cornerRadius = circleWidht/2
//        bgView.addSubview(circleView)
//        
//        let verLineView = UIView(frame: CGRectMake(SCREEN_WIDTH/2 - 0.5,0,1,colorCellHeight / 2 - circleWidht / 2))
//        verLineView.backgroundColor = UIColor.lightGrayColor()
//        bgView.addSubview(verLineView)
//        
//        let startLabel:UILabel = UILabel(frame:CGRectMake(SCREEN_WIDTH/2 - 10,circleView.frame.origin.y,20,circleView.frame.size.height))
//        startLabel.font = UIFont.systemFontOfSize(12)
//        startLabel.textColor = UIColor.whiteColor()
//        startLabel.textAlignment = NSTextAlignment.Center
//        startLabel.text = "始"
//        bgView.addSubview(startLabel)
//        
//        return bgView
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "accountDetailSegue" {
            let detailVC:AccountDetailViewController = segue.destinationViewController as! AccountDetailViewController
            detailVC.currentAccountModel = currentSelectAccountModel
        } else if segue.identifier == "budgetShow" {
            let budgetVC = segue.destinationViewController as! BudgetViewController
            budgetVC.currentMonth = currentSearchMonthStr
            budgetVC.monthPayTotalAmount = currentMonthPayAmount
            if currentMonthOffset == 0 {
                budgetVC.isNowMonth = true
            }
        }
    }
    
    @IBAction func addClickAction(sender: AnyObject) {
        
    }
    
    func budgetCircleClickAction(sender: AnyObject) {
        self.performSegueWithIdentifier("budgetShow", sender: self)
    }

    @IBAction func lastMonthAction(sender: AnyObject) {
        currentMonthOffset -= 1
        let lastMonthDate:NSDate = NSDate.dateByOffsetMonth(nowDate, offsetDay: currentMonthOffset)
        currentSearchMonthStr = NSDate.yearMonthStringWithStandardFormat(lastMonthDate)
        topCnDateView.text = NSDate.yearMonthCnStringWithStandardFormat(lastMonthDate)
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    @IBAction func nextMonthAction(sender: AnyObject) {
        currentMonthOffset += 1
        let nextMonthDate:NSDate = NSDate.dateByOffsetMonth(nowDate, offsetDay: currentMonthOffset)
        currentSearchMonthStr = NSDate.yearMonthStringWithStandardFormat(nextMonthDate)
        topCnDateView.text = NSDate.yearMonthCnStringWithStandardFormat(nextMonthDate)
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
