//
//  ViewCreationType.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import UIKit

public enum ViewCreationType: Equatable {
	case nib(String, bundle: Bundle?)
	case manual(() -> UIView)
	case fixed(UIView)
}

public func ==(lhs: ViewCreationType, rhs: ViewCreationType) -> Bool {
	switch (lhs, rhs) {
	case (.nib(let name1, let b1), .nib(let name2, let b2)):
		return name1 == name2 && b1 == b2
	case (.manual, .manual):
		return true
	case (.fixed(let view1), .fixed(let view2)):
		return view1 == view2
		
	default:
		return false
	}
}
