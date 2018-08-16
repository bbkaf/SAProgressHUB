//
//  SAProgressHUB.swift
//  SuperHelper
//
//  Created by HankTseng on 2018/7/15.
//  Copyright © 2018年 Hyer bbkaf. All rights reserved.
//

import UIKit

/// The progress indicator type
@objc public enum HyProgressType: Int {
    
    /// Little spinner just like UIActivityIndicator
    case simple
    
    /**
     Use customer gif for progress indicator.
     
     To set loading gif, you can use **hub.setLoadingGif =** `"`**loadingGif**`"`
     
     To set success gif, you can use **hub.setSuccesGif =** `"`**successGif**`"`
     
     To set fail gif, you can use **hub.setFailGif =** `"`**failGif**`"`
     */
    case gif
    
    /**
     Use customer Lottie file for progress indicator.
     
     To set loading Lottie, you can use **hub.setLoadingLottie = loadingLOTAnimationView**
     
     To set success Lottie, you can use **hub.setSuccesLottie = successLOTAnimationView**
     
     To set fail Lottie, you can use **hub.setFailLottie = failLOTAnimationView**
     */
    case lottie
    
    /// The dynamic circle like progress indicator.
    case progressCircle
}

/// The HUB background style.
@objc public enum HyProgressStyle: Int {
    /**
     The shadow black layer cover target view
     
     To set shadow color, you can use **hub.setBackgroundShadowColor = shadowColor**. (.black by default)
     
     To set shadow alpha, you can use **hub.setBackgroundShadowAlpha = shadowAlpha**. (0.7 by default)
     */
    case shadowBackground
    
    /**
     The blur effeck layer cover target view
     
     To set backgroundBlurStyle, you can use **hub.setBackgroundBlurStyle = blurEffectStyle**. (.dark by default)
     
     To set BackgroundBlurAlpha, you can use **hub.setBackgroundBlurAlpha = blurAlpha**. (1.0 by default)
     */
    case blurBackground
    
    /// Nothing cover target view
    case clear
}

/// Loading result.
@objc public enum DismissState: Int {
    case success
    case failure
}

/**
 The elegent HUB for iOS: **SAProgressHUB**
 
 - Gif supported
 - Lottie supported
 - Progress indicator supported
 - highly customized
 
 */
public class SAProgressHUB: UIView {
    
    /**
     Init SAProgressHUB with indicator type and background style.
     - parameter type: The progress indicator type.
     - parameter style: The HUB background style.
     */
    public init(type: HyProgressType, style: HyProgressStyle) {
        let tempFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        super.init(frame: tempFrame)
        self.style = style
        self.type = type
    }
    
    ///Do not implemented this methode.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * Determine whether to show progress persent (%) in the end of content label.
     *
     * To show progress persent, you can set hub.setProgressLabel = true.
     *
     * Default: false.
     */
    public var setProgressLabel: Bool = false
    
    /// Determine whether to show horizantal progress indicator slider bar at the buttom of Hub.
    public var setProgressSlider: Bool = false
    
    /// Set title color. (.white by default)
    public var setTitleColor: UIColor = .white
    
    /// Set gif image for loading.
    public var setLoadingGif: String? = nil
    
    /// Set gif image for loading success.
    public var setSuccessGif: String? = nil
    
    /// Set gif image for error situation.
    public var setFailureGif: String? = nil
    
    /// Set shadow color for HyProgressStyle.shadowBackground. (.black by default)
    public var setBackgroundShadowColor: UIColor = .black
    
    /// Set shadow alpha for HyProgressStyle.shadowBackground. (0.7 by default)
    public var setBackgroundShadowAlpha: CGFloat = 0.7
    
    /// Set the width of BlurEffectArea in the center of HUB. (120.0 by default)
    public var setMidAreaWidth: CGFloat = 120.0
    
    /// Set the height of BlurEffectArea in the center of HUB. (120.0 by default)
    public var setMidAreaHeight: CGFloat = 120.0
    
    ///Determine whether to show BlurEffectArea in the center of HUB. (false by default)
    public var setMidBlur: Bool = false
    
    /// Determine the UIBlurEffectStyle for BlurEffectArea. (.light by default)
    public var setMidBlurStyle: UIBlurEffectStyle = .light
    
    /// Set alpha for BlurEffectArea. (0.9 by default)
    public var setMidBlurAlpha: CGFloat = 0.9
    
    /// Cool feature, Just try it. (false by default)
    public var setDynamicBackgroundAlpha: Bool = false
    
    /// Set lottie animation for loading, you know lottie right? put LOTAnimationView for loading in here.
    public var setLoadingLottie: UIView? = nil
    
    /// Set lottie animation for success, you know lottie right? put LOTAnimationView for success in here.
    public var setSuccessLottie: UIView? = nil
    
