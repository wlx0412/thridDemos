//
//  CountDownBtn.swift
//  WLXUtils
//
//  Created by wlx on 2020/11/30.
//

import UIKit

/**
 动画类型
 */
enum CountDownAnimationType {
    case None       //没有动画
    case Scale      //缩放动画
    case Rotate     //旋转动画
}

/// 自定义倒计时按钮
@IBDesignable class CountDownBtn: UIButton {
    /// 倒计时中的背景颜色
    @IBInspectable var enabled_bgColor: UIColor = UIColor.clear
    /// 倒计时时数字颜色
    @IBInspectable var numberColor :UIColor = UIColor.black{
        didSet{
            timeLabel.textColor = numberColor
        }
    }
    /// 时间长度(秒)
    @IBInspectable var count :Int = 0 {
        didSet{
            startCount = count
            originNum = count
        }
    }
    /// 动画类型,默认没有动画
    var animaType: CountDownAnimationType = CountDownAnimationType.None
    
    override var frame: CGRect {
        set{
            super.frame = newValue
            timeLabel.frame = Size.kAdaptRect(rect: frame)
        }
        get{
            return super.frame
        }
    }
    override var backgroundColor: UIColor?{
        set{
            super.backgroundColor = newValue
            if normalBgColor == nil {
                normalBgColor = backgroundColor
            }
        }
        get{
            return super.backgroundColor
        }
    }
    private var btnTitle :String?
    private var normalBgColor: UIColor?
    private var timer: Timer!
    private var startCount = 0
    private var originNum = 0
    //倒计时Label
    private var timeLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        btnTitle = self.title(for: .normal)
        self.addLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        btnTitle = self.title(for: .normal)
        self.addLabel()
    }
    private func addLabel() {
        timeLabel.frame = CGRect(x: 0, y: 0, width: Size.kAdaptWidth(self.frame.width) , height: Size.kAdaptHeight(self.frame.height) )
            //CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.font = UIFont.font14
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.textColor = numberColor
        timeLabel.text = ""
        self.addSubview(timeLabel)
    }
    
    /**
     开启倒计时
     */
    func startCountDown() {
        //设置为按钮字号在addLabel()会失败
        timeLabel.font = self.titleLabel?.font
        timeLabel.text = "\(self.originNum)秒重新获取"
        self.setTitle("", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountDownBtn.countDown), userInfo: nil, repeats: true)
        self.backgroundColor = enabled_bgColor
        self.isEnabled = false
        switch self.animaType {
        case .Scale:
            self.numAnimation()
        case .Rotate:
            self.rotateAnimation()
        default:
            return
        }
    }
    //    倒计时开始
    @objc private func countDown() {
        self.startCount -= 1
        timeLabel.text = "\(self.startCount)秒重新获取"
        
        //倒计时完成后停止定时器，移除动画
        if self.startCount <= 0 {
            if self.timer == nil {
                return
            }
            self.setTitle(btnTitle, for: .normal)
            timeLabel.layer.removeAllAnimations()
            timeLabel.text = ""
            self.timer.invalidate()
            self.timer = nil
            self.isEnabled = true
            self.startCount = self.originNum
            self.backgroundColor = normalBgColor
        }
    }
    
    //放大动画
    private func numAnimation() {
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 1.5, 2]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.5, 0]
        opacityAnimaton.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimaton]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        animation.beginTime = beginTime
        timeLabel.layer.add(animation, forKey: "animation")
        self.layer.addSublayer(timeLabel.layer)
        
    }
    
    //    旋转变小动画
    private func rotateAnimation() {
        
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        
        // Rotate animation
        let rotateAnimation  = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = NSNumber(value: 0)
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotateAnimation.duration = duration;
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0]
        scaleAnimation.values = [1, 2]
        scaleAnimation.duration = 0
        
        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimaton.keyTimes = [0, 0.5]
        opacityAnimaton.values = [1, 0]
        opacityAnimaton.duration = duration
        
        // Scale animation
        let scaleAnimation2 = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation2.keyTimes = [0, 0.5]
        scaleAnimation2.values = [2, 0]
        scaleAnimation2.duration = duration
        
        let animation = CAAnimationGroup()
        
        animation.animations = [rotateAnimation, scaleAnimation, opacityAnimaton, scaleAnimation2]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.beginTime = beginTime
        timeLabel.layer.add(animation, forKey: "animation")
        self.layer.addSublayer(timeLabel.layer)
    }
}
