//
//  KDProgressExtension.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/14/16.
//  Copyright © 2016 wph. All rights reserved.
//

extension KDCircularProgress {
    func changeCircleValueWithDecimalPercent(percent:CGFloat) {
        let newAngle:Int = Int(360 * percent)
//        self.angle = newAngle
        self.animateToAngle(newAngle, duration: 0.5, completion: nil)
    }
}
