//
//  KDCircularProgress.swift
//  KDCircularProgress
//
//  Created by Kaan Dedeoglu on 1/14/15.
//  Copyright (c) 2015 Kaan Dedeoglu. All rights reserved.
//

import UIKit

public enum KDCircularProgressGlowMode {
    case forward, reverse, constant, noGlow
}

@IBDesignable
open class KDCircularProgress: UIView {
    
    fileprivate struct ConversionFunctions {
        static func DegreesToRadians (_ value:CGFloat) -> CGFloat {
            return value * CGFloat(M_PI) / 180.0
        }
        
        static func RadiansToDegrees (_ value:CGFloat) -> CGFloat {
            return value * 180.0 / CGFloat(M_PI)
        }
    }
    
    fileprivate struct UtilityFunctions {
        static func Clamp<T: Comparable>(_ value: T, minMax: (T, T)) -> T {
            let (min, max) = minMax
            if value < min {
                return min
            } else if value > max {
                return max
            } else {
                return value
            }
        }
        
        static func InverseLerp(_ value: CGFloat, minMax: (CGFloat, CGFloat)) -> CGFloat {
            return (value - minMax.0) / (minMax.1 - minMax.0)
        }
        
        static func Lerp(_ value: CGFloat, minMax: (CGFloat, CGFloat)) -> CGFloat {
            return (minMax.1 - minMax.0) * value + minMax.0
        }
        
        static func ColorLerp(_ value: CGFloat, minMax: (UIColor, UIColor)) -> UIColor {
            let clampedValue = Clamp(value, minMax: (0, 1))
            
            let zero: CGFloat = 0
            
            var (r0, g0, b0, a0) = (zero, zero, zero, zero)
            minMax.0.getRed(&r0, green: &g0, blue: &b0, alpha: &a0)
            
            var (r1, g1, b1, a1) = (zero, zero, zero, zero)
            minMax.1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            
            return UIColor(red: Lerp(clampedValue, minMax: (r0, r1)), green: Lerp(clampedValue, minMax: (g0, g1)), blue: Lerp(clampedValue, minMax: (b0, b1)), alpha: Lerp(clampedValue, minMax: (a0, a1)))
        }
        
        static func Mod(_ value: Int, range: Int, minMax: (Int, Int)) -> Int {
            let (min, max) = minMax
            assert(abs(range) <= abs(max - min), "range should be <= than the interval")
            if value >= min && value <= max {
                return value
            } else if value < min {
                return Mod(value + range, range: range, minMax: minMax)
            } else {
                return Mod(value - range, range: range, minMax: minMax)
            }
        }
    }
    
    fileprivate var progressLayer: KDCircularProgressViewLayer! {
        get {
            return layer as! KDCircularProgressViewLayer
        }
    }
    
    fileprivate var radius: CGFloat! {
        didSet {
            progressLayer.radius = radius
        }
    }
    
    @IBInspectable open var angle: Int = 0 {
        didSet {
            if self.isAnimating() {
                self.pauseAnimation()
            }
            progressLayer.angle = angle
        }
    }
    
