import UIKit

public struct TableConfiguration: Equatable {
	public var fixedRowHeight: CGFloat?
	
	// MARK: Pull To Refresh
	public var onRefresh: (() -> ())?
	public var isRefreshing: Bool = false
	public var lastUpdated: Date?
	public var minimumRefreshInterval: TimeInterval?
	
	// MARK: Infinite Scrolling
	public var onLoadMore : (() -> ())?
	public var loadMoreEnabled : Bool = false
	
	public var hideEmptyCellsSeparators = true
	
	public init() {	}
	
	public init(fixedRowHeight: CGFloat? = nil,
				onRefresh : (() -> ())? = nil,
				isRefreshing: Bool = false,
				lastUpdated: Date? = nil,
				minimumRefreshInterval: TimeInterval? = nil,
				onLoadMore : (() -> ())? = nil,
				loadMoreEnabled : Bool = false)
	{
		self.fixedRowHeight = fixedRowHeight
		self.onRefresh = onRefresh
		self.isRefreshing = isRefreshing
		self.lastUpdated = lastUpdated
		self.minimumRefreshInterval = minimumRefreshInterval
		self.onLoadMore = onLoadMore
		self.loadMoreEnabled = loadMoreEnabled
	}
}

public func ==(lhs : TableConfiguration, rhs: TableConfiguration) -> Bool {
	guard lhs.fixedRowHeight == rhs.fixedRowHeight else { return false }
	
	guard lhs.isRefreshing == rhs.isRefreshing else { return false }
	
	guard lhs.lastUpdated == rhs.lastUpdated else { return false }
	guard lhs.minimumRefreshInterval == rhs.minimumRefreshInterval else { return false }
	
	guard lhs.loadMoreEnabled == rhs.loadMoreEnabled else { return false }
	
	guard lhs.hideEmptyCellsSeparators == rhs.hideEmptyCellsSeparators else { return false }
	
	return true
}
