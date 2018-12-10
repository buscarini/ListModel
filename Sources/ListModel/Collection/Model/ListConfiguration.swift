//
//  ListConfiguration.swift
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/3/16.
//
//

import UIKit

public struct ListConfiguration<T: Equatable>: Equatable {
	// MARK: Pull To Refresh
	public var onRefresh: (() -> ())?
	public var isRefreshing: Bool = false
	public var lastUpdated: Date?
	public var minimumRefreshInterval: TimeInterval?
	
	// MARK: Infinite Scrolling
	public var onLoadMore: (() -> ())?
	public var loadMoreEnabled : Bool = false
	
	public init() {	}
	
	public init(onRefresh : (() -> ())? = nil,
				isRefreshing: Bool = false,
				lastUpdated: Date? = nil,
				minimumRefreshInterval: TimeInterval? = nil,
				onLoadMore : (() -> ())? = nil,
				loadMoreEnabled : Bool = false)
	{
		self.onRefresh = onRefresh
		self.isRefreshing = isRefreshing
		self.lastUpdated = lastUpdated
		self.minimumRefreshInterval = minimumRefreshInterval
		self.onLoadMore = onLoadMore
		self.loadMoreEnabled = loadMoreEnabled
	}
}

public func ==<T>(lhs: ListConfiguration<T>, rhs: ListConfiguration<T>) -> Bool {
	guard (lhs.onRefresh == nil) == (rhs.onRefresh == nil) else { return false }
	guard lhs.lastUpdated == rhs.lastUpdated else { return false }
	guard lhs.minimumRefreshInterval == rhs.minimumRefreshInterval else { return false }
	
	guard lhs.loadMoreEnabled == rhs.loadMoreEnabled else { return false }

	return true
}

