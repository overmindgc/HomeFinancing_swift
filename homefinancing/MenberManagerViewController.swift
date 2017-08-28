//
//  MenberManagerViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/14/16.
//  Copyright © 2016 wph. All rights reserved.
//

class MenberManagerViewController: HFBaseViewController,UITableViewDelegate,UITableViewDataSource {

    let tableCellIndentifierItem = "tableCellIndentifierItem"
    
    @IBOutlet weak var tableView: HFBaseTableView!
    
    var tableSource = [MemberModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshTalbeData()
    }
    
    func refreshTalbeData() {
        tableSource = MemberStorageService.sharedInstance.getAllMemberList()
        
        tableView.reloadData()
    }
    
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }
    //绘制cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let itemCell = MemberTableCell(style: UITableViewCellStyle.default, reuseIdentifier: tableCellIndentifierItem)
        itemCell.accessoryType = UITableViewCellAccessoryType.none
        
        let memberModel = tableSource[row]
        itemCell.memberModel = memberModel
        itemCell.editClosure = editMember
        if memberModel.totalPay != nil {
            itemCell.payAmountLabel?.text = "累计消费：" + memberModel.totalPay!
        } else {
            itemCell.payAmountLabel?.text = "累计消费：0"
        }
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCell:HFTableViewCell = tableView.cellForRow(at: indexPath) as! HFTableViewCell
        currCell.isSelected = false
        
    }
    
    //每个cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return memberCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView:UIView = UIView(frame: CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: memberCellHeight))
        let padding:CGFloat = 20
        let addButton:MemberAddButton = MemberAddButton(frame: CGRect(x: padding,y: padding,width: SCREEN_WIDTH - padding * 2,height: 45))
        addButton.addTarget(self, action: #selector(self.addMemberAction), for: UIControlEvents.touchUpInside)
        bgView.addSubview(addButton)
        
        return bgView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  UITableViewCellEditingStyle.delete {
            let currModel = tableSource[indexPath.row]
            //创建alert
            let alertView = YoYoAlertView(title: "提醒", message: "确定要删除此成员吗？（删除后该成员原来发生的账单将归属到全家）", cancelButtonTitle: "取 消", sureButtonTitle: "确 定")
            //调用显示
            alertView.show()
            //获取点击事件
            alertView.clickIndexClosure { (index) in
                if index == 2 {
                    MemberStorageService.sharedInstance.deleteMemberWithId(currModel.id!)
                    self.refreshTalbeData()
                }
            }
        }
    }
    
    func addMemberAction() {
        //创建alert
        let alertView = YoYoInputAlertView(title: "填写成员名称", message: "", cancelButtonTitle: "取 消", sureButtonTitle: "确 定")
        //调用显示
        alertView.show()
        //获取点击事件
        alertView.clickIndexClosure { (index,contentText) in
            if index == 2 {
                let newMemberModel = MemberModel()
                newMemberModel.id = String(Date().timeIntervalSince1970)
                newMemberModel.name = contentText
                MemberStorageService.sharedInstance.saveMemberModel(newMemberModel)
                self.refreshTalbeData()
            }
        }
    }
    
    func editMember(_ model:MemberModel) {
        //创建alert
        let alertView = YoYoInputAlertView(title: "修改成员名称", message: model.name, cancelButtonTitle: "取 消", sureButtonTitle: "确 定")
        //调用显示
        alertView.show()
        //获取点击事件
        alertView.clickIndexClosure { (index,contentText) in
            if index == 2 {
                MemberStorageService.sharedInstance.editMemberNameWithId(model.id!, memberName: contentText)
                self.refreshTalbeData()
            }
        }
    }
}
