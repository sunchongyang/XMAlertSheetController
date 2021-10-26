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

    private var action: (() -> Void)?
    
    open var actionStyle: XMAlertActionStyle = .cancel
    /// 分割线
    open var partingLine = UIView()
    
	open var partingLineHorizonInset: CGFloat = 0

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
		partingLineColor = UIColor(red: 0xC7/255.0, green: 0xC7/255.0, blue: 0xC7/255.0, alpha: 1.0)
    }
    
     @objc public convenience init(title: String, style: XMAlertActionStyle, action: (() -> Void)? = nil) {
        self.init()
        self.action = action
        self.actionStyle = style

        self.addTarget(self, action: #selector(tappedAction), for: .touchUpInside)
        self.setTitle(title, for: .normal)
		let font = UIFont(name: "DMSans-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleLabel?.font = font
        
        switch style {
        case .default:
			self.setTitleColor(UIColor(red: 0x20/255.0, green: 0x20/255.0, blue: 0x20/255.0, alpha: 1.0), for: .normal)
        case .destructive:
			self.setTitleColor(UIColor(red: 0xFF/255.0, green: 0x3B/255.0, blue: 0x30/255.0, alpha: 1.0), for: .normal)
        case .cancel:
            self.setTitleColor(UIColor(red: 0x80/255.0, green: 0x80/255.0, blue: 0x80/255.0, alpha: 1.0), for: .normal)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.action?()
        }
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
