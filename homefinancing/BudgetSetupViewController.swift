//
//  BudgetSetupViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/13/16.
//  Copyright © 2016 wph. All rights reserved.
//

class BudgetSetupViewController: HFBaseViewController,UITextFieldDelegate {

    let maxAmountLen:Int = 8
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dayBudgetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneBarButton = UIBarButtonItem(title: "完成",style: UIBarButtonItemStyle.Plain,target:self,action:#selector(self.doneAction(_:)))
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        let defaultMonthBudget = NSUserDefaults.currentMonthBudget()
        if defaultMonthBudget != 0 {
            amountTextField.text = String(defaultMonthBudget)
            let dayBudget:Int! = defaultMonthBudget / 30
            dayBudgetLabel.text = String(dayBudget)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textFieldDidChangeAction), name: UITextFieldTextDidChangeNotification, object: nil)
        
    }
    // 触摸背景，关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func doneAction(sender: AnyObject) {
        amountTextField.resignFirstResponder()
        if amountTextField.text?.characters.count > 0 {
            let monthBudget:Int! = Int(amountTextField.text!)
            NSUserDefaults.saveMonthBudget(monthBudget)
        }
        self.navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName(CHANGE_MONTH_BUDGET_NUM_SUCCESS_NOTIFICATION, object: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        //退格放行
        if string == "" {
            return true
        } else {
            if NUM_STRING_POOL.contains(string) {
                if textField.text?.characters.count > maxAmountLen - 1 {
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeAction() {
        if amountTextField.text?.characters.count > 0 {
            let monthBudget:Int! = Int(amountTextField.text!)
            let dayBudget:Int! = monthBudget / 30
            dayBudgetLabel.text = String(dayBudget)
        } else {
            dayBudgetLabel.text = "0"
        }
    }
    
}
