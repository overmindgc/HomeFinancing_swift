//
//  MemberTableCell.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/14/16.
//  Copyright © 2016 wph. All rights reserved.
//

let memberCellHeight:CGFloat = 60

class MemberTableCell: HFTableViewCell {

    internal var memberLabel:UILabel?
    internal var editImageButton:UIButton?
    internal var payAmountLabel:UILabel?
    
    typealias editButtonCLickClosure = (_ model:MemberModel) -> Void
    internal var editClosure:editButtonCLickClosure?
    
    let padding:CGFloat = 20
    
    internal var memberModel:MemberModel? {
        didSet {
            memberLabel?.text = memberModel?.name
            memberLabel?.sizeToFit()
            let labelRect:CGRect = (memberLabel?.frame)!
            memberLabel?.frame = CGRect(x: padding, y: memberCellHeight/2 - labelRect.size.height/2, width: labelRect.size.width, height: labelRect.size.height)
            editImageButton?.frame = CGRect(x: padding + labelRect.size.width, y: (editImageButton?.frame.origin.y)!, width: (editImageButton?.frame.size.width)!, height: (editImageButton?.frame.size.height)!)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initViews()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        memberLabel = UILabel(frame: CGRect.zero)
        memberLabel?.textColor = appGrayTextColor
        self.addSubview(memberLabel!)
        
        let editImage:UIImage = UIImage(named: "pen_gray")!
        editImageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: memberCellHeight))
        editImageButton?.setImage(editImage, for: UIControlState())
        editImageButton?.addTarget(self, action: #selector(self.editActButtonClickAction), for: UIControlEvents.touchUpInside)
        self.addSubview(editImageButton!)
        
        let amountLabelWidth = SCREEN_WIDTH / 3 * 2
        payAmountLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - padding - amountLabelWidth,y: 0,width: amountLabelWidth,height: memberCellHeight))
        payAmountLabel?.textColor = appGrayTextColor
        payAmountLabel?.font = UIFont.systemFont(ofSize: 14)
        payAmountLabel?.textAlignment = NSTextAlignment.right
        payAmountLabel?.text = "累计消费：0"
        self.addSubview(payAmountLabel!)
        
        let lineView = UIView(frame: CGRect(x: padding,y: memberCellHeight - 1,width: SCREEN_WIDTH - padding,height: 1))
        lineView.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(lineView)
    }
    
    func editActButtonClickAction() {
        if editClosure != nil {
            editClosure!(memberModel!)
        }
    }
    
}
