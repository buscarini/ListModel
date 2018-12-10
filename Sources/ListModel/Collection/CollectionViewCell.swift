import UIKit

public class CollectionViewCell<T : Equatable>: UICollectionViewCell {
	public var view: UIView?
	var reuseId: String?
	
	func update(_ config: ListItemConfiguration<T>?, canBeSelected: Bool = true) {
		self.backgroundColor = config?.backgroundColor
	}
}

extension CollectionViewCell {
	public func fill(_ value: Any?) {
		guard let listItem = value as? ListItem<T> else {
			return
		}

		let subview: UIView
		
		if let view = view, self.reuseId == listItem.reuseId {
			subview = view
		}
		else {
			subview = listItem.viewConstructor()
			view?.removeFromSuperview()
			view = subview
			self.contentView.addSubview(subview)
			subview.translatesAutoresizingMaskIntoConstraints = false
			LayoutUtils.fill(self.contentView,view: subview)
		}
		
		
		listItem.fill(listItem.value, subview)
		
		self.update(listItem.configuration, canBeSelected: listItem.onSelect != nil)
	}
}

