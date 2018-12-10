//
//  CollectionViewReusableView.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/4/17.
//
//

import UIKit

class CollectionViewReusableView<T: Equatable>: UICollectionReusableView {
	var view: UIView?
	var reuseId: String?
}

extension CollectionViewReusableView {
	public func fill(_ value: Any?) {
		guard let item = value as? ListHeaderFooter<T> else {
			return
		}
		defer {
			self.reuseId = item.reuseId
		}

		let subview : UIView
		
		if let view = view, self.reuseId == item.reuseId {
			subview = view
		}
		else {
			subview = item.viewConstructor()
			view?.removeFromSuperview()
			view = subview
			self.addSubview(subview)
			subview.translatesAutoresizingMaskIntoConstraints = false
			LayoutUtils.fill(self,view: subview)
		}
		
		item.fill(item.value, subview)
	}
}

