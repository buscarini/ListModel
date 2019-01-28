//
//  List+Constructors.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 31/3/17.
//
//

import UIKit

public extension List {

	public static func listFrom<V: UIView>(
		_ items: [T],
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		configuration: Configuration? = nil,
		scrollInfo: ListScrollInfo? = nil,
		itemConfiguration: ListItemConfiguration<T>? = nil,
		onSelect: ((ListItem<T>) -> ())? = nil)
		-> List<T, HeaderT, FooterT>
	{
		let listItems = zip(0..., items).map { (index, item) in
			List.Item.create(
				viewConstructor: viewConstructor,
				id: "\(index)",
				reuseId: "cell",
				fill: fill,
				value: item,
				configuration: itemConfiguration,
				onSelect: onSelect
			)
		}
		
		let section = List.Section(items: listItems, header: nil, footer: nil)
		
		return List<T, HeaderT, FooterT>(sections: [section], header: nil, footer: nil, scrollInfo: scrollInfo, configuration: configuration)
	}

	// MARK: Item constructors
	public static func item<V: UIView>(
		nibName: String,
		bundle: Bundle?,
		id: String,
		reuseId: String = String(describing: V.self),
		fill: @escaping (T?, V) -> Void,
		value: T?,
		configuration: Item.Configuration? = nil,
		onSelect: Item.OnSelect? = nil) -> Item
	{
		return Item.create(
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
	
	public static func item<V: UIView>(
		viewConstructor: @escaping () -> V,
		id: String,
		reuseId: String = String(describing: V.self),
		fill: @escaping (T?, V) -> Void,
		value: T?,
		configuration: Item.Configuration? = nil,
		onSelect: Item.OnSelect? = nil) -> Item
	{
		return Item.create(
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
		reuseId: String = String(describing: V.self),
		value: HeaderT? = nil
	) -> List.Header {
		return List.Header.create(
			viewConstructor: viewConstructor,
			fill: fill,
			id: id,
			reuseId: reuseId,
			value: value
		)
	}
	
	// MARK: Footer constructors
	public static func footer<V: UIView>(
		viewConstructor: @escaping () -> V,
		fill: @escaping (FooterT?, V) -> Void,
		id: String,
		reuseId: String = String(describing: V.self),
		value: FooterT? = nil
	) -> Footer {
		return Footer.create(
			viewConstructor: viewConstructor,
			fill: fill,
			id: id,
			reuseId: reuseId,
			value: value
		)
	}
}
