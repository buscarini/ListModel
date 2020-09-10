
import UIKit
public struct TableHeaderFooter<T: Equatable>: Equatable {
	public typealias UnwrapValue = (T?) -> (Any?)
	
	let viewConstructor: () -> UIView
	let fill: (T?, UIView) -> Void
	public var id: String
	public var reuseId: String

	public var value: T?
	
	public var height: CGFloat?
	
	private init(
		viewConstructor: @escaping () -> UIView,
		fill: @escaping (T?, UIView) -> Void,
		id: String,
		reuseId: String,
		value: T? = nil,
		height: CGFloat? = nil
	) {
		self.viewConstructor = viewConstructor
		self.fill = fill
		self.id = id
		self.reuseId = reuseId
		self.value = value
		self.height = height
	}
	
	public static func create<V: UIView>(
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		id: String,
		reuseId: String = String(describing: V.self),
		value: T? = nil,
		height: CGFloat? = nil
	) -> TableHeaderFooter<T> {
		return TableHeaderFooter(
			viewConstructor: viewConstructor,
			fill: { (m, v) in
				fill(m, v as! V)
			},
			id: id + String(describing: T.self),
			reuseId: reuseId,
			value: value,
			height: height
		)
	}
}

public func ==<T>(lhs: TableHeaderFooter<T>, rhs: TableHeaderFooter<T>) -> Bool {
	guard lhs.value == rhs.value else { return false }
	guard lhs.id == rhs.id else { return false }
	guard lhs.reuseId == rhs.reuseId else { return false }
	guard lhs.height == rhs.height else { return false }
	
	return true
}

