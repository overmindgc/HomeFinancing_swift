//
//  AccountNumberPad.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/8/16.
//  Copyright © 2016 wph. All rights reserved.
//

class AccountNumberPad: UIView {
    static let separateLineWidth:CGFloat = 1
    static let numberSqWidth:CGFloat = (SCREEN_WIDTH * 0.8 - separateLineWidth * 3) / 3
    static let numberSqHeight:CGFloat = numberSqWidth * 0.65
    static let operatorSqWidth:CGFloat = SCREEN_WIDTH * 0.2
    static let topBarHeight:CGFloat = numberSqHeight * 0.9
    static let padHeight = topBarHeight + numberSqHeight * 4 + separateLineWidth * 4
    
    /**结果值*/
    internal var resultNum:Int?
    
    typealias confirmResultClosure = (result:Int) -> Void
    internal var confirmClosure:confirmResultClosure?
    
    /**单数字最大长度*/
    internal var maxNumLength:Int = 8
    
    private var topBarView:UIView!
    private var topBarLabel:UILabel!
    private var resultLabel:UILabel!
    
    private var confirmButton:NumPadButton?
    
    internal var resultText:String = ""
    
    private let buttonTag = (plusTag: 1001,deleteTag: 1002,clearTag: 1003,confirmTag: 1004)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    // MARK: - Public functions
    /**改变顶部标题的文字和样式*/
    func changeTopBarLabelText(text:String,type:AccountType) {
        topBarLabel?.text = text;
        if type == AccountType.pay {
            topBarLabel?.textColor = appPayColor
        } else {
            topBarLabel?.textColor = appIncomeColor
        }
    }
    
    /**改变金额数值和标签文字*/
    func setAmountResultText(amountString:String) {
        resultText = amountString
        resultLabel.text = resultText
    }
    
    // MARK: - private functions
    
