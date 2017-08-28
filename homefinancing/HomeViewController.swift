//
//  HomeViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 16/2/20.
//  Copyright © 2016年 wph. All rights reserved.
//

private extension Selector {
    static let circleTappend = #selector(HomeViewController.budgetCircleClickAction(_:))
    static let refreshTable = #selector(HomeViewController.refreshTableData(_:))
    static let refreshCircle = #selector(HomeViewController.refreshTableData)
}

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
    @IBOutlet weak var bottomBgView: UIView!
    
    var tableSource = [AccountGroupStruct]()
    
    var progress:KDCircularProgress!
    
    var blankView:UIView?
    var blankLabel:UILabel?
    
    var currentSearchMonthStr:String?
    
    let nowDate = Date()
    
    var currentMonthOffset:Int = 0
    
    var currentSelectAccountModel:AccountModel?
    
    var currentMonthPayAmount:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = appPayColor
        self.navigationController?.title = "主页"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let colorDict:[String:AnyObject] = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = colorDict
        self.navigationController?.navigationBar.hideBottomHairline()
        
        bottomBgView.layer.borderWidth = 0.5
        bottomBgView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        payLabel.adjustsFontSizeToFitWidth = true;
        incomeLabel.adjustsFontSizeToFitWidth = true;
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        progress.startAngle = -90
        progress.progressThickness = 0.35
        progress.trackThickness = 0.35
        progress.clockwise = false
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.angle = 0
        progress.setColors(appIncomeColor)
        progress.trackColor = appLitePayColor
        topCenterView.addSubview(progress)
        topCenterView.addTarget(self, action: .circleTappend, for: UIControlEvents.touchUpInside)
        
        let blankImage = UIImage(named: "blank_bill")
        let imageWidth:CGFloat = (blankImage?.size.width)!
        let imageHeight:CGFloat = (blankImage?.size.height)!
        blankView = UIView(frame:CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: self.tableView.frame.size.height))
        let blankImageView = UIImageView(frame:CGRect(x: SCREEN_WIDTH/2 - imageWidth/2,y: self.tableView.frame.size.height/2 - imageHeight/2 - 100,width: imageWidth,height: imageHeight))
        blankImageView.image = blankImage
        blankView?.addSubview(blankImageView)
        blankLabel = UILabel(frame:CGRect(x: 0,y: blankImageView.frame.origin.y + blankImageView.frame.size.height,width: SCREEN_WIDTH,height: 100))
        blankLabel?.textAlignment = NSTextAlignment.center
        blankLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        blankLabel?.textColor = UIColor.lightGray
        
        blankLabel?.numberOfLines = 0
        blankView?.addSubview(blankLabel!)
        self.tableView.addSubview(blankView!)
        
        currentSearchMonthStr = Date.yearMonthStringWithStandardFormat(nowDate)
        
        let dateCnStr = Date.yearMonthCnStringWithStandardFormat(nowDate)
        topCnDateView.text = dateCnStr
        
        NotificationCenter.default.addObserver(self, selector: .refreshTable, name: NSNotification.Name(rawValue: CREATE_UPDATE_DEL_ACCOUNT_SUCCESS_NOTICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: .refreshCircle, name: NSNotification.Name(rawValue: CHANGE_MONTH_BUDGET_NUM_SUCCESS_NOTIFICATION), object: nil)
        
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTableData(_ notification:Notification) {
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    func getTableDataWithMonth(_ monthStr:String)
    {
        let resultTuple = DataStorageService.sharedInstance.getHomeTableSourceListByMonth(monthStr)
        tableSource = resultTuple.array
        payLabel.text = resultTuple.payTotal
        incomeLabel.text = resultTuple.incomeTotal
        currentMonthPayAmount = resultTuple.payTotal
        let monthOnlyStr:String?
        if Date.yearMonthStringWithStandardFormat(Date()) == monthStr {
            monthOnlyStr = "当月"
        } else {
            let offset = monthStr.characters.index(monthStr.startIndex, offsetBy: 5)
            monthOnlyStr = monthStr.substring(from: offset) + "月"
        }
        surplusLabel.text = monthOnlyStr! + "结余：￥" + resultTuple.surplus
        if tableSource.count > 0 {
            blankView?.isHidden = true
        } else {
            if currentMonthOffset == 0 {
                blankLabel?.text = "当月还没有账单\n\n快来记一笔吧"
            } else {
                blankLabel?.text = "当月还没有账单"
            }
            blankView?.isHidden = false
        }
        tableView.reloadData()
        
        refreshBudgetCircle()
    }
    
    func refreshBudgetCircle() {
        let budget = UserDefaults.currentMonthBudget()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSource.count
    }
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupStruct:AccountGroupStruct = tableSource[section]
        return groupStruct.accountModelArray.count
    }
    //绘制cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let itemCell = HomeItemCell(style: UITableViewCellStyle.default, reuseIdentifier: tableCellIndentifierItem)
        itemCell.accessoryType = UITableViewCellAccessoryType.none
        let groupStruct:AccountGroupStruct = tableSource[section]
        let accountModel = groupStruct.accountModelArray[row]
        if accountModel.payOrIncome == String(describing: AccountType.pay) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCell:HFTableViewCell = tableView.cellForRow(at: indexPath) as! HFTableViewCell
        currCell.isSelected = false
        let groupStruct:AccountGroupStruct = tableSource[indexPath.section]
        let accountModel = groupStruct.accountModelArray[indexPath.row]
        currentSelectAccountModel = accountModel
        self.performSegue(withIdentifier: "accountDetailSegue", sender: self)
    }
    
    //每个cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return colorCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HomeDateHeaderView.dateCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let groupStruct:AccountGroupStruct = tableSource[section]
        let headerView:HomeDateHeaderView = HomeDateHeaderView(frame:CGRect(x: 0,y: 0,width: HomeDateHeaderView.dateCellHeight,height: SCREEN_WIDTH))
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "accountDetailSegue" {
            let detailVC:AccountDetailViewController = segue.destination as! AccountDetailViewController
            detailVC.currentAccountModel = currentSelectAccountModel
        } else if segue.identifier == "budgetShow" {
            let budgetVC = segue.destination as! BudgetViewController
            budgetVC.currentMonth = currentSearchMonthStr
            budgetVC.monthPayTotalAmount = currentMonthPayAmount
            if currentMonthOffset == 0 {
                budgetVC.isNowMonth = true
            }
        } else if segue.identifier == "pieChartShow" {
            let pieChartVC = segue.destination as! PieChartStatisticViewController
            pieChartVC.currentMonthStr = currentSearchMonthStr
            pieChartVC.currentMonthOffset = currentMonthOffset
        }
    }
    
    @IBAction func addClickAction(_ sender: AnyObject) {
        
    }
    
    func budgetCircleClickAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "budgetShow", sender: self)
    }

    @IBAction func lastMonthAction(_ sender: AnyObject) {
        currentMonthOffset -= 1
        let lastMonthDate:Date = Date.dateByOffsetMonth(nowDate, offsetDay: currentMonthOffset)
        currentSearchMonthStr = Date.yearMonthStringWithStandardFormat(lastMonthDate)
        topCnDateView.text = Date.yearMonthCnStringWithStandardFormat(lastMonthDate)
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    @IBAction func nextMonthAction(_ sender: AnyObject) {
        currentMonthOffset += 1
        let nextMonthDate:Date = Date.dateByOffsetMonth(nowDate, offsetDay: currentMonthOffset)
        currentSearchMonthStr = Date.yearMonthStringWithStandardFormat(nextMonthDate)
        topCnDateView.text = Date.yearMonthCnStringWithStandardFormat(nextMonthDate)
        getTableDataWithMonth(currentSearchMonthStr!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
