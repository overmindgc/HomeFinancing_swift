//
//  YoYoAlertView.swift
//  AlertView_Swift
//
//  Created by YoYo on 16/5/6.
//  Copyright © 2016年 cn.yoyoy.mw. All rights reserved.
//

import UIKit

class YoYoInputAlertView: UIView {

    typealias clickAlertClosure = (_ index: Int,_ contentText:String) -> Void //声明闭包，点击按钮传值
    //把申明的闭包设置成属性
    var clickClosure: clickAlertClosure?
    //为闭包设置调用函数
    func clickIndexClosure(_ closure:clickAlertClosure?){
        //将函数指针赋值给myClosure闭包
        clickClosure = closure
    }
    let screen_width = UIScreen.main.bounds.size.width
    let screen_height = UIScreen.main.bounds.size.height
    let whiteView = UIView() //白色框
    let titleLabel = UILabel() //标题按钮
    let contentTextField = UITextField() //输入文本框
    var title = "" //标题
    var content = "" //内容
    let cancelBtn = UIButton() //取消按钮
    let sureBtn = UIButton() //确定按钮
//    let tap = UITapGestureRecognizer() //点击手势
    
    init(title: String?, message: String?, cancelButtonTitle: String?, sureButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        createAlertView()
        self.titleLabel.text = title
        self.contentTextField.text = message
        self.cancelBtn.setTitle(cancelButtonTitle, for: UIControlState())
        self.sureBtn.setTitle(sureButtonTitle, for: UIControlState())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:创建
    func createAlertView() {
        //布局
        self.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        tap.addTarget(self, action: #selector(YoYoAlertView.dismiss))
//        self.addGestureRecognizer(tap)
        //白底
        whiteView.frame = CGRect(x: 30, y: 100, width: screen_width - 60, height: 190)
        whiteView.backgroundColor = UIColor.white
        whiteView.layer.cornerRadius = 5
        whiteView.clipsToBounds = true
        self.addSubview(whiteView)
        let width = whiteView.frame.size.width
        //标题
        titleLabel.frame = CGRect(x: 0, y: 15, width: width, height: 25)
        titleLabel.textColor = RGB_Color(r: 66, g: 66, b: 66, a: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 19)
        titleLabel.textAlignment = .center
        whiteView.addSubview(titleLabel)
        //内容
        contentTextField.frame = CGRect(x: 20, y: 66, width: width - 40, height: 40)
        contentTextField.textColor = RGB_Color(r: 66, g: 66, b: 66, a: 1)
        contentTextField.font = UIFont.systemFont(ofSize: 17)
        contentTextField.placeholder = "请填写"
        contentTextField.borderStyle = UITextBorderStyle.roundedRect
        contentTextField.becomeFirstResponder()
        
        whiteView.addSubview(contentTextField)
        //取消按钮
        let btnWith = (width - 30) / 2
        cancelBtn.frame = CGRect(x: 10, y: 135, width: btnWith, height: 45)
        cancelBtn.backgroundColor = RGB_Color(r: 234, g: 234, b: 234, a: 1)
        cancelBtn.setTitleColor(RGB_Color(r: 150, g: 150, b: 150, a: 1), for: UIControlState())
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.clipsToBounds = true
        cancelBtn.tag = 1
        cancelBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        whiteView.addSubview(cancelBtn)
        //确认按钮
        sureBtn.frame = CGRect(x: btnWith + 20 , y: 135, width: btnWith, height: 45)
        sureBtn.backgroundColor = appPayColor
        sureBtn.setTitleColor(UIColor.white, for: UIControlState())
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        sureBtn.layer.cornerRadius = 3
        sureBtn.clipsToBounds = true
        sureBtn.tag = 2
        sureBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        whiteView.addSubview(sureBtn)
    }
    //MARK:按键的对应的方法
    func clickBtnAction(_ sender: UIButton) {
        if (clickClosure != nil) {
            clickClosure!(sender.tag,contentTextField.text!)
        }
        dismiss()
    }
    //MARK:消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.whiteView.alpha = 0
            self.alpha = 0
        }, completion: { (finish) -> Void in
            if finish {
                self.removeFromSuperview()
            }
        }) 
    }
    /** 指定视图实现方法 */
    func show() {
        let wind = UIApplication.shared.keyWindow
        self.alpha = 0
        wind?.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.alpha = 1
        })
    }
    //MARK: 转换颜色
    func RGB_Color(r: CGFloat, g:CGFloat, b:CGFloat, a: CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
