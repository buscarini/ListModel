
import UIKit
public struct ListHeaderFooter<T: Equatable>: Equatable {
	public typealias UnwrapValue = (T?) -> (Any?)
	
	let viewConstructor: () -> UIView
	let fill: (T?, UIView) -> Void
	public var id: String
	public var reuseId: String
	
	public var value: T?
	
	private init(
		viewConstructor: @escaping () -> UIView,
		fill: @escaping (T?, UIView) -> Void,
		id: String,
		reuseId: String,
		value: T? = nil
	) {
		self.viewConstructor = viewConstructor
		self.fill = fill
		self.id = id
		self.reuseId = reuseId
		self.value = value
	}
	
	public static func create<V: UIView>(
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		id: String,
		reuseId: String = String(describing: V.self),
		value: T? = nil
	) -> ListHeaderFooter<T> {
		return ListHeaderFooter(
			viewConstructor: viewConstructor,
			fill: { (m, v) in
				fill(m, v as! V)
			},
			id: id,
			reuseId: reuseId,
			value: value)
	}
}

public func ==<T>(lhs: ListHeaderFooter<T>, rhs: ListHeaderFooter<T>) -> Bool {
	guard lhs.value == rhs.value else { return false }
	guard lhs.id == rhs.id else { return false }
	guard lhs.reuseId == rhs.reuseId else { return false }
	
	return true
}

