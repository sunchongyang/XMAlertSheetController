//
//  ViewController.swift
//  XMAlertSheetController
//
//  Created by Mazy on 2019/5/31.
//  Copyright © 2019 Mazy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var mainTitle: String?
    private var descMessage: String?
    
    private var showDefaultAction: Bool = false
    private var showDestructiveAction: Bool = false
    private var showCancelAction: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func MainTitleFieldEditingChanged(_ sender: UITextField) {
        mainTitle = sender.text
    }
    
    @IBAction func descriptionFieldDditingChanged(_ sender: UITextField) {
        descMessage = sender.text
    }
    
    @IBAction func addDefaultAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        showDefaultAction = sender.isSelected
    }

    @IBAction func addDestructiveAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        showDestructiveAction = sender.isSelected
    }
    
    @IBAction func addCancelAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        showCancelAction = sender.isSelected
    }
    
    @IBAction func showAlertSheet() {
        
        let alertSheet = XMAlertSheetController(title: mainTitle, message: descMessage)
		alertSheet.delegate = self
        if showDefaultAction {
            alertSheet.addAction(XMAlertAction(title: "No Thanks", style: .default, action: {
                print("No thansk!")
            }))
        }
        
        if showDestructiveAction {
            alertSheet.addAction(XMAlertAction(title: "Allow", style: .destructive, action: {
				print("No Allow!")
            }))
        }
        
        if showCancelAction {
			let cancel = XMAlertAction(title: "Cancel", style: .cancel)
			cancel.partingLine.trailingAnchor.constraint(equalTo: cancel.trailingAnchor, constant: 0).isActive = true
            alertSheet.addAction(cancel)
			let cancel2 = XMAlertAction(title: "Cancel2", style: .cancel) { [weak weakAlertSheet =  alertSheet] in
				weakAlertSheet?.dimiss()
			}
			cancel2.partingLine.leadingAnchor.constraint(equalTo: cancel2.leadingAnchor, constant: 0).isActive = true
			cancel2.dismissWhenTapped = false
			alertSheet.addAction(cancel2)
			cancel2.actionStyle = .selected
			alertSheet.cancelStackView.axis = .horizontal
			alertSheet.cancelStackView.distribution = .fillEqually
        }
        self.present(alertSheet, animated: true, completion: nil)
    }
}

extension ViewController: XMAlertSheetControllerDelegate {
	func alertControllerIsBeingDismissed(_ alertController: XMAlertSheetController) {
		print("alertControllerIsBeingDismissed")
	}
}
