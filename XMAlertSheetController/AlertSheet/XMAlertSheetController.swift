//
//  XMAlertSheetController.swift
//  XMAlertSheetController
//
//  Created by Mazy on 2019/5/31.
//  Copyright © 2019 Mazy. All rights reserved.
//

import UIKit

extension UIDevice {
    
    /// Has safe area
    ///
    /// with notch: 44.0 on iPhone X, XS, XS Max, XR.
    ///
    /// without notch: 20.0 on iPhone 8 on iOS 12+.
    ///
    static var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
}

@objc open class XMAlertSheetController: UIViewController {

	/// 黑色半透明遮罩
	@IBOutlet weak var maskView: UIView!
	/// 主标题
    @IBOutlet weak var alertTitle: UILabel!
    /// 副标题
    @IBOutlet weak var alertMessage: UILabel!
    /// 弹框主视图
    @IBOutlet weak var alertView: UIView!
    /// action stack view
    @IBOutlet weak var alertActionStackView: UIStackView!
    /// cancel stack view
    @IBOutlet weak var cancelStackView: UIStackView!
    /// alert action stack view height
    @IBOutlet weak var alertActionStackViewHeightConstraint: NSLayoutConstraint!
    /// cancel action stack view height
    @IBOutlet weak var cancelActionStackViewHeightConstraint: NSLayoutConstraint!
    /// title and message stack view top Constraint
    @IBOutlet weak var titleStackViewTopConstraint: NSLayoutConstraint!
    /// title and message stack view bottom Constraint
    @IBOutlet weak var titleStackViewBottomConstraint: NSLayoutConstraint!
    /// action height
    open var FIRST_ALERT_STACK_VIEW_HEIGHT: CGFloat = 56
	open var ALERT_STACK_VIEW_HEIGHT: CGFloat = 48

    /// total content height
    private var contentViewHeight: CGFloat = 0
    /// 点击背景是否消失
    open var dismissWithBackgroudTouch = true // enable touch background to dismiss. default value is true
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.alertView.transform = CGAffineTransform(translationX: 0, y: self.contentViewHeight)
		self.maskView.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
			self.maskView.alpha = 1.0
            self.alertView.transform = CGAffineTransform.identity
        }
    }

    /// Initialiser
    ///
    /// - Parameters:
    ///   - title: 主题
    ///   - message: 描述
    @objc public  convenience init(title: String? = nil, message: String? = nil) {
        self.init()
        
        guard let nib = loadNibAlertController(), let unwrappedView = nib[0] as? UIView else { return }
        self.view = unwrappedView
        /// for present vc
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
		let titleFont = UIFont(name: "DMSans-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
		alertTitle.font = titleFont
		alertMessage.font = titleFont.withSize(13)
        if let title = title, title.count > 0 {
            alertTitle.isHidden = false
            alertTitle.text = title
        } else {
            alertTitle.isHidden = true
        }
        
        if let message = message, message.count > 0 {
            alertMessage.isHidden = false
            alertMessage.text = message
        } else {
            alertMessage.isHidden = true
        }
        
        if alertTitle.isHidden == true && alertMessage.isHidden == true {
            titleStackViewTopConstraint.constant  = 0
            titleStackViewBottomConstraint.constant  = 0
        }
        
        // Gesture recognizer for background dismiss with background touch
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissAlertControllerFromBackgroundTap))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    //MARK: - Actions
    @objc open func addAction(_ alertAction: XMAlertAction) {
        
        if alertAction.actionStyle == .cancel {
            if UIDevice.hasSafeArea { // has Safe Area
                cancelActionStackViewHeightConstraint.constant = ALERT_STACK_VIEW_HEIGHT + 30
				alertAction.titleEdgeInsets.bottom = 34
            } else {
                cancelActionStackViewHeightConstraint.constant = ALERT_STACK_VIEW_HEIGHT + 10
                alertAction.titleEdgeInsets.bottom = 5
            }
            cancelStackView.addArrangedSubview(alertAction)
        } else {
            alertActionStackView.addArrangedSubview(alertAction)
			if alertActionStackView.arrangedSubviews.count == 1 && alertTitle.isHidden && alertMessage.isHidden  {
				alertAction.partingLine.isHidden = true
				alertAction.heightAnchor.constraint(equalToConstant: FIRST_ALERT_STACK_VIEW_HEIGHT).isActive = true
				alertActionStackViewHeightConstraint.constant += FIRST_ALERT_STACK_VIEW_HEIGHT
			} else {
				alertActionStackViewHeightConstraint.constant += ALERT_STACK_VIEW_HEIGHT
			}
        }
        
        alertAction.addTarget(self, action: #selector(XMAlertSheetController.dismissAlertController(_:)), for: .touchUpInside)
        
		contentViewHeight = cancelActionStackViewHeightConstraint.constant + alertActionStackViewHeightConstraint.constant + titleStackViewTopConstraint.constant + titleStackViewBottomConstraint.constant
    }
    
    @objc private func dismissAlertController(_ sender: XMAlertAction){
        animateDismiss(sender)
    }
    
    @objc private func dismissAlertControllerFromBackgroundTap() {
        if !dismissWithBackgroudTouch {
            return
        }
        animateDismiss(nil)
    }
    
    //MARK: - Customizations
    @objc private func loadNibAlertController() -> [AnyObject]? {
        let podBundle = Bundle(for: self.classForCoder)
        
        if let bundleURL = podBundle.url(forResource: "XMAlertSheetController", withExtension: "bundle"){
            
            if let bundle = Bundle(url: bundleURL) {
                return bundle.loadNibNamed("XMAlertSheetController", owner: self, options: nil) as [AnyObject]?
            } else {
                assertionFailure("Could not load the bundle")
            }
        } else if let nib = podBundle.loadNibNamed("XMAlertSheetController", owner: self, options: nil) as [AnyObject]?{
            return nib
        } else {
            assertionFailure("Could not create a path to the bundle")
        }
        return nil
    }
    
	@objc private func animateDismiss(_ alertAction: XMAlertAction?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alertView.transform = CGAffineTransform(translationX: 0, y: self.alertView.bounds.height)
			self.maskView.alpha = 0.0
        }, completion: { _ in
			self.dismiss(animated: false, completion: {
				alertAction?.action?()
			})
        })
    }
}

