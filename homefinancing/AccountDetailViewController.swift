//
//  AccountDetailViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/13/16.
//  Copyright © 2016 wph. All rights reserved.
//

class AccountDetailViewController: HFBaseViewController {

    internal var currentAccountModel:AccountModel?
    
    @IBOutlet weak var amountTitleLabel:UILabel!
    @IBOutlet weak var amountLabel:UILabel!
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var menberLabel:UILabel!
    @IBOutlet weak var remarkLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let editBarButton = UIBarButtonItem(image: UIImage(named: "write"),style: UIBarButtonItemStyle.plain,target:self,action:#selector(self.editAction(_:)))
        self.navigationItem.rightBarButtonItem = editBarButton
        setAmountLabelStyle()
        
        amountLabel.text = "￥" + (currentAccountModel?.amount)!
        let payOrIncomeText:String?
        if currentAccountModel?.payOrIncome == String(describing: AccountType.pay) {
            payOrIncomeText = "支出"
        } else {
            payOrIncomeText = "收入"
        }
        typeLabel.text = payOrIncomeText! + " > " + (currentAccountModel?.typeName)!
        dateLabel.text = (currentAccountModel?.accountDate)!
        menberLabel.text = (currentAccountModel?.memberName)!
        if currentAccountModel?.remark != "" {
            remarkLabel.text = (currentAccountModel?.remark)!
        } else {
            remarkLabel.text = "无"
        }
        
    }
    
    func setAmountLabelStyle() {
        if currentAccountModel?.payOrIncome == String(describing: AccountType.pay) {
            amountTitleLabel.textColor = appPayColor
            amountLabel.textColor = appPayColor
        } else {
            amountTitleLabel.textColor = appIncomeColor
            amountLabel.textColor = appIncomeColor
        }
    }
    
    
    func editAction(_ sender:AnyObject) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let createVC = sb.instantiateViewController(withIdentifier: "createAccountVC") as! CreateAccountViewController
        createVC.originAccountModel = currentAccountModel
        self.present(createVC, animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func deleteAction(_ sender:AnyObject) {
        //创建alert
        let alertView = YoYoAlertView(title: "提醒", message: "确定要删除此条账单吗？", cancelButtonTitle: "取 消", sureButtonTitle: "确 定")
        //调用显示
        alertView.show()
        //获取点击事件
        alertView.clickIndexClosure { (index) in
            if index == 2 {
                DataStorageService.sharedInstance.deleteAccountWithId(self.currentAccountModel!.id!)
                NotificationCenter.default.post(name: Notification.Name(rawValue: CREATE_UPDATE_DEL_ACCOUNT_SUCCESS_NOTICATION), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
