//
//  TitleViewModel.swift
//  Basic
//
//  Created by José Manuel Sánchez Peñarroja on 10/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public struct TitleViewModel {
	public static let defaultInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	
	var string: String?
	var backgroundColor: UIColor?
	var insets = TitleViewModel.defaultInsets
	
	public init(title: String?, font: UIFont? = nil, textColor: UIColor? = nil, backgroundColor: UIColor? = nil, textAlign: NSTextAlignment = .left, insets: UIEdgeInsets = TitleViewModel.defaultInsets) {
		
		self.string = title
		self.backgroundColor = backgroundColor
		self.insets = insets
	}
}

extension TitleViewModel: Equatable {}
public func ==(left: TitleViewModel, right: TitleViewModel) -> Bool {
	
	guard left.string == right.string else { return false }
	
	guard left.backgroundColor == right.backgroundColor else { return false }
	guard left.insets == right.insets else { return false }
	
	return true
}
