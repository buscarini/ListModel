//
//  ListListItemAccessoryType.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 20/7/17.
//
//

import UIKit

public enum ListItemAccessoryType: Equatable {
	case none // don't show any accessory view
	
	case disclosureIndicator // regular chevron. doesn't track
	
	case detailDisclosureButton // info button w/ chevron. tracks
	
	case checkmark // checkmark. doesn't track
	
	@available(iOS 7.0, *)
	case detailButton // info button. tracks
	
	case view(() -> UIView?)
}


public func ==(left: ListItemAccessoryType, right: ListItemAccessoryType) -> Bool {
	switch (left, right) {
		case (.none, .none),
			(.disclosureIndicator, .disclosureIndicator),
			(.detailDisclosureButton, .detailDisclosureButton),
			(.checkmark, .checkmark),
			(.detailButton, .detailButton):
			return true
		
		case (.view(let f1), .view(let f2)):
			// TODO: Check if this can be done
			return true // f1() == f2()
		
		default:
			return false
	}
}


extension ListItemAccessoryType {
//	var cellAccessoryType: UICollectionViewCell.AccessoryType {
//		switch self {
//			case .none:
//				return .none
//			case .disclosureIndicator:
//				return .disclosureIndicator
//			case .detailDisclosureButton:
//				return .detailDisclosureButton
//			case .checkmark:
//				return .checkmark
//			case .detailButton:
//				return .detailButton
//			case .view:
//				return .none
//		}
//	}
	
	var cellAccessoryView: UIView? {
		switch self {
			case .view(let f):
				return f()
			default:
				return nil
		}
	}
}
