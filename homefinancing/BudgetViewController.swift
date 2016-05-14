//
//  BudgetViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 4/11/16.
//  Copyright © 2016 wph. All rights reserved.
//

class BudgetViewController: HFBaseViewController {
    
    internal var monthPayTotalAmount:String?
    internal var currentMonth:String?
    internal var isNowMonth:Bool?
    
    @IBOutlet weak var monthBudgetLabel: UILabel!
    
    @IBOutlet weak var centerCicleView: UIView!
    
    @IBOutlet weak var leftBudgetLabel: UILabel!
    
    @IBOutlet weak var setupButton: UIButton!
    
    @IBOutlet weak var monthPayLabel: UILabel!
    
    @IBOutlet weak var leftBudgetDayLabel: UILabel!
    
    @IBOutlet weak var monthPayTitleLabel: UILabel!
    
    var progress:KDCircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "预算"
        
        setupButton.layer.borderWidth = 1
        setupButton.layer.borderColor = appPayColor.CGColor
        setupButton.layer.cornerRadius = 17.5
        
        let circleFrame:CGRect = centerCicleView.frame
        let cicrleWidth:CGFloat = 175
        let gap:CGFloat = 38
        let progressX:CGFloat = SCREEN_WIDTH/2 - cicrleWidth/2 - gap/2
        progress = KDCircularProgress(frame: CGRect(x: progressX, y: circleFrame.origin.y - gap - 1, width: circleFrame.size.width + gap*2, height: circleFrame.size.height + gap*2))
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.2
        progress.clockwise = false
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .NoGlow
        progress.angle = 0
        progress.setColors(appIncomeColor)
        progress.trackColor = UIColor.groupTableViewBackgroundColor()
        self.view.addSubview(progress)
        
        if isNowMonth != true {
            let month:Int = Int((currentMonth?.split("-")[1])!)!
            monthPayTitleLabel.text = String(month) + "月支出"
        }
    }

    override func viewWillAppear(animated: Bool) {
        initBudgetViewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBudgetViewData() {
        let budget = NSUserDefaults.currentMonthBudget()
        
        monthBudgetLabel.text = "￥" + String(budget)
        monthPayLabel.text = "￥" + monthPayTotalAmount!
        
        let monthPay:Int = Int(monthPayTotalAmount!)!
        if budget == 0 || monthPay > budget {
            progress.changeCircleValueWithDecimalPercent(0)
            leftBudgetLabel.text = "￥0"
        } else {
            let leftAmount = budget - monthPay
            let percent:CGFloat = CGFloat(leftAmount) / CGFloat(budget)
            progress.changeCircleValueWithDecimalPercent(percent)
            leftBudgetLabel.text = "￥" + String(leftAmount)
        }
        
        let totalDay:Int = 30
        let dayBudget:Int! = budget / totalDay
        let dayPay:Int! = Int(monthPayTotalAmount!)! / totalDay
        leftBudgetDayLabel.text = "￥" + String(dayBudget - dayPay)
    }

}
