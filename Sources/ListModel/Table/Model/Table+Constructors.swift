//
//  List+Constructors.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 31/3/17.
//
//

import UIKit

public extension Table {

	public static func tableFrom<V: UIView>(
		_ items: [T],
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		configuration: TableConfiguration? = nil,
		scrollInfo: TableScrollInfo? = nil,
		itemConfiguration: TableRowConfiguration<T>? = nil,
		onSelect: ((TableRow<T>) -> ())? = nil)
		-> Table<T, HeaderT, FooterT>
	{
		let rows = zip(0..., items).map { (index, item) in
			Table.Row.create(
				viewConstructor: viewConstructor,
				id: "\(index)",
				reuseId: "cell",
				fill: fill,
				value: item,
				configuration: itemConfiguration,
				onSelect: onSelect
			)
		}
		
		let section = Table.Section(rows: rows, header: nil, footer: nil)
		
		return Table<T, HeaderT, FooterT>(sections: [section], header: nil, footer: nil, scrollInfo: scrollInfo, configuration: configuration)
	}

	// MARK: Item constructors
	public static func row<V: UIView>(
		nibName: String,
		bundle: Bundle?,
		id: String,
		reuseId: String = String(describing: V.self),
		fill: @escaping (T?, V) -> Void,
		value: T?,
		configuration: Row.Configuration? = nil,
		onSelect: Row.OnSelect? = nil) -> Row
	{
		return Row.create(
			viewConstructor: {
				let viewBundle = bundle ?? Bundle.main
				let views = viewBundle.loadNibNamed(nibName, owner: self, options: nil)!
				return views.first! as! V
			},
			id: id,
			reuseId: reuseId,
			fill: fill,
			value: value,
			configuration: configuration,
			onSelect: onSelect
		)
	}
	
	public static func row<V: UIView>(
		viewConstructor: @escaping () -> V,
		id: String,
		reuseId: String,
		fill: @escaping (T?, V) -> Void,
		value: T?,
		configuration: Row.Configuration? = nil,
		onSelect: Row.OnSelect? = nil) -> Row
	{
		return Row.create(
			viewConstructor: viewConstructor,
			id: id,
			reuseId: reuseId,
			fill: fill,
			value: value,
			configuration: configuration,
			onSelect: onSelect
		)
	}
	
	// MARK: Header constructors
	public static func header<V: UIView>(
		viewConstructor: @escaping () -> V,
		fill: @escaping (HeaderT?, V) -> Void,
		id: String,
		reuseId: String,
		value: HeaderT? = nil,
		onSelect: Table.Header.OnSelect? = nil) -> Table.Header {
		return Table.Header.create(
			viewConstructor: viewConstructor,
			fill: fill,
			id: id,
			reuseId: reuseId,
			value: value,
			onSelect: onSelect)
	}
	
	// MARK: Footer constructors
	public static func footer<V: UIView>(
		viewConstructor: @escaping () -> V,
		fill: @escaping (FooterT?, V) -> Void,
		id: String,
		reuseId: String,
		value: FooterT? = nil,
		onSelect: Footer.OnSelect? = nil) -> Footer {
		return Footer.create(
			viewConstructor: viewConstructor,
			fill: fill,
			id: id,
			reuseId: reuseId,
			value: value,
			onSelect: onSelect)
	}
}
