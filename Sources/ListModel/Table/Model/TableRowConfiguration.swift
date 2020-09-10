//
//  TableRowConfiguration.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import UIKit

public struct TableRowConfiguration<T: Equatable>: Equatable {
	public var accessoryType: TableRowAccessoryType
	public var rowHeight: CGFloat?
	public var onAccessoryTap: ((TableRow<T>)->())? = nil
	public var swipeActions: [TableRowAction<T>]
	public var indentationLevel: Int?
	public var indentationWidth: CGFloat?
	public var separatorInset: UIEdgeInsets?
	public var selectionStyle: TableRowSelectionStyle?
	public var backgroundColor: UIColor?
	
	public init(
		accessoryType: TableRowAccessoryType = .none,
		rowHeight: CGFloat? = nil,
		onAccessoryTap: ((TableRow<T>)->())? = nil,
		swipeActions : [TableRowAction<T>] = [],
		indentationLevel: Int? = nil,
		indentationWidth: CGFloat? = nil,
		separatorInset: UIEdgeInsets? = nil,
		selectionStyle: TableRowSelectionStyle? = nil,
		backgroundColor: UIColor? = UIColor.white
	) {
		self.accessoryType = accessoryType
		self.rowHeight = rowHeight
		self.onAccessoryTap = onAccessoryTap
		self.swipeActions = swipeActions
		self.indentationLevel = indentationLevel
		self.indentationWidth = indentationWidth
		self.separatorInset = separatorInset
		self.selectionStyle = selectionStyle
		self.backgroundColor = backgroundColor
	}
	
	public static var `default`: TableRowConfiguration {
		return TableRowConfiguration(
			accessoryType : .none,
			rowHeight: nil,
			onAccessoryTap: nil,
			swipeActions: [],
			indentationLevel: 0,
			indentationWidth : 10.0,
			separatorInset: nil,
			selectionStyle: nil,
			backgroundColor: nil
		)
	}
}

public func ==<T>(lhs : TableRowConfiguration<T>, rhs: TableRowConfiguration<T>) -> Bool {
	guard lhs.accessoryType == rhs.accessoryType else { return false }
	guard (lhs.onAccessoryTap != nil && rhs.onAccessoryTap != nil) || (lhs.onAccessoryTap == nil && rhs.onAccessoryTap == nil) else { return false }
	guard lhs.swipeActions == rhs.swipeActions else { return false }
	guard lhs.indentationLevel == rhs.indentationLevel else { return false }
	guard lhs.indentationWidth == rhs.indentationWidth else { return false }
	guard lhs.separatorInset == rhs.separatorInset else { return false }
	guard lhs.selectionStyle == rhs.selectionStyle else { return false }
	guard lhs.backgroundColor == rhs.backgroundColor else { return false }
	guard lhs.rowHeight == rhs.rowHeight else { return false }

	return true
}