    /// Set lottie animation for error, you know lottie right? put LOTAnimationView for error in here.
    public var setFailLottie: UIView? = nil
    
    /// Set the indicator icon width, e.g. lottie, gif, progress. (80.0 by default)
    public var setIconWidth: CGFloat = 80.0
    
    /// Set the indicator icon height, e.g. lottie, gif, progress. (80.0 by default)
    public var setIconHeight: CGFloat = 80.0
    
    
    
    
    /// Set blurEffect style for HyProgressStyle.blurBackground. (.dark by default)
    public var setBackgroundBlurStyle: UIBlurEffectStyle = .dark
    
    /// Set blurEffect alpha for HyProgressStyle.blurBackground. (1.0 by default)
    public var setBackgroundBlurAlpha: CGFloat = 1.0
    
    //internal property
    private var type: HyProgressType = .simple
    private var style: HyProgressStyle = .shadowBackground
    private var blurEffectView: UIVisualEffectView?
    private var shadowImage: UIImageView?
    private var midDialog: UIImageView?
    private var title: String?
    private var disableUserInteraction: Bool = true
    
    private var littleSpinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    private var midBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var showCircleProgressIndicator = false
    private var lottieAnimationView: UIView? = nil
    private var targetView: UIView? = nil
    private var progressImage = UIImageView()
    private var titleLabel = UILabel()
    private var innerProgressSlider = UIImageView()
    private var progressShapeLayer = CAShapeLayer()
    private var progressShapeOuterLayer = CAShapeLayer()
    private var progressSlider = UIImageView()
    
    private var setProgressSliderHeight: CGFloat = 2.0
    private var setProgressSliderWidth: CGFloat {
        return setMidAreaWidth - 14
    }
    private var setTitleWidth: CGFloat {
        return setMidAreaWidth - 8
    }
    
