import UIKit

open class TableViewCell<T : Equatable> : UITableViewCell {
	public var view: UIView?
	var reuseId: String?
	
	func update(_ config: TableRowConfiguration<T>?, canBeSelected: Bool = true) {
		
		self.accessoryType = config?.accessoryType.cellAccessoryType ?? .none
		self.accessoryView = config?.accessoryType.cellAccessoryView
		self.separatorInset = config?.separatorInset ?? UIEdgeInsets.zero
		
		self.indentationLevel = config?.indentationLevel ?? 0
		self.indentationWidth = config?.indentationWidth ?? 10.0
		
		self.selectionStyle = config?.selectionStyle?.uiKit ?? (canBeSelected ? .default : .none)
		
		self.backgroundColor = config?.backgroundColor
	}
}


extension TableViewCell {
	public func fill(_ row: TableRow<T>) {
		defer {
			self.reuseId = row.reuseId
		}
		
		let subview: UIView
		
		if let view = view, reuseId == row.reuseId {
			subview = view
		}
		else {
			subview = row.viewConstructor()
			view?.removeFromSuperview()
			view = subview
			self.contentView.addSubview(subview)
			subview.translatesAutoresizingMaskIntoConstraints = false
			LayoutUtils.fill(self.contentView,view: subview)
		}
		
		row.fill(row.value, subview)
		
		self.update(row.configuration, canBeSelected: row.onSelect != nil)
	}
}
