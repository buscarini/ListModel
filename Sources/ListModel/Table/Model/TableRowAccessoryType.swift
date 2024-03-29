//
//  TableListItemAccessoryType.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 20/7/17.
//
//

import UIKit

public enum TableRowAccessoryType: Equatable {
	case none // don't show any accessory view
	
	case disclosureIndicator // regular chevron. doesn't track
	
	case detailDisclosureButton // info button w/ chevron. tracks
	
	case checkmark // checkmark. doesn't track
	
	@available(iOS 7.0, *)
	case detailButton // info button. tracks
	
	case view(() -> UIView?)
}


public func ==(left: TableRowAccessoryType, right: TableRowAccessoryType) -> Bool {
	switch (left, right) {
		case (.none, .none),
			(.disclosureIndicator, .disclosureIndicator),
			(.detailDisclosureButton, .detailDisclosureButton),
			(.checkmark, .checkmark),
			(.detailButton, .detailButton):
			return true
		
		case (.view, .view):
			// TODO: See how to solve this case
			return true // f1() == f2()
		
		default:
			return false
	}
}


extension TableRowAccessoryType {
	public var cellAccessoryType: UITableViewCell.AccessoryType {
		switch self {
			case .none:
				return .none
			case .disclosureIndicator:
				return .disclosureIndicator
			case .detailDisclosureButton:
				return .detailDisclosureButton
			case .checkmark:
				return .checkmark
			case .detailButton:
				return .detailButton
			case .view:
				return .none
		}
	}
	
	public var cellAccessoryView: UIView? {
		switch self {
			case .view(let f):
				return f()
			default:
				return nil
		}
	}
}