    private func initViews() {
        self.backgroundColor = UIColor.lightGrayColor()
        
        topBarView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,AccountNumberPad.topBarHeight))
        topBarView.backgroundColor = appDarkBackgroundColor_lite
        self.addSubview(topBarView)
        
        topBarLabel = UILabel(frame: CGRectMake(15,0,100,AccountNumberPad.topBarHeight))
        topBarLabel.font = UIFont.boldSystemFontOfSize(20)
        topBarLabel.text = "一般支出"
        topBarLabel.textColor = appPayColor
        self.addSubview(topBarLabel)
        
        resultLabel = UILabel(frame: CGRectMake(topBarLabel!.frame.size.width + 15,0,SCREEN_WIDTH - topBarLabel!.frame.size.width - 15 - 15,AccountNumberPad.topBarHeight))
        resultLabel.textColor = UIColor.whiteColor()
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.numberOfLines = 0
        resultLabel.font = UIFont.boldSystemFontOfSize(27)
        resultLabel.textAlignment = NSTextAlignment.Right
        resultLabel.text = "0"
        self.addSubview(resultLabel)
        
        
        initLeftNumButtons()
        initRightOperateButtons()
    }
    
    private func initLeftNumButtons() {
        let startSqY:CGFloat = AccountNumberPad.topBarHeight + AccountNumberPad.separateLineWidth
        for index in 1 ..< 13 {
            var numLine:Int = index / 3 + 1
            var numLineNum:Int = index % 3
            if numLineNum == 0 {
                numLineNum = 3
                numLine = numLine - 1
            }
            
            let numSqX:CGFloat = (AccountNumberPad.numberSqWidth + AccountNumberPad.separateLineWidth) * (CGFloat(numLineNum) - 1)
            let numSqY:CGFloat = startSqY + (AccountNumberPad.numberSqHeight + AccountNumberPad.separateLineWidth) * (CGFloat(numLine) - 1)
            
            if index < 10 {
                let numButton:NumPadButton = NumPadButton(frame: CGRectMake(numSqX,numSqY,AccountNumberPad.numberSqWidth,AccountNumberPad.numberSqHeight))
                numButton.setTitle(String(index), forState: UIControlState.Normal)
                numButton.addTarget(self, action: #selector(self.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                numButton.tag = index
                self.addSubview(numButton)
            }
            
            if index == 10 {
                let zeroButton:NumPadButton = NumPadButton(frame: CGRectMake(numSqX,numSqY,AccountNumberPad.numberSqWidth * 2 + AccountNumberPad.separateLineWidth,AccountNumberPad.numberSqHeight))
                zeroButton.setTitle("0", forState: UIControlState.Normal)
                zeroButton.addTarget(self, action: #selector(self.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                zeroButton.tag = 0
                self.addSubview(zeroButton)
            }
            
            if index == 12 {
                let plusButton:NumPadButton = NumPadButton(frame: CGRectMake(numSqX,numSqY,AccountNumberPad.numberSqWidth,AccountNumberPad.numberSqHeight))
                plusButton.tag = buttonTag.plusTag
                plusButton.setTitle("＋", forState: UIControlState.Normal)
                plusButton.setTitleColor(appIncomeColor, forState: UIControlState.Normal)
                plusButton.addTarget(self, action: #selector(self.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(plusButton)
            }
        }
    }
    
    private func initRightOperateButtons() {
        let startSqY:CGFloat = AccountNumberPad.topBarHeight + AccountNumberPad.separateLineWidth
        
        for index in 0 ..< 3 {
            let sqX = AccountNumberPad.numberSqWidth * 3 + AccountNumberPad.separateLineWidth * 3
            let sqY = startSqY + (AccountNumberPad.numberSqHeight + AccountNumberPad.separateLineWidth) * CGFloat(index)
            
            var buttonHeight:CGFloat = AccountNumberPad.numberSqHeight
            if index == 2 {
                buttonHeight = AccountNumberPad.numberSqHeight * 2 + AccountNumberPad.separateLineWidth
            }
            let operateButton = NumPadButton(frame: CGRectMake(sqX,sqY,AccountNumberPad.operatorSqWidth,buttonHeight))
            
            switch index {
            case 0:
                operateButton.tag = buttonTag.deleteTag
                operateButton.setImage(UIImage(named: "delete_num"), forState: UIControlState.Normal)
            case 1:
                operateButton.tag = buttonTag.clearTag
                operateButton.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
                operateButton.setTitle("C", forState: UIControlState.Normal)
            case 2:
                confirmButton = operateButton
                operateButton.tag = buttonTag.confirmTag
                operateButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
                operateButton.setTitle("确定", forState: UIControlState.Normal)
                operateButton.setTitleColor(appPayColor, forState: UIControlState.Normal)
            default:
                print("none")
            }
            
            operateButton.addTarget(self, action: #selector(self.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.addSubview(operateButton)
        }
    }
    
    // MARK: - action
    func buttonClick(sender:AnyObject) {
        let currButton:NumPadButton = sender as! NumPadButton
        
        switch currButton.tag {
        case buttonTag.plusTag:
            resultText = resultText.stringByAppendingString("+")
            
        case buttonTag.deleteTag:
            if resultText.characters.count > 0 {
                resultText.removeAtIndex(resultText.endIndex.predecessor())
            }
        case buttonTag.clearTag:
            resultText = ""
        case buttonTag.confirmTag:
            if confirmButton?.currentTitle == "=" {
                //这种方法，只取出数字，没有空字符
                let inputNumArr = resultText.characters.split{$0 == "+"}.map(String.init)
                resultNum = 0
                for numStr in inputNumArr {
                    resultNum = resultNum! + Int(numStr)!
                }
                resultText = String(resultNum!)
            } else {
               confirmInput()
            }
        default:
            resultText = resultText.stringByAppendingString(String(currButton.tag))
            if checkInputNumHasMaxLength() {
                resultText.removeAtIndex(resultText.endIndex.predecessor())
            }
        }
        
        if resultText.characters.count > 0 {
            resultLabel?.text = resultText
            if resultText.containsString("+") {
                changeConfirmToEqule(true)
            } else {
                changeConfirmToEqule(false)
            }
        } else {
            resultText = ""
            resultLabel?.text = "0"
            changeConfirmToEqule(false)
        }
    }
    
    private func checkInputNumHasMaxLength() -> Bool {
//        let inputNumArr = resultText.split("+") //这种方法取出的，会有空字符串
        //这种方法，只取出数字，没有空字符
        let inputNumArr = resultText.characters.split{$0 == "+"}.map(String.init)
        for numStr in inputNumArr {
            if numStr.characters.count > maxNumLength {
                return true
            }
        }
        return false
    }
    
    private func changeConfirmToEqule(isChange:Bool) {
        if isChange {
            confirmButton?.titleLabel?.font = UIFont.boldSystemFontOfSize(25)
            confirmButton?.setTitle("=", forState: UIControlState.Normal)
            confirmButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            confirmButton?.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
            confirmButton?.setTitle("确定", forState: UIControlState.Normal)
            confirmButton?.setTitleColor(appPayColor, forState: UIControlState.Normal)
        }
    }
    
    private func confirmInput() {
        if confirmClosure != nil {
            if resultText.characters.count > 0 {
                resultNum = Int(resultText)!
                confirmClosure!(result: resultNum!)
            } else {
                resultNum = 0
                confirmClosure!(result: resultNum!)
            }
        }
        
    }
    
}
