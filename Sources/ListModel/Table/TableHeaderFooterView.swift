//
//  TableHeaderFooterView.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 11/09/2020.
//

import UIKit

open class TableHeaderFooterView<T: Equatable>: UITableViewHeaderFooterView {
	public var view: UIView?
	var reuseId: String?
}

extension TableHeaderFooterView {
	public func fill(_ row: TableHeaderFooter<T>) {
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
	}
}
