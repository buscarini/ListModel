//
//  TableRow.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import UIKit

public struct TableRow<T: Equatable>: Equatable {
	
	public typealias OnSelect = (TableRow<T>) -> ()
	typealias ViewConstructor = () -> UIView
	public typealias Configuration = TableRowConfiguration<T>
	typealias Fill = (T?, UIView) -> Void
	
	let viewConstructor: ViewConstructor
	let fill: Fill
	
	var id: String
	var reuseId: String
	public var value: T?
	
	/// View Specific Configuration
	public var configuration: Configuration?
	public var onSelect: OnSelect?
	
	private init(
		viewConstructor: @escaping ViewConstructor,
		id: String,
		reuseId: String,
		fill: @escaping Fill,
		value: T?,
		configuration: TableRowConfiguration<T>? = nil,
		onSelect: OnSelect? = nil
	) {
		self.viewConstructor = viewConstructor
		self.id = id
		self.reuseId = reuseId
		self.fill = fill
		self.value = value
		self.configuration = configuration
		self.onSelect = onSelect
	}
	
	public static func create<V: UIView>(
		viewConstructor: @escaping (() -> V),
		id: String,
		reuseId: String = String(describing: V.self),
		fill: @escaping (T?, V) -> Void,
		value: T?,
		configuration: TableRowConfiguration<T>? = nil,
		onSelect: OnSelect? = nil)
		-> TableRow
	{
		return TableRow.init(
			viewConstructor: viewConstructor,
			id: id + String(describing: T.self),
			reuseId: reuseId,
			fill: { (m, v) in
				fill(m, v as! V)
			},
			value: value,
			configuration: configuration,
			onSelect: onSelect
		)
	}
}

public func ==<T>(lhs : TableRow<T>, rhs: TableRow<T>) -> Bool {
	guard lhs.id == rhs.id else { return false }
	guard lhs.reuseId == rhs.reuseId else { return false }
	guard lhs.value == rhs.value else { return false }
	guard lhs.configuration == rhs.configuration else { return false }
	guard (lhs.onSelect == nil && rhs.onSelect == nil) || (lhs.onSelect != nil && rhs.onSelect != nil) else { return false }

	return true
}
