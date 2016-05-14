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
    
    typealias editButtonCLickClosure = (model:MemberModel) -> Void
    internal var editClosure:editButtonCLickClosure?
    
    let padding:CGFloat = 20
    
    internal var memberModel:MemberModel? {
        didSet {
            memberLabel?.text = memberModel?.name
            memberLabel?.sizeToFit()
            let labelRect:CGRect = (memberLabel?.frame)!
            memberLabel?.frame = CGRectMake(padding, memberCellHeight/2 - labelRect.size.height/2, labelRect.size.width, labelRect.size.height)
            editImageButton?.frame = CGRectMake(padding + labelRect.size.width, (editImageButton?.frame.origin.y)!, (editImageButton?.frame.size.width)!, (editImageButton?.frame.size.height)!)
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
        memberLabel = UILabel(frame: CGRectZero)
        memberLabel?.textColor = appGrayTextColor
        self.addSubview(memberLabel!)
        
        let editImage:UIImage = UIImage(named: "pen_gray")!
        editImageButton = UIButton(frame: CGRectMake(0, 0, 50, memberCellHeight))
        editImageButton?.setImage(editImage, forState: UIControlState.Normal)
        editImageButton?.addTarget(self, action: #selector(self.editActButtonClickAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(editImageButton!)
        
        let amountLabelWidth = SCREEN_WIDTH / 3 * 2
        payAmountLabel = UILabel(frame: CGRectMake(SCREEN_WIDTH - padding - amountLabelWidth,0,amountLabelWidth,memberCellHeight))
        payAmountLabel?.textColor = appGrayTextColor
        payAmountLabel?.font = UIFont.systemFontOfSize(14)
        payAmountLabel?.textAlignment = NSTextAlignment.Right
        payAmountLabel?.text = "累计消费：0"
        self.addSubview(payAmountLabel!)
        
        let lineView = UIView(frame: CGRectMake(padding,memberCellHeight - 1,SCREEN_WIDTH - padding,1))
        lineView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.addSubview(lineView)
    }
    
    func editActButtonClickAction() {
        if editClosure != nil {
            editClosure!(model: memberModel!)
        }
    }
    
}