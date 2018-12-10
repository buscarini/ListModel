import UIKit

public struct TableRowAction<T: Equatable>: Equatable {
	var title: String
	var style: TableRowActionStyle = .default
	var tintColor: UIColor?
	var action: (TableRow<T>) -> ()
	
	public init(title: String, style: TableRowActionStyle = .default, tintColor: UIColor? = nil, action: @escaping (TableRow<T>) -> ()) {
		self.title = title
		self.style = style
		self.tintColor = tintColor
		self.action = action
	}
}

public func ==<T>(lhs: TableRowAction<T>, rhs: TableRowAction<T>) -> Bool {
	guard lhs.title == rhs.title else { return false }
	guard lhs.style == rhs.style else { return false }
	guard lhs.tintColor == rhs.tintColor else { return false }
	
	return true
}
