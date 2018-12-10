
import UIKit

public enum Selector {

	public static func chooseOne<T: Hashable, V: UIView> (
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: T?,
		filter: @escaping SearchView<SingleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		completion: @escaping (T?) -> ())
	{
		SearchView<SingleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: [selected].compactMap { $0 },
			isValid: onlyOne,
			filter: filter) { items in
				guard let first = items.first else { return }
				completion(first)
		}
	}
	
	public static func chooseOneOrMore<T: Hashable, V: UIView>(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: [T],
		filter: @escaping SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		completion: @escaping ([T]) -> ()) {

		SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: selected,
			isValid: oneOrMore,
			filter: filter,
			completion: completion
		)
	}
	
	public static func chooseZeroOrMore<T: Hashable, V: UIView>(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: [T],
		filter: @escaping SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		completion: @escaping ([T]) -> ()) {

		SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: selected,
			isValid: zeroOrMore,
			filter: filter,
			completion: completion
		)
	}
	
	public static func checklist<T: Hashable, V: UIView>(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: [T],
		filter: @escaping SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		viewType: V.Type,
		completion: @escaping ([T]) -> ()) {
		SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: selected,
			isValid: all,
			filter: filter,
			completion: completion
		)
	}


	// MARK: Search methods
	
	public static func searchOne<T: Hashable, V: UIView>(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: T?,
		filter: @escaping SearchView<SingleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		completion: @escaping (T) -> ()) {
		SearchView<SingleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: [selected].compactMap { $0 },
			isValid: onlyOne,
			filter: filter,
			completion: { items in
				guard let first = items.first else { return }
				completion(first)
			}
		)
	}

	public static func searchOneOrMore<T: Hashable, V: UIView>(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: [T],
		filter: @escaping SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		completion: @escaping ([T]) -> ()) {
		SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: selected,
			isValid: oneOrMore,
			filter: filter,
			completion: completion
		)
	}

	public static func searchZeroOrMore<T: Hashable, V: UIView>(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: [T],
		filter: @escaping SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		completion: @escaping ([T]) -> ()) {
		SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: selected,
			isValid: zeroOrMore,
			filter: filter,
			completion: completion
		)
	}

	public static func checklistSearch<T: Hashable, V: UIView>(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: [T],
		filter: @escaping SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.Filter,
		completion: @escaping ([T]) -> ()) {
		SearchView<MultipleSelection<T>, T, V, EmptyType, EmptyType>.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: selected,
			isValid: all,
			filter: filter,
			completion: completion
		)
	}
}
