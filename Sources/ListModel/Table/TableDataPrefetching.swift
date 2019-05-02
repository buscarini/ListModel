//
//  TableDataPrefetching.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 02/05/2019.
//

import UIKit

public struct TableDataPrefetching {
	public var prefetchRows: (UITableView, [IndexPath]) -> Void
	public var cancelPrefetching: (UITableView, [IndexPath]) -> Void
	
	public init() {
		self.prefetchRows = { _, _ in }
		self.cancelPrefetching = { _, _ in }
	}
	
	public init(
		prefetchRows: @escaping (UITableView, [IndexPath]) -> Void,
		cancelPrefetching: @escaping (UITableView, [IndexPath]) -> Void
	) {
		self.prefetchRows = prefetchRows
		self.cancelPrefetching = cancelPrefetching
	}
}
