//
//  ListItem.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import UIKit

public struct ListItem<T: Equatable>: Equatable {
	
	public typealias OnSelect = (ListItem<T>) -> ()
	typealias ViewConstructor = () -> UIView
	public typealias Configuration = ListItemConfiguration<T>
	typealias Fill = (T?, UIView) -> Void
	
	let viewConstructor: ViewConstructor
	let fill: Fill
	
	public var id: String
	public var reuseId: String
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
		configuration: ListItemConfiguration<T>? = nil,
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
		reuseId: String,
		fill: @escaping (T?, V) -> Void,
		value: T?,
		configuration: ListItemConfiguration<T>? = nil,
		onSelect: OnSelect? = nil)
		-> ListItem
	{
		return ListItem.init(
			viewConstructor: viewConstructor,
			id: id,
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

public func ==<T>(lhs : ListItem<T>, rhs: ListItem<T>) -> Bool {
	guard lhs.id == rhs.id else { return false }
	guard lhs.reuseId == rhs.reuseId else { return false }
	guard lhs.value == rhs.value else { return false }
	guard lhs.configuration == rhs.configuration else { return false }
	guard (lhs.onSelect == nil && rhs.onSelect == nil) || (lhs.onSelect != nil && rhs.onSelect != nil) else { return false }

	return true
}
