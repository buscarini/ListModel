//
//  ListDataPrefetching.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 14/09/2020.
//

import UIKit

public struct ListDataPrefetching {
	public var prefetchRows: (UICollectionView, [IndexPath]) -> Void
	public var cancelPrefetching: (UICollectionView, [IndexPath]) -> Void
	
	public init() {
		self.prefetchRows = { _, _ in }
		self.cancelPrefetching = { _, _ in }
	}
	
	public init(
		prefetchRows: @escaping (UICollectionView, [IndexPath]) -> Void,
		cancelPrefetching: @escaping (UICollectionView, [IndexPath]) -> Void
	) {
		self.prefetchRows = prefetchRows
		self.cancelPrefetching = cancelPrefetching
	}
}
