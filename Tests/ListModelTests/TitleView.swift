//
//  TitleView.swift
//  ListModel_Tests
//
//  Created by José Manuel Sánchez Peñarroja on 10/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public class TitleView: UIView {
	@IBOutlet var label: UILabel!
	
	@IBOutlet var topC: NSLayoutConstraint!
	@IBOutlet var bottomC: NSLayoutConstraint!
	@IBOutlet var leftC: NSLayoutConstraint!
	@IBOutlet var rightC: NSLayoutConstraint!
	
	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		self.setNeedsLayout()
	}
}

extension TitleView {
	public func fill(_ model: TitleViewModel) {
		self.label.text = model.string
		
		self.backgroundColor = model.backgroundColor
		
		self.topC.constant = model.insets.top
		self.bottomC.constant = model.insets.bottom
		self.leftC.constant = model.insets.left
		self.rightC.constant = model.insets.right
		
		self.setNeedsLayout()
	}
}

