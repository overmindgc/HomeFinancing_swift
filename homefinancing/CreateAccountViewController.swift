//
//  CreateAccountViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/7/16.
//  Copyright © 2016 wph. All rights reserved.
//

class CreateAccountViewController: HFBaseViewController {

    var originAccountModel:AccountModel?
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var menberButton: UIButton!
    @IBOutlet weak var remarkButton: UIButton!
    
    @IBOutlet weak var payTipLabel: UILabel!
    @IBOutlet weak var incomeTipLabel: UILabel!
    @IBOutlet weak var separateLine: UIView!
    @IBOutlet weak var horSeparateLine: UIView!
    
    var scrollView: UIScrollView!
    
    var payTypeButtonArray:Array<AccountTypeSquareButton> = []
    var incomeTypeButtonArray:Array<AccountTypeSquareButton> = []
    
    var lastSelectPayTypeIndex:Int = -1
    var lastSelectIncomeTypeIndex:Int = -1
    
    var numPadView:AccountNumberPad?
    
    let nowDate:Date = Date()
    
    var currentResult:String?
    var currentSelectTypeButton:AccountTypeSquareButton?
    var currentSelectDate:Date?
    var currentRemarkText:String?
    var currentMemberId:String?
    var currentMemberName:String?
    
    var memberModelArray:Array<MemberModel>?
    
    override func viewDidLoad() {
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = UIColor.white.cgColor
        dateButton.layer.cornerRadius = 5
        
        menberButton.layer.borderWidth = 1
        menberButton.layer.borderColor = UIColor.white.cgColor
        menberButton.layer.cornerRadius = 5
        menberButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let scrollViewHeight:CGFloat = SCREEN_HEIGHT - AccountNumberPad.padHeight - horSeparateLine.frame.origin.y
        scrollView = UIScrollView(frame: CGRect(x: 0,y: horSeparateLine.frame.origin.y + 1,width: SCREEN_WIDTH, height: scrollViewHeight))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        self.view.addSubview(scrollView)
        
        initAccountTypeButtons()
        initNumberPadView()
        
        if originAccountModel != nil {
            currentSelectDate = Date.dateWithStandardFormatString(originAccountModel?.accountDate)
            currentRemarkText = originAccountModel?.remark
            currentMemberId = originAccountModel?.memberId
            currentMemberName = originAccountModel?.memberName
            menberButton.setTitle(currentMemberName, for: UIControlState())
            currentResult = originAccountModel?.amount
            numPadView?.changeTopBarLabelText((originAccountModel?.typeName!)!, type: AccountType(rawValue: (originAccountModel?.payOrIncome)!)!)
            numPadView?.setAmountResultText(currentResult!)
        } else {
            currentSelectDate = nowDate
            currentMemberId = "1001"
            currentMemberName = "全家"
        }
        self.dateButton.setTitle(Date.monthDayStringWithStandardFormat(currentSelectDate), for: UIControlState())
    }
    
