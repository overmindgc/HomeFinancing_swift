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
        let doneBarButton = UIBarButtonItem(title: "完成",style: UIBarButtonItemStyle.plain,target:self,action:#selector(self.doneAction(_:)))
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        let defaultMonthBudget = UserDefaults.currentMonthBudget()
        if defaultMonthBudget != 0 {
            amountTextField.text = String(defaultMonthBudget)
            let dayBudget:Int! = defaultMonthBudget / 30
            dayBudgetLabel.text = String(dayBudget)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChangeAction), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    // 触摸背景，关闭键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func doneAction(_ sender: AnyObject) {
        amountTextField.resignFirstResponder()
        if (amountTextField.text?.characters.count)! > 0 {
            let monthBudget:Int! = Int(amountTextField.text!)
            UserDefaults.saveMonthBudget(monthBudget)
        }
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: CHANGE_MONTH_BUDGET_NUM_SUCCESS_NOTIFICATION), object: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //退格放行
        if string == "" {
            return true
        } else {
            if NUM_STRING_POOL.contains(string) {
                if (textField.text?.characters.count)! > maxAmountLen - 1 {
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeAction() {
        if (amountTextField.text?.characters.count)! > 0 {
            let monthBudget:Int! = Int(amountTextField.text!)
            let dayBudget:Int! = monthBudget / 30
            dayBudgetLabel.text = String(dayBudget)
        } else {
            dayBudgetLabel.text = "0"
        }
    }
    
}
