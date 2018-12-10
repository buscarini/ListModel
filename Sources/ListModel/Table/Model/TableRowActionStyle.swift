//
//  TableRowActionStyle.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import Foundation

public enum TableRowActionStyle: Equatable {
	case `default`
	case normal
}

public func ==(lhs: TableRowActionStyle, rhs: TableRowActionStyle) -> Bool {
	switch (lhs,rhs) {
	case (.default, .default):
		return true
	case (.normal, .normal):
		return true
	default:
		return false
	}
}

