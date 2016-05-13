//
//  BudgetSetupViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/13/16.
//  Copyright © 2016 wph. All rights reserved.
//

class BudgetSetupViewController: HFBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let doneBarButton = UIBarButtonItem(title: "完成",style: UIBarButtonItemStyle.Plain,target:self,action:#selector(self.doneAction(_:)))
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        
    }
    // 触摸背景，关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func doneAction(sender: AnyObject) {
        
        
        
    }
}
