import UIKit

public struct ListItemAction<T: Equatable>: Equatable {
	var title: String
	var style: ListItemActionStyle = .default
	var tintColor: UIColor?
	var action: (ListItem<T>) -> ()
	
	public init(title: String, style: ListItemActionStyle = .default, tintColor: UIColor? = nil, action: @escaping (ListItem<T>) -> ()) {
		self.title = title
		self.style = style
		self.tintColor = tintColor
		self.action = action
	}
}

public func ==<T>(lhs: ListItemAction<T>, rhs: ListItemAction<T>) -> Bool {
	guard lhs.title == rhs.title else { return false }
	guard lhs.style == rhs.style else { return false }
	guard lhs.tintColor == rhs.tintColor else { return false }
	
	return true
}
