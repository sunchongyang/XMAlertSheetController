//
//  XMAlertTheme.swift
//  XMAlertSheetController
//
//  Created by Sun chongyang on 2022/2/10.
//  Copyright © 2022 Mazy. All rights reserved.
//

import UIKit

public struct XMAlertTheme {
	public static var alertTitleColor: UIColor = UIColor(red: 0x8F/255.0, green: 0x8F/255.0, blue: 0x8F/255.0, alpha: 1.0)
	public static var alertTitleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
	public static var alertMessageColor: UIColor = UIColor(red: 0xC7/255.0, green: 0xC7/255.0, blue: 0xC7/255.0, alpha: 1.0)
	public static var alertMessageFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
	public static var defaultActionColor: UIColor = UIColor(red: 0x20/255.0, green: 0x20/255.0, blue: 0x20/255.0, alpha: 1.0)
	public static var cancelActionColor: UIColor = UIColor(red: 0x80/255.0, green: 0x80/255.0, blue: 0x80/255.0, alpha: 1.0)
	public static var destructiveActionColor: UIColor = UIColor(red: 0xFF/255.0, green: 0x3B/255.0, blue: 0x30/255.0, alpha: 1.0)
	public static var alertActionFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)

	public static var partingLineColor: UIColor = UIColor(red: 0xC7/255.0, green: 0xC7/255.0, blue: 0xC7/255.0, alpha: 1.0)
	public static var partingLineHorizonInset: CGFloat = 0
}
