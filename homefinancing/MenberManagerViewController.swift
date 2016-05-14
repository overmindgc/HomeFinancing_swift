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
    
    var tableSource:Array<MemberModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshTalbeData()
    }
    
    func refreshTalbeData() {
        tableSource = MemberStorageService.sharedInstance.getAllMemberList()
        
        tableView.reloadData()
    }
    
    //每一块有多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }
    //绘制cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let itemCell = MemberTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableCellIndentifierItem)
        itemCell.accessoryType = UITableViewCellAccessoryType.None
        
        let memberModel = tableSource[row]
        itemCell.memberModel = memberModel
        itemCell.editClosure = editMember
        return itemCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currCell:HFTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! HFTableViewCell
        currCell.selected = false
        
    }
    
    //每个cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return memberCellHeight
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView:UIView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,memberCellHeight))
        let padding:CGFloat = 20
        let addButton:MemberAddButton = MemberAddButton(frame: CGRectMake(padding,padding,SCREEN_WIDTH - padding * 2,45))
        addButton.addTarget(self, action: #selector(self.addMemberAction), forControlEvents: UIControlEvents.TouchUpInside)
        bgView.addSubview(addButton)
        
        return bgView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle ==  UITableViewCellEditingStyle.Delete {
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
                newMemberModel.id = String(NSDate().timeIntervalSince1970)
                newMemberModel.name = contentText
                MemberStorageService.sharedInstance.saveMemberModel(newMemberModel)
                self.refreshTalbeData()
            }
        }
    }
    
    func editMember(model:MemberModel) {
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
