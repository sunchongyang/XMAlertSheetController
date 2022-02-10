//
//  XMAlertAction.swift
//  XMAlertSheetController
//
//  Created by Mazy on 2019/5/31.
//  Copyright © 2019 Mazy. All rights reserved.
//

import UIKit

@objc public enum XMAlertActionStyle: Int {
    
    case `default`
    case cancel
    case destructive
}

@objc open  class XMAlertAction: UIButton {

	open var action: (() -> Void)?
    
    open var actionStyle: XMAlertActionStyle = .cancel
    /// 分割线
    open var partingLine = UIView()
    
	open var partingLineHorizonInset: CGFloat = XMAlertTheme.partingLineHorizonInset

	open var partingLineColor: UIColor? {
		set {
			partingLine.backgroundColor = newValue
		}
		get {
			return partingLine.backgroundColor
		}
	}


    init() {
        super.init(frame: .zero)
		partingLineColor = XMAlertTheme.partingLineColor
    }
    
     @objc public convenience init(title: String, style: XMAlertActionStyle, action: (() -> Void)? = nil) {
        self.init()
        self.action = action
        self.actionStyle = style

        self.addTarget(self, action: #selector(tappedAction), for: .touchUpInside)
        self.setTitle(title, for: .normal)
		self.titleLabel?.font = XMAlertTheme.alertActionFont
        
        switch style {
        case .default:
			self.setTitleColor(XMAlertTheme.defaultActionColor, for: .normal)
        case .destructive:
			self.setTitleColor(XMAlertTheme.destructiveActionColor, for: .normal)
        case .cancel:
			self.setTitleColor(XMAlertTheme.cancelActionColor, for: .normal)
        }
        self.addSeparatorLine(style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XMAlertAction {
    
    @objc func tappedAction() {
        //Action need to be fired after alert dismiss
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
//            self.action?()
//        }
    }
    
    func addSeparatorLine(style: XMAlertActionStyle) {
        
        partingLine.backgroundColor = partingLineColor
        self.addSubview(partingLine)
        
        // Autolayout separator
        partingLine.translatesAutoresizingMaskIntoConstraints = false
        partingLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        partingLine.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: partingLineHorizonInset).isActive = true
        partingLine.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: partingLineHorizonInset).isActive = true
        let height: CGFloat = style == .cancel ? 1 : 1
        partingLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