    override func viewDidLayoutSubviews() {
        let tipLabelRect:CGRect = payTipLabel.frame
        payTipLabel.frame = CGRect(x:SCREEN_WIDTH/4*3/2 - tipLabelRect.size.width/2, y:tipLabelRect.origin.y, width:tipLabelRect.size.width, height:tipLabelRect.size.height)
        payTipLabel.setNeedsDisplay()
        incomeTipLabel.frame = CGRect(x:SCREEN_WIDTH/4*3 + SCREEN_WIDTH/4/2 - tipLabelRect.size.width/2, y:tipLabelRect.origin.y, width:tipLabelRect.size.width, height:tipLabelRect.size.height)
        separateLine.frame = CGRect(x:SCREEN_WIDTH/4*3 - 6, y:64, width:1, height:29)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func initAccountTypeButtons() {
        let paddingTop:CGFloat = 15
        
        let payModelArray = DataStorageService.sharedInstance.getAccountTypeList(AccountType.pay)
        let incomeModelArray = DataStorageService.sharedInstance.getAccountTypeList(AccountType.income)
        
        for index in 0 ..< payModelArray.count {
            let payModel = payModelArray[index]
            
            var payLine:Int = ((index + 1) / 3)
            var payLineNum:Int = (index + 1) % 3
            if payLineNum == 0 {
                payLineNum = 3
                payLine = payLine - 1
            }
            let payButtonX:CGFloat = AccountTypeSquareButton.buttonPadding * CGFloat(payLineNum) + 0 + AccountTypeSquareButton.buttonWidth * (CGFloat(payLineNum) - 1)
            let payButtonY:CGFloat = AccountTypeSquareButton.buttonPadding * CGFloat(payLine) + AccountTypeSquareButton.buttonHeight * CGFloat(payLine) + paddingTop
            
            let payButton:AccountTypeSquareButton = AccountTypeSquareButton(frame: CGRect(x: payButtonX, y: payButtonY, width: AccountTypeSquareButton.buttonWidth, height: AccountTypeSquareButton.buttonHeight),type: AccountType.pay,title: payModel.name!)
            payButton.buttonIndex = index;
            payButton.buttonId = payModel.id
            payButton.addTarget(self, action: #selector(self.typeButtonClick(_:)), for: UIControlEvents.touchUpInside)
            if originAccountModel != nil && currentSelectTypeButton == nil && originAccountModel?.payOrIncome == String(describing: AccountType.pay) {
                if originAccountModel?.typeId == payModel.id {
                    payButton.selectedSquare = true;
                    currentSelectTypeButton = payButton
                    lastSelectPayTypeIndex = index
                }
            }
            scrollView.addSubview(payButton)
            
            payTypeButtonArray.append(payButton)
        }
        
        for index in 0 ..< incomeModelArray.count {
            let incomeModel = incomeModelArray[index]
            
            let incomeButtonX:CGFloat = SCREEN_WIDTH -  AccountTypeSquareButton.buttonPadding - AccountTypeSquareButton.buttonWidth
            let incomeButtonY:CGFloat = paddingTop + AccountTypeSquareButton.buttonPadding * CGFloat(index) + AccountTypeSquareButton.buttonHeight * CGFloat(index)
            
            let incomeButton:AccountTypeSquareButton = AccountTypeSquareButton(frame: CGRect(x: incomeButtonX, y: incomeButtonY, width: AccountTypeSquareButton.buttonWidth, height: AccountTypeSquareButton.buttonHeight),type: AccountType.income,title: incomeModel.name!)
            incomeButton.buttonIndex = index
            incomeButton.buttonId = incomeModel.id
            incomeButton.addTarget(self, action: #selector(self.typeButtonClick(_:)), for: UIControlEvents.touchUpInside)
            
            if originAccountModel != nil && currentSelectTypeButton == nil && originAccountModel?.payOrIncome == String(describing: AccountType.income) {
                if originAccountModel?.typeId == incomeModel.id {
                    incomeButton.selectedSquare = true;
                    currentSelectTypeButton = incomeButton
                    lastSelectPayTypeIndex = index
                }
            }
            scrollView.addSubview(incomeButton)
            
            incomeTypeButtonArray.append(incomeButton)
        }
        
        //默认选中第一个
        if currentSelectTypeButton == nil {
            let defaultButton = payTypeButtonArray[0]
            defaultButton.selectedSquare = true;
            currentSelectTypeButton = defaultButton
            lastSelectPayTypeIndex = 0
        }
        
        let payLine:Int = payModelArray.count / 3
        let incomeLine:Int = incomeModelArray.count
        var maxLine:Int = payLine
        if payLine < incomeLine {
            maxLine = incomeLine
        }
        
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: CGFloat(maxLine) * AccountTypeSquareButton.buttonHeight + CGFloat(maxLine) * AccountTypeSquareButton.buttonPadding + paddingTop)
    }
    
    func initNumberPadView() {
        numPadView = AccountNumberPad(frame: CGRect(x: 0,y: SCREEN_HEIGHT - AccountNumberPad.padHeight,width: SCREEN_WIDTH,height: AccountNumberPad.padHeight))
        numPadView?.confirmClosure = confirmResult
        self.view.addSubview(numPadView!)
    }
    
    func confirmResult(_ result:Int) {
        if result > 0 {
            currentResult = String(result)
            let accountModel:AccountModel = AccountModel()
            if originAccountModel != nil {
                accountModel.id = originAccountModel?.id
                accountModel.createDate = originAccountModel?.createDate
            } else {
                accountModel.id = String(nowDate.timeIntervalSince1970)
                accountModel.createDate = Date.dateFullStringWithStandardFormat(nowDate)
            }
            accountModel.bookId = "1"
            accountModel.accountDate = Date.dateDayStringWithStandardFormat(currentSelectDate)
            accountModel.accountMonthDate = Date.yearMonthStringWithStandardFormat(currentSelectDate)
            accountModel.accountYearDate = Date.yearStringWithStandardFormat(currentSelectDate)
            accountModel.updateDate = Date.dateFullStringWithStandardFormat(nowDate)
            accountModel.typeId = currentSelectTypeButton?.buttonId
            accountModel.typeName = currentSelectTypeButton?.buttonTitle
            accountModel.amount = currentResult
            accountModel.memberId = currentMemberId
            accountModel.memberName = currentMemberName
            accountModel.remark = currentRemarkText
            if currentSelectTypeButton?.accountType == AccountType.pay {
                accountModel.payOrIncome = String(describing: AccountType.pay)
            } else {
                accountModel.payOrIncome = String(describing: AccountType.income)
            }
            
            DataStorageService.sharedInstance.addAccountToDatabase(accountModel)
            
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: CREATE_UPDATE_DEL_ACCOUNT_SUCCESS_NOTICATION), object: nil)
            })
        }
    }
    
    //MARK: - Functions
    
    
    // MARK: - Actions
    func typeButtonClick(_ sender:AnyObject) {
        let typeButton = sender as! AccountTypeSquareButton
        currentSelectTypeButton = typeButton
        let isSelected = typeButton.selectedSquare
        let selectIndex = typeButton.buttonIndex
        let buttenType = typeButton.accountType
        
        numPadView?.changeTopBarLabelText(typeButton.buttonTitle!, type: buttenType)

        if buttenType == AccountType.pay {
            if lastSelectPayTypeIndex != -1 {
                let lastPayButton = payTypeButtonArray[lastSelectPayTypeIndex]
                lastPayButton.selectedSquare = false
            }
            if isSelected == true {
                typeButton.selectedSquare = false
                lastSelectPayTypeIndex = -1
            } else {
                typeButton.selectedSquare = true
                lastSelectPayTypeIndex = selectIndex!
            }
            
            if lastSelectIncomeTypeIndex != -1 {
                let lastIncomeButton = incomeTypeButtonArray[lastSelectIncomeTypeIndex]
                lastIncomeButton.selectedSquare = false
            }
            
        } else {
            if lastSelectIncomeTypeIndex != -1 {
                let lastIncomeButton = incomeTypeButtonArray[lastSelectIncomeTypeIndex]
                lastIncomeButton.selectedSquare = false
            }
            if isSelected == true {
                typeButton.selectedSquare = false
                lastSelectIncomeTypeIndex = -1
            } else {
                typeButton.selectedSquare = true
                lastSelectIncomeTypeIndex = selectIndex!
            }
            
            if lastSelectPayTypeIndex != -1 {
                let lastPayButton = payTypeButtonArray[lastSelectPayTypeIndex]
                lastPayButton.selectedSquare = false
            }
        }
        
    }
    
    func selectMemberClick(_ sender: AnyObject)
    {
        let item:KxMenuItem = sender as! KxMenuItem
        currentMemberId = item.itemId
        currentMemberName = item.title
        menberButton.setTitle(currentMemberName, for: UIControlState())
    }
    
    // MARK: - actions
    
    @IBAction func selectDayAction(_ sender: AnyObject) {
        DatePickerDialog().show("选择日期", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .date) {
            (date) -> Void in
            self.currentSelectDate = date
            self.dateButton.setTitle(Date.monthDayStringWithStandardFormat(date), for: UIControlState())
        }
    }
    
    @IBAction func selectMemberAction(_ sender: AnyObject) {
        memberModelArray = MemberStorageService.sharedInstance.getAllMemberList()
        let allMemberModel:MemberModel = MemberModel()
        allMemberModel.id = "1001"
        allMemberModel.name = "全家"
        memberModelArray?.insert(allMemberModel, at: 0)
        
        //配置零：内容配置
        var menuArray:Array<KxMenuItem> = []
        for memberModel in memberModelArray! {
            let menuItem = KxMenuItem.init(memberModel.name,itemId: memberModel.id , image: UIImage(named: "person_small"), target: self, action: #selector(self.selectMemberClick(_:)))
            menuArray.append(menuItem!)
        }
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont.systemFont(ofSize: 15))
        
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
        KxMenu.show(in: self.view, from: sender.frame, menuItems: menuArray, withOptions: options)
    }
    
    @IBAction func writeRemarkAction(_ sender: AnyObject) {
        //创建alert
        let alertView = YoYoInputAlertView(title: "填写备注", message: currentRemarkText, cancelButtonTitle: "取 消", sureButtonTitle: "确 定")
        //调用显示
        alertView.show()
        //获取点击事件
        alertView.clickIndexClosure { (index,contentText) in
            if index == 2 {
                self.currentRemarkText = contentText
            }
        }
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
