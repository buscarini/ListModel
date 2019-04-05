//
//  TableRowSelectionStyle.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 31/12/2018.
//

import Foundation
import UIKit

public enum TableRowSelectionStyle: Int, Equatable {
	case noStyle
	case blue
	case gray
	case `default`
}

public extension TableRowSelectionStyle {
	var uiKit: UITableViewCell.SelectionStyle {
		switch self {
		case .noStyle:
			return .none
		case .blue:
			return .blue
		case .gray:
			return .gray
		case .default:
			return .default
		}
	}
}