    /// To dismiss SAProgressHUB.
    ///
    /// - parameter view: The view which you want to dismiss SAProgressHUB
    /// - parameter with: The loading result (failure or success)
    /// - parameter after: Dismiss SAProgressHUB after few second
    /// - parameter complete: Call back after SAProgressHUB Dismissed
    @objc public func dismiss(in view: UIView?, with state: DismissState = .success, after: Double = 0.0, complete: (() -> Void)? = nil) {
        
        if let `view` = view {
            //            view.isUserInteractionEnabled = true
            self.frame = view.frame
            DispatchQueue.main.async {
                if state == .success {
                    if self.setSuccessGif != nil && self.setSuccessGif != self.setLoadingGif {
                        self.progressImage.image = UIImage.gif(name: self.setSuccessGif!)
                    } else if self.setSuccessGif == nil {
                        self.progressImage.image = UIImage.gif(name: "animat-checkmark-color", bundle: Bundle(for: SAProgressHUB.self))
                    }
                } else {
                    if self.setFailureGif != nil && self.setFailureGif != self.setLoadingGif {
                        self.progressImage.image = UIImage.gif(name: self.setFailureGif!)
                    } else if self.setFailureGif == nil {
                        self.progressImage.image = UIImage.gif(name: "animat-rocket-color", bundle: Bundle(for: SAProgressHUB.self))
                    }
                }
                
                if state == .success {
                    if self.setSuccessLottie != nil {
                        self.lottieAnimationView?.removeFromSuperview()
                        self.setSuccessLottie?.frame = CGRect(x: view.center.x - 40, y: view.center.y - 40, width: 80.0, height: 80.0)
                        view.addSubview(self.setSuccessLottie!)
                    } else if self.setSuccessLottie == nil {
                        self.progressImage.image = UIImage.gif(name: "animat-checkmark-color", bundle: Bundle(for: SAProgressHUB.self))
                        
                        
                    }
                } else {
                    if self.setFailLottie != nil {
                        self.lottieAnimationView?.removeFromSuperview()
                        self.setFailLottie?.frame = CGRect(x: view.center.x - 40, y: view.center.y - 40, width: 80.0, height: 80.0)
                        view.addSubview(self.setFailLottie!)
                    } else if self.setFailureGif == nil {
                        self.progressImage.image = UIImage.gif(name: "animat-rocket-color", bundle: Bundle(for: SAProgressHUB.self))
                    }
                }
            }
            
            let deadlineTime = DispatchTime.now() + after
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                view.isUserInteractionEnabled = true
                for i in view.subviews {
                    if let hub = i as? SAProgressHUB {
                        hub.removeFromSuperview()
                    }
                }
                if complete != nil {
                    complete!()
                }
            }
        }
    }
    
    /// Set the current progress persent on the SAProgressHUB
    ///
    /// - parameter view: The view which progress persent you want to set
    /// - parameter persent: The current progress persent (from 0.0 to 1.0)
    @objc public func setProgressPersent(in view: UIView?, persent: Double) {
        if let `view` = view {
            print(persent)
            DispatchQueue.main.async {
                
                if self.setDynamicBackgroundAlpha {
                    if self.setBackgroundShadowAlpha != 0.0 {
                        self.shadowImage?.alpha = (max(self.setBackgroundShadowAlpha - CGFloat(persent), 0.0) + 0.2)
                    }
                    if self.setBackgroundBlurAlpha != 0.0 {
                        self.blurEffectView?.alpha = (max(self.setBackgroundBlurAlpha - CGFloat(persent), 0.0) + 0.2)
                    }
                }
                
                if self.setProgressLabel {
                    let progressInt = Int(persent * 100.0)
                    self.titleLabel.text = "\(self.title ?? "")(\(progressInt)%)"
                }
                
                if self.setProgressSlider {
                    let progressInt = Int(persent * 100.0)
                    let progressPersent = CGFloat(progressInt) / 100 * self.setProgressSliderWidth
                    self.innerProgressSlider.frame = CGRect(x: view.center.x - self.setProgressSliderWidth/2, y: view.center.y + (self.setMidAreaHeight/2)+4, width: progressPersent, height: self.setProgressSliderHeight)
                }
                
                if self.showCircleProgressIndicator {
                    let progressInt = Int(persent * 100.0)
                    let circlePersent = Double(progressInt) / 100 * 2
                    
                    let center = CGPoint(x: view.center.x, y: view.center.y)
                    let radius = CGFloat(20)
                    let startAngle = CGFloat(-Double.pi * 0.5)
                    let endAngle = CGFloat(Double.pi * circlePersent - Double.pi * 0.5)
                    let path = UIBezierPath()
                    path.move(to: center)
                    path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                    path.close()
                    path.fill()
                    self.progressShapeLayer.path = path.cgPath
                }
            }
        }
    }
    
    private func setupUI(_ title: String?, view: UIView?, isUserInteractionEnabled: Bool) {
        if let `view` = view {
            self.frame = view.frame
            view.isUserInteractionEnabled = isUserInteractionEnabled
            serBlurEffectView()
            if self.type == .gif {
                setGif()
            }
            
            if self.type == .lottie {
                setLottie()
            }
            
            setTheTitle(title: title)
            
            
            setTheProgressSlider()
            setTheProgressPie()
        }
    }
    
    private func setGif() {
        ///gif image
        if setLoadingGif != nil {
            progressImage.image = UIImage.gif(name: setLoadingGif!)
            progressImage.frame = CGRect(x: self.center.x - setIconWidth/2, y: self.center.y - setIconHeight/2, width: setIconWidth, height: setIconHeight)
        } else {
            //            let path = Bundle(for: SAProgressHUB.self).resourcePath! + "/demoGif.bundle"
            progressImage.image = UIImage.gif(name: "animat-pencil-color", bundle: Bundle(for: SAProgressHUB.self))
            progressImage.frame = CGRect(x: self.center.x - setIconWidth/2, y: self.center.y - setIconHeight/2, width: setIconWidth, height: setIconHeight)
        }
    }
    
    private func setLottie() {
        ///lottie
        if setLoadingLottie != nil {
            lottieAnimationView = setLoadingLottie
            lottieAnimationView?.frame = CGRect(x: self.center.x - setIconWidth/2, y: self.center.y - setIconHeight/2, width: setIconWidth, height: setIconHeight)
        } else {
            //            let path = Bundle(for: SAProgressHUB.self).resourcePath! + "/demoGif.bundle"
            progressImage.image = UIImage.gif(name: "animat-rocket-color", bundle: Bundle(for: SAProgressHUB.self))
            progressImage.frame = CGRect(x: self.center.x - setIconWidth/2, y: self.center.y - setIconHeight/2, width: setIconWidth, height: setIconHeight)
        }
    }
    
    private func setTheTitle(title: String?) {
        ///title
        titleLabel = UILabel(frame: CGRect(x: self.center.x - setTitleWidth/2, y: self.center.y + (setMidAreaHeight/2)+2-44, width: setTitleWidth, height: 44.0))
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        ///progressLabel
        titleLabel.textColor = self.setTitleColor
        self.title = title
        titleLabel.text = self.title
        
    }
    
    private func setTheProgressPie() {
        ///progressCircle inner
        let center = CGPoint(x: self.center.x, y: self.center.y)
        let radius = CGFloat(20)
        let startAngle = CGFloat(-Double.pi * 0.5)
        let endAngle = CGFloat(Double.pi * 0 - Double.pi * 0.5)
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        
        progressShapeLayer = CAShapeLayer()
        progressShapeLayer.path = path.cgPath
        
        //change the fill color
        if self.setBackgroundBlurStyle == .dark {
            progressShapeLayer.fillColor = UIColor.lightGray.cgColor
            //you can change the stroke color
            progressShapeLayer.strokeColor = UIColor.lightGray.cgColor
            //you can change the line width
            progressShapeLayer.lineWidth = 0.0
        } else {
            progressShapeLayer.fillColor = UIColor.white.withAlphaComponent(0.85).cgColor
            //you can change the stroke color
            progressShapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.85).cgColor
            //you can change the line width
            progressShapeLayer.lineWidth = 0.0
        }
        
        
        ///progressCircle outer
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.center.x,y: self.center.y), radius: CGFloat(22), startAngle: CGFloat(-Double.pi * 0.5), endAngle:CGFloat(Double.pi * 1.5), clockwise: true)
        progressShapeOuterLayer = CAShapeLayer()
        progressShapeOuterLayer.path = circlePath.cgPath
        progressShapeOuterLayer.fillColor = UIColor.black.withAlphaComponent(0.4).cgColor
        progressShapeOuterLayer.strokeColor = UIColor.black.withAlphaComponent(0.4).cgColor
        progressShapeOuterLayer.lineWidth = 0
    }
    
    private func setTheProgressSlider() {
        ///progressSlider
        progressSlider = UIImageView(frame: CGRect(x: self.center.x - setProgressSliderWidth/2, y: self.center.y + (setMidAreaHeight/2)+4, width: setProgressSliderWidth, height: setProgressSliderHeight))
        progressSlider.layer.cornerRadius = 3.0
        progressSlider.backgroundColor = UIColor.darkGray
        
        innerProgressSlider = UIImageView(frame: CGRect(x: self.center.x - setProgressSliderWidth/2, y: self.center.y + setTitleWidth/2, width: 0, height: setProgressSliderHeight))
        innerProgressSlider.layer.cornerRadius = 1.0
        innerProgressSlider.backgroundColor = UIColor.lightGray
    }
    
    private func serBlurEffectView() {
        let blurEffect = UIBlurEffect(style: setBackgroundBlurStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = self.frame
        blurEffectView?.alpha = setBackgroundBlurAlpha
        
        shadowImage = UIImageView(frame: self.frame)
        shadowImage?.backgroundColor = UIColor.black.withAlphaComponent(setBackgroundShadowAlpha)
        
        littleSpinner.center = self.center
        littleSpinner.startAnimating()
        
        midBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: setMidBlurStyle))
        midBlurEffectView.frame = CGRect(x: self.center.x - setMidAreaWidth/2, y: self.center.y - setMidAreaHeight/2, width: setMidAreaWidth, height: setMidAreaHeight)
        midBlurEffectView.clipsToBounds = true
        midBlurEffectView.layer.cornerRadius = 12
        midBlurEffectView.alpha = self.setMidBlurAlpha
    }
    
    private func setProgressStyle() {
        ///style setting
        switch self.style {
        case .shadowBackground:
            self.addSubview(self.shadowImage!)
        case .blurBackground:
            self.addSubview(self.blurEffectView!)
        case .clear:
            break
        }
        
        if self.setMidBlur {
            self.addSubview(self.midBlurEffectView)
        }
    }
    
    private func setProgressType() {
        
        ///type setting
        switch self.type {
        case .simple:
            self.addSubview(self.littleSpinner)
        case .gif:
            self.addSubview(self.progressImage)
        case .lottie:
            if self.lottieAnimationView != nil {
                self.addSubview(self.lottieAnimationView!)
            } else {
                self.addSubview(self.progressImage)
            }
        case .progressCircle:
            self.showCircleProgressIndicator = true
            self.layer.addSublayer(self.progressShapeOuterLayer)
            self.layer.addSublayer(self.progressShapeLayer)
            
        }
        
        ///customer setting
        if self.setProgressSlider {
            self.addSubview(self.progressSlider)
            self.addSubview(self.innerProgressSlider)
        }
        
        
        
        ///title for all type
        self.addSubview(self.titleLabel)
        
    }
    
    /// Show SAProgressHUB on specific view.
    ///
    /// - parameter view:        The view which need a HUB.
    /// - parameter title:       The title told user what are they waiting for. `""` by default.
    /// - parameter isUserInteractionEnabled: Determine whether block UserInteraction or not. `false` by default.
    ///
    @objc public func show(in view: UIView?, title: String? = "", isUserInteractionEnabled: Bool = false) {
        if let `view` = view {
            setupUI(title, view: view, isUserInteractionEnabled: isUserInteractionEnabled)
            var isAdded = false
            for i in view.subviews {
                if let _ = i as? SAProgressHUB {
                    isAdded = true
                }
            }
            
            DispatchQueue.main.async {
                self.setProgressStyle()
                self.setProgressType()
                if !isAdded {
                    self.isUserInteractionEnabled = false
                    view.addSubview(self)
                }
                
            }
        }
    }
    
}