    @IBInspectable open var startAngle: Int = 0 {
        didSet {
            progressLayer.startAngle = UtilityFunctions.Mod(startAngle, range: 360, minMax: (0,360))
            progressLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var clockwise: Bool = true {
        didSet {
            progressLayer.clockwise = clockwise
            progressLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var roundedCorners: Bool = true {
        didSet {
            progressLayer.roundedCorners = roundedCorners
        }
    }
    
    @IBInspectable open var lerpColorMode: Bool = false {
        didSet {
            progressLayer.lerpColorMode = lerpColorMode
        }
    }
    
    @IBInspectable open var gradientRotateSpeed: CGFloat = 0 {
        didSet {
            progressLayer.gradientRotateSpeed = gradientRotateSpeed
        }
    }
    
    @IBInspectable open var glowAmount: CGFloat = 1.0 {//Between 0 and 1
        didSet {
            progressLayer.glowAmount = UtilityFunctions.Clamp(glowAmount, minMax: (0, 1))
        }
    }
    
    @IBInspectable open var glowMode: KDCircularProgressGlowMode = .forward {
        didSet {
            progressLayer.glowMode = glowMode
        }
    }
    
    @IBInspectable open var progressThickness: CGFloat = 0.4 {//Between 0 and 1
        didSet {
            progressThickness = UtilityFunctions.Clamp(progressThickness, minMax: (0, 1))
            progressLayer.progressThickness = progressThickness/2
        }
    }
    
    @IBInspectable open var trackThickness: CGFloat = 0.5 {//Between 0 and 1
        didSet {
            trackThickness = UtilityFunctions.Clamp(trackThickness, minMax: (0, 1))
            progressLayer.trackThickness = trackThickness/2
        }
    }
    
    @IBInspectable open var trackColor: UIColor = UIColor.black {
        didSet {
            progressLayer.trackColor = trackColor
            progressLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var progressInsideFillColor: UIColor? = nil {
        didSet {
            if let color = progressInsideFillColor {
                progressLayer.progressInsideFillColor = color
            } else {
                progressLayer.progressInsideFillColor = UIColor.clear
            }
        }
    }
    
    @IBInspectable open var progressColors: [UIColor]! {
        get {
            return progressLayer.colorsArray
        }
        
        set(newValue) {
            setColors(newValue)
        }
    }
    
    //These are used only from the Interface-Builder. Changing these from code will have no effect.
    //Also IB colors are limited to 3, whereas programatically we can have an arbitrary number of them.
    @objc @IBInspectable fileprivate var IBColor1: UIColor?
    @objc @IBInspectable fileprivate var IBColor2: UIColor?
    @objc @IBInspectable fileprivate var IBColor3: UIColor?
    
    
    fileprivate var animationCompletionBlock: ((Bool) -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setInitialValues()
        refreshValues()
        checkAndSetIBColors()
    }
    
    convenience public init(frame:CGRect, colors: UIColor...) {
        self.init(frame: frame)
        setColors(colors)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        setInitialValues()
        refreshValues()
    }
    
    open override func awakeFromNib() {
        checkAndSetIBColors()
    }
    
    override open class var layerClass : AnyClass {
        return KDCircularProgressViewLayer.self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        radius = (frame.size.width/2.0) * 0.8
    }
    
    fileprivate func setInitialValues() {
        radius = (frame.size.width/2.0) * 0.8 //We always apply a 20% padding, stopping glows from being clipped
        backgroundColor = .clear
        setColors(UIColor.white, UIColor.red)
    }
    
    fileprivate func refreshValues() {
        progressLayer.angle = angle
        progressLayer.startAngle = UtilityFunctions.Mod(startAngle, range: 360, minMax: (0,360))
        progressLayer.clockwise = clockwise
        progressLayer.roundedCorners = roundedCorners
        progressLayer.lerpColorMode = lerpColorMode
        progressLayer.gradientRotateSpeed = gradientRotateSpeed
        progressLayer.glowAmount = UtilityFunctions.Clamp(glowAmount, minMax: (0, 1))
        progressLayer.glowMode = glowMode
        progressLayer.progressThickness = progressThickness/2
        progressLayer.trackColor = trackColor
        progressLayer.trackThickness = trackThickness/2
    }
    
    fileprivate func checkAndSetIBColors() {
        let nonNilColors = [IBColor1, IBColor2, IBColor3].filter { $0 != nil}.map { $0! }
        if nonNilColors.count > 0 {
            setColors(nonNilColors)
        }
    }
    
    open func setColors(_ colors: UIColor...) {
        setColors(colors)
    }
    
    fileprivate func setColors(_ colors: [UIColor]) {
        progressLayer.colorsArray = colors
        progressLayer.setNeedsDisplay()
    }
    
    open func animateFromAngle(_ fromAngle: Int, toAngle: Int, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
        if isAnimating() {
            pauseAnimation()
        }
        
        let animationDuration: TimeInterval
        if relativeDuration {
            animationDuration = duration
        } else {
            let traveledAngle = UtilityFunctions.Mod(toAngle - fromAngle, range: 360, minMax: (0, 360))
            let scaledDuration = (TimeInterval(traveledAngle) * duration) / 360
            animationDuration = scaledDuration
        }
        
        let animation = CABasicAnimation(keyPath: "angle")
        animation.fromValue = fromAngle
        animation.toValue = toAngle
        animation.duration = animationDuration
        animation.delegate = self as? CAAnimationDelegate
        angle = toAngle
        animationCompletionBlock = completion
        
        progressLayer.add(animation, forKey: "angle")
    }
    
    open func animateToAngle(_ toAngle: Int, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
        if isAnimating() {
            pauseAnimation()
        }
        animateFromAngle(angle, toAngle: toAngle, duration: duration, relativeDuration: relativeDuration, completion: completion)
    }
    
    open func pauseAnimation() {
        guard let presentationLayer = progressLayer.presentation() else { return }
        let currentValue = presentationLayer.angle
        progressLayer.removeAllAnimations()
        animationCompletionBlock = nil
        angle = currentValue
    }
    
    open func stopAnimation() {
        progressLayer.removeAllAnimations()
        angle = 0
    }
    
    open func isAnimating() -> Bool {
        return progressLayer.animation(forKey: "angle") != nil
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let completionBlock = animationCompletionBlock {
            completionBlock(flag)
            animationCompletionBlock = nil
        }
    }
    
    open override func didMoveToWindow() {
        if let window = window {
            progressLayer.contentsScale = window.screen.scale
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil && isAnimating() {
            pauseAnimation()
        }
    }
    
    open override func prepareForInterfaceBuilder() {
        setInitialValues()
        refreshValues()
        checkAndSetIBColors()
        progressLayer.setNeedsDisplay()
    }
    
    fileprivate class KDCircularProgressViewLayer: CALayer {
        @NSManaged var angle: Int
        var radius: CGFloat! {
            didSet {
                invalidateGradientCache()
            }
        }
        var startAngle: Int!
        var clockwise: Bool! {
            didSet {
                if clockwise != oldValue {
                    invalidateGradientCache()
                }
            }
        }
        var roundedCorners: Bool!
        var lerpColorMode: Bool!
        var gradientRotateSpeed: CGFloat! {
            didSet {
                invalidateGradientCache()
            }
        }
        var glowAmount: CGFloat!
        var glowMode: KDCircularProgressGlowMode!
        var progressThickness: CGFloat!
        var trackThickness: CGFloat!
        var trackColor: UIColor!
        var progressInsideFillColor: UIColor = UIColor.clear
        var colorsArray: [UIColor]! {
            didSet {
                invalidateGradientCache()
            }
        }
        fileprivate var gradientCache: CGGradient?
        fileprivate var locationsCache: [CGFloat]?
        
        fileprivate struct GlowConstants {
            fileprivate static let sizeToGlowRatio: CGFloat = 0.00015
            static func glowAmountForAngle(_ angle: Int, glowAmount: CGFloat, glowMode: KDCircularProgressGlowMode, size: CGFloat) -> CGFloat {
                switch glowMode {
                case .forward:
                    return CGFloat(angle) * size * sizeToGlowRatio * glowAmount
                case .reverse:
                    return CGFloat(360 - angle) * size * sizeToGlowRatio * glowAmount
                case .constant:
                    return 360 * size * sizeToGlowRatio * glowAmount
                default:
                    return 0
                }
            }
        }
        
        override class func needsDisplay(forKey key: String) -> Bool {
            return key == "angle" ? true : super.needsDisplay(forKey: key)
        }
        
        override init(layer: Any) {
            super.init(layer: layer)
            let progressLayer = layer as! KDCircularProgressViewLayer
            radius = progressLayer.radius
            angle = progressLayer.angle
            startAngle = progressLayer.startAngle
            clockwise = progressLayer.clockwise
            roundedCorners = progressLayer.roundedCorners
            lerpColorMode = progressLayer.lerpColorMode
            gradientRotateSpeed = progressLayer.gradientRotateSpeed
            glowAmount = progressLayer.glowAmount
            glowMode = progressLayer.glowMode
            progressThickness = progressLayer.progressThickness
            trackThickness = progressLayer.trackThickness
            trackColor = progressLayer.trackColor
            colorsArray = progressLayer.colorsArray
            progressInsideFillColor = progressLayer.progressInsideFillColor
        }
        
        override init() {
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func draw(in ctx: CGContext) {
            UIGraphicsPushContext(ctx)
            let rect = bounds
            let size = rect.size
            
            let trackLineWidth: CGFloat = radius * trackThickness
            let progressLineWidth = radius * progressThickness
            let arcRadius = max(radius - trackLineWidth/2, radius - progressLineWidth/2)
//            CGContextAddArc(ctx, CGFloat(size.width/2.0), CGFloat(size.height/2.0), arcRadius, 0, CGFloat(M_PI * 2), 0)
            ctx.addArc(center: CGPoint(x:CGFloat(size.width/2.0),y:CGFloat(size.height/2.0)), radius: arcRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
            trackColor.set()
            ctx.setStrokeColor(trackColor.cgColor)
            ctx.setFillColor(progressInsideFillColor.cgColor)
            ctx.setLineWidth(trackLineWidth)
            ctx.setLineCap(CGLineCap.butt)
            ctx.drawPath(using: .fillStroke)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let imageCtx = UIGraphicsGetCurrentContext()
            let reducedAngle = UtilityFunctions.Mod(angle, range: 360, minMax: (0, 360))
            let fromAngle = ConversionFunctions.DegreesToRadians(CGFloat(-startAngle))
            let toAngle = ConversionFunctions.DegreesToRadians(CGFloat((clockwise == true ? -reducedAngle : reducedAngle) - startAngle))
//            CGContextAddArc(imageCtx, CGFloat(size.width/2.0),CGFloat(size.height/2.0), arcRadius, fromAngle, toAngle, clockwise == true ? 1 : 0)
            
            
            ctx.addArc(center: CGPoint(x:CGFloat(size.width/2.0),y:CGFloat(size.height/2.0)), radius: arcRadius, startAngle: fromAngle, endAngle: toAngle, clockwise: clockwise)
            let glowValue = GlowConstants.glowAmountForAngle(reducedAngle, glowAmount: glowAmount, glowMode: glowMode, size: size.width)
            if glowValue > 0 {
                imageCtx?.setShadow(offset: CGSize.zero, blur: glowValue, color: UIColor.black.cgColor)
            }
            imageCtx?.setLineCap(roundedCorners == true ? .round : .butt)
            imageCtx?.setLineWidth(progressLineWidth)
            imageCtx?.drawPath(using: .stroke)
            
            let drawMask: CGImage = UIGraphicsGetCurrentContext()!.makeImage()!
            UIGraphicsEndImageContext()
            
            ctx.saveGState()
            ctx.clip(to: bounds, mask: drawMask)
            
            //Gradient - Fill
            if !lerpColorMode && colorsArray.count > 1 {
                var componentsArray: [CGFloat] = []
                let rgbColorsArray: [UIColor] = colorsArray.map {c in // Make sure every color in colors array is in RGB color space
                    if c.cgColor.numberOfComponents == 2 {
                        let whiteValue = c.cgColor.components?[0]
                        return UIColor(red: whiteValue!, green: whiteValue!, blue: whiteValue!, alpha: 1.0)
                    } else {
                        return c
                    }
                }
                
                for color in rgbColorsArray {
                    let colorComponents: [CGFloat] = color.cgColor.components!
                    componentsArray.append(contentsOf: [colorComponents[0],colorComponents[1],colorComponents[2],1.0])
                }
                
                drawGradientWithContext(ctx, componentsArray: componentsArray)
            } else {
                
                var color: UIColor! = nil
                if colorsArray.count == 0 {
                    color = UIColor.white
                } else if colorsArray.count == 1 {
                    color = colorsArray[0]
                } else {
                    
                    // lerpColorMode is true
                    
                    let t = CGFloat(reducedAngle) / 360
                    let steps = colorsArray.count - 1;
                    let step = 1 / CGFloat(steps);
                    for i in 1...steps {
                        let fi = CGFloat(i)
                        if (t <= fi * step || i == steps) {
                            let colorT = UtilityFunctions.InverseLerp(t, minMax: ((fi - 1) * step, fi * step))
                            color = UtilityFunctions.ColorLerp(colorT, minMax: (colorsArray[i - 1], colorsArray[i]));
                            break;
                        }
                    }
                }
                
                fillRectWithContext(ctx, color: color)
            }
            ctx.restoreGState()
            UIGraphicsPopContext()
        }
        
        fileprivate func fillRectWithContext(_ ctx: CGContext!, color: UIColor) {
            ctx.setFillColor(color.cgColor)
            ctx.fill(bounds)
        }
        
        fileprivate func drawGradientWithContext(_ ctx: CGContext!, componentsArray: [CGFloat]) {
            let baseSpace = CGColorSpaceCreateDeviceRGB()
            let locations = locationsCache ?? gradientLocationsFromColorCount(componentsArray.count/4, gradientWidth: bounds.size.width)
            let gradient: CGGradient
            
            if let g = self.gradientCache {
                gradient = g
            } else {
                guard let g = CGGradient(colorSpace: baseSpace, colorComponents: componentsArray, locations: locations,count: componentsArray.count / 4) else { return }
                self.gradientCache = g
                gradient = g
            }
            
            let halfX = bounds.size.width/2.0
            let floatPi = CGFloat(M_PI)
            let rotateSpeed = clockwise == true ? gradientRotateSpeed : gradientRotateSpeed * -1
            let angleInRadians = ConversionFunctions.DegreesToRadians(rotateSpeed! * CGFloat(angle) - 90)
            let oppositeAngle = angleInRadians > floatPi ? angleInRadians - floatPi : angleInRadians + floatPi
            
            let startPoint = CGPoint(x: (cos(angleInRadians) * halfX) + halfX, y: (sin(angleInRadians) * halfX) + halfX)
            let endPoint = CGPoint(x: (cos(oppositeAngle) * halfX) + halfX, y: (sin(oppositeAngle) * halfX) + halfX)
            
            ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        }
        
        fileprivate func gradientLocationsFromColorCount(_ colorCount: Int, gradientWidth: CGFloat) -> [CGFloat] {
            if colorCount == 0 || gradientWidth == 0 {
                return []
            } else {
                var locationsArray: [CGFloat] = []
                let progressLineWidth = radius * progressThickness
                let firstPoint = gradientWidth/2 - (radius - progressLineWidth/2)
                let increment = (gradientWidth - (2*firstPoint))/CGFloat(colorCount - 1)
                
                for i in 0..<colorCount {
                    locationsArray.append(firstPoint + (CGFloat(i) * increment))
                }
                assert(locationsArray.count == colorCount, "color counts should be equal")
                let result = locationsArray.map { $0 / gradientWidth }
                locationsCache = result
                return result
            }
        }
        
        fileprivate func invalidateGradientCache() {
            gradientCache = nil
            locationsCache = nil
        }
    }
}
