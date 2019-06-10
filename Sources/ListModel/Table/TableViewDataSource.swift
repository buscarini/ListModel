import UIKit

public class TableViewDataSource<T:Equatable, HeaderT: Equatable, FooterT: Equatable> : NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching
	{
	
	public typealias Table = ListModel.Table<T,HeaderT, FooterT>
	public typealias Section = Table.Section
	public typealias Row = Table.Row
	
	public typealias Configuration = TableConfiguration
	public typealias RowConfiguration = TableRowConfiguration<T>

	fileprivate var estimatedHeights: [IndexPath: CGFloat] = [:]
	fileprivate var heights: [IndexPath: CGFloat] = [:]
	
	fileprivate var refreshControl: UIRefreshControl?
	
	fileprivate lazy var updateQueue: DispatchQueue = DispatchQueue(label: "TableViewDataSource update queue", attributes: [])

	public typealias SizeChanged = (CGSize) -> ()
	public var contentSizeChanged: SizeChanged?
	
	public typealias CellDisplayEvent = (UITableViewCell, UIView?, Row, IndexPath) -> ()
	public var onCellShow: CellDisplayEvent?
	public var onWillConfigureCell: CellDisplayEvent?
	public var onDidConfigureCell: CellDisplayEvent?
	public var onCellHide: CellDisplayEvent?
	
	public var scrollDelegate = ScrollViewDelegate()
	public var prefetching = TableDataPrefetching()
	
	private var needsUpdate = false
	
	public var view : UITableView {
		didSet {
			self.viewChanged()
		}
	}

	public required init(view: UITableView) {
		self.view = view
		
		self.refreshControl = UIRefreshControl()
	
		super.init()
		
		self.configurePullToRefresh()
		
		self.viewChanged()
	}
	
	fileprivate func viewChanged() {
		TableViewDataSource.registerViews(self.table,tableView: self.view)
			
		self.view.dataSource = self
		self.view.delegate = self
		self.view.prefetchDataSource = self
			
		self.view.rowHeight = UITableView.automaticDimension
		self.view.estimatedRowHeight = 44
		
		self.view.sectionHeaderHeight = UITableView.automaticDimension
		self.view.estimatedSectionHeaderHeight = 44
		self.view.sectionFooterHeight = UITableView.automaticDimension
		self.view.estimatedSectionFooterHeight = 44
		
		self.setDefaultHeaderFooter()
	}
	
	fileprivate func configurePullToRefresh() {
		self.refreshControl?.addTarget(self, action: #selector(TableViewDataSource.refresh(_:)), for: .valueChanged)
	}
	
	// Call this to update the layout of the table without reloading cells. Useful for cells with web views, for example
	public func invalidateLayout() {
		self.estimatedHeights = [:]
		self.heights = [:]
		self.view.beginUpdates()
		self.view.endUpdates()
	}
	
	private var _table: Table?
	
	private func layoutView() {
		var v: UIView? = self.view
		while v?.superview != nil {
			v = v?.superview
		}
		v?.layoutIfNeeded()
	}
	
	public var table: Table? {
		set {
			let oldValue = _table
			_table = newValue
			TableViewDataSource.registerViews(newValue,tableView: self.view)

//			layoutView()
//			guard self.view.bounds.size.width > 0 else {
//				self.needsUpdate = true
//				return
//			}
			
			self.update(oldValue, newTable: newValue, completion: {})
		}
		
		get {
			return _table
		}
	}
	
	public func update(table: Table?, completion: @escaping () -> Void) {		
		let oldValue = _table
		_table = table
		TableViewDataSource.registerViews(table,tableView: self.view)
		
//		layoutView()

//		guard self.view.bounds.size.width > 0 else {
//			self.needsUpdate = true
//			return
//		}
		
		self.update(oldValue, newTable: table, completion: completion)
	}
	
	public func startRefreshing() { self.isRefreshing = true }
	public func endRefreshing() { self.isRefreshing = false }
	
	public var isRefreshing: Bool {
		set {
			guard newValue != self.refreshControl?.isRefreshing else { return }
		
			if newValue {
				self.refreshControl?.beginRefreshing()
			}
			else {
				self.refreshControl?.endRefreshing()
			}
		}
		
		get {
			return self.refreshControl?.isRefreshing ?? false
		}
	}
	
	fileprivate func update(_ oldTable: Table?, newTable: Table?, completion: @escaping () -> Void) {
		self.updateSections(oldTable, newTable: newTable) {
			UIView.performWithoutAnimation {
				self.view.layoutIfNeeded()
			}
			
			self.updateHeaderFooter(newTable, oldTable: oldTable)
			
			
			self.updateScroll(newTable)
			self.updatePullToRefresh(oldTable, newTable: newTable)
			
			
			self.contentSizeChanged?(self.view.contentSize)
			
			self.needsUpdate = false
			
			UIView.performWithoutAnimation {
				self.view.tableHeaderView?.layoutIfNeeded()
				self.view.tableHeaderView = self.view.tableHeaderView
				self.view.tableFooterView?.layoutIfNeeded()
				self.view.tableFooterView = self.view.tableFooterView
			}
			
			completion()
		}
	}
	
	fileprivate func updateSections(_ oldTable: Table?, newTable: Table?, completion: (() -> ())?) {
		view.rowHeight = UITableView.automaticDimension
	
		let visibleIndexPaths = self.view.indexPathsForVisibleRows
		
		guard self.needsUpdate == false else {
			self.view.reloadData()
			completion?()
			return
		}
	
		self.updateQueue.async {
			if let oldTable = oldTable, let newTable = newTable, Table.sameItemsCount(oldTable, newTable) {
				let (changedIndexPaths, notVisibleIndexPaths) = Table.itemsChangedPaths(oldTable, newTable).partition {
					indexPath in
					return visibleIndexPaths?.contains(indexPath) ?? true
				}
				
				for indexPath in notVisibleIndexPaths {
					self.heights.removeValue(forKey: indexPath)
				}
				
				DispatchQueue.main.async {
					defer { completion?() }

					if changedIndexPaths.count>0 {
						self.heights = TableViewDataSource.updateIndexPathsWithFill(newTable, view: self.view, indexPaths: changedIndexPaths, cellHeights: self.heights)

						if let currentTable = self.table, currentTable == newTable, !Table.headersChanged(oldTable, newTable) {
							if #available(iOS 10.0, *) {
								self.view.beginUpdates()
								// Needed for accessory changes?? -> problem is it stops editing textfields, for example
								// seems to be here for accessory changes, but maybe it's not needed??
//								self.view.reloadRows(at: changedIndexPaths, with: .none)
								self.view.endUpdates()
							}
							else {
								self.view.reloadData()
							}
						}
						else {
							// If we are changing the table too quickly, we may get here. We shouldn't reload the table, because if we are editing a text field inside a cell, for example, we would stop editing.
							// Can this cause problems?
//							self.view.reloadData()
						}
					
					}
					else if Table.headersChanged(oldTable, newTable) {
						self.view.reloadData()
					}
					else {
						// NO CHANGES
					}
				}
			}
			else {
				DispatchQueue.main.async {
					self.view.reloadData()
					self.heights.removeAll()
					completion?()
				}
			}
		}
	}
	
	fileprivate func tableHeaderView(_ newTable: Table?) -> UIView? {
		let headerContainer = UIView()
		headerContainer.translatesAutoresizingMaskIntoConstraints = false
		
		
		
		if let headerView = newTable?.header?.createView(self) {
			headerView.translatesAutoresizingMaskIntoConstraints = false
			headerContainer.addSubview(headerView)
			return headerView
		}
		
		return nil
		
//		_ = headerView.map { self.layout(view: $0, inWidth: self.view.bounds.size.width) }
		
//		return headerView
	}
	
	fileprivate func tableFooterView(_ newTable: Table?) -> UIView? {
		if let footerView = newTable?.footer?.createView(self) {
			self.layout(view: footerView, inWidth: self.view.bounds.size.width)
			return footerView
		}
		else if let config = newTable?.configuration, config.hideEmptyCellsSeparators == false {
			return nil
		}
		else {
			let footerView = UIView()
			footerView.backgroundColor = UIColor.clear
			return footerView
		}
	}
	
	fileprivate func updateHeaderFooter(_ newTable: Table?, oldTable: Table?) {
		if
			self.needsUpdate ||
			oldTable?.header != newTable?.header ||
			(newTable?.header == nil && self.view.tableHeaderView != nil) ||
			(newTable?.header != nil && self.view.tableHeaderView == nil) ||
			TableViewDataSource.hasChanged(oldTable?.configuration, newTable?.configuration) {
			
			addTableHeader(newTable, oldTable: oldTable)
			NSLayoutConstraint.activate([
				self.view.tableHeaderView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
				self.view.tableHeaderView?.widthAnchor.constraint(equalTo: self.view.widthAnchor),
				self.view.tableHeaderView?.topAnchor.constraint(equalTo: self.view.topAnchor)
				].compactMap { $0 })
			
			self.view.tableHeaderView?.layoutIfNeeded()
			self.view.tableHeaderView = self.view.tableHeaderView
		}
		
		addTableFooter(newTable, oldTable: oldTable)
		self.view.tableFooterView?.layoutIfNeeded()
		self.view.tableFooterView = self.view.tableFooterView
	}
	
	fileprivate func addTableHeader(_ newTable: Table?, oldTable: Table?) {
//		if oldTable?.header != newTable?.header || self.needsUpdate || TableViewDataSource.hasChanged(oldTable?.configuration, newTable?.configuration) {
			self.view.tableHeaderView = self.tableHeaderView(newTable)
//		}
	}
	
	fileprivate func addTableFooter(_ newTable: Table?, oldTable: Table?) {
		if oldTable?.footer != newTable?.footer || self.needsUpdate || TableViewDataSource.hasChanged(oldTable?.configuration, newTable?.configuration)  {
			self.view.tableFooterView = self.tableFooterView(newTable)
		}
	}
	
	func setDefaultHeaderFooter() {
		self.view.tableHeaderView = self.tableHeaderView(nil)
		self.view.tableFooterView = self.tableFooterView(nil)
	}
	
	private static func hasChanged(_ oldConfig: TableConfiguration?, _ newConfig: TableConfiguration?) -> Bool {
		return oldConfig != newConfig
	}
	
	private func layout(view: UIView, inWidth width: CGFloat) {
		guard width > 0 else {
			self.needsUpdate = true
			return
		}
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		let sameWidth = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
		
		view.addConstraint(sameWidth)
		
		view.setNeedsLayout()
		view.layoutSubviews()
		
		view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		
		view.removeConstraint(sameWidth)
		view.translatesAutoresizingMaskIntoConstraints = true
	}
	
	fileprivate func updateScroll(_ newTable: Table?) {
		guard let scrollInfo = newTable?.scrollInfo, let indexPath = scrollInfo.indexPath else {
			return
		}
	
		self.view.scrollToRow(at: indexPath as IndexPath, at: TableViewDataSource.scrollPositionWithPosition(scrollInfo.position), animated: scrollInfo.animated)
	}
	
	fileprivate func updatePullToRefresh(_ oldTable: Table?, newTable: Table?) {
		if newTable?.configuration?.onRefresh != nil {
			if #available(iOS 10.0, *) {
				if let viewRefreshControl = self.view.refreshControl {
					self.refreshControl = viewRefreshControl
					self.configurePullToRefresh()
				}
				else {
					self.view.refreshControl = self.refreshControl ?? UIRefreshControl()
					self.configurePullToRefresh()
				}
			} else {
				let refreshControl = self.refreshControl ?? UIRefreshControl()
				if refreshControl.superview != self.view {
					self.view.addSubview(refreshControl)
				}
			}
		}
		else {
			if #available(iOS 10.0, *) {
				self.view.refreshControl = nil
			}
			else {
				
				self.refreshControl?.removeFromSuperview()
			}
		}
		
		self.isRefreshing = newTable?.configuration?.isRefreshing ?? false
	}
	
	public static func readCellHeights(_ view: UITableView, heights: [IndexPath : CGFloat]) -> [IndexPath : CGFloat]? {
		
		guard let visibleIndexPaths = view.indexPathsForVisibleRows else { return nil }
		
		var result = heights
		for indexPath in visibleIndexPaths {
			if let cell = view.cellForRow(at: indexPath) {
				result[indexPath] = cell.frame.size.height
			}
		}
		
		return result
	}
	
	public static func updateIndexPathsWithFill(_ newTable: Table, view : UITableView, indexPaths: [IndexPath], cellHeights : [IndexPath: CGFloat]) -> [IndexPath: CGFloat] {
		var finalCellHeights = cellHeights
		for indexPath in indexPaths {
			guard let tableCell = view.cellForRow(at: indexPath) else {
				continue
			}
			
			let cell = tableCell as! TableViewCell<T>
			
			let item = Table.rowAt(newTable, indexPath: indexPath)
			cell.fill(item!)

			finalCellHeights[indexPath] = nil
		}
		
		return finalCellHeights
	}
	
	public static func updateIndexPathsWithFillAndReload(_ newTable: Table, view : UITableView, indexPaths: [IndexPath], cellHeights : [IndexPath: CGFloat]) -> [IndexPath: CGFloat] {
		let (editingPaths, nonEditingPaths) = self.editingIndexPaths(newTable, view: view, indexPaths: indexPaths)
		for (indexPath, cell) in editingPaths {
			
			let cell = cell as! TableViewCell<T>
			
			let item = Table.rowAt(newTable, indexPath: indexPath)
			cell.fill(item!)
		
		}

		view.reloadRows(at: nonEditingPaths, with: .none)
		
		return cellHeights
	}
	
	public static func editingIndexPaths(_ newTable: Table, view : UITableView, indexPaths: [IndexPath]) -> (editing: [(IndexPath,UITableViewCell?)], nonEditing: [IndexPath]) {
	
		let editingPaths = indexPaths.map {
							indexPath -> (IndexPath, UITableViewCell?) in
							let cell = view.cellForRow(at: indexPath)
							return (indexPath,cell)
						}.filter {
							(indexPath, cell) in
							return cell?.isEditing ?? false
						}
						
		let nonEditingPaths = indexPaths.filter {
			indexPath in
			let cell = view.cellForRow(at: indexPath)
			return !(cell?.isEditing ?? false)
		}

		return (editing: editingPaths, nonEditing: nonEditingPaths)
	}
	
	public static func scrollPositionWithPosition(_ position: TableScrollPosition) -> UITableView.ScrollPosition {
		switch (position) {
		case (.start):
			return .top
		case (.middle):
			return .middle
		case (.end):
			return .bottom
		}
	}
	
	public static func registerViews(_ table: Table?, tableView : UITableView?) {
		guard let table = table else { return }
		guard let tableView = tableView else { return }
		
		let allReusableIds = Table.allReusableIds(table)
		for reusableId in allReusableIds {
			tableView.register(TableViewCell<T>.self, forCellReuseIdentifier: reusableId)
		}
	}
	
	// MARK: Pull to Refresh
	@objc func refresh(_ sender: AnyObject?) {
		guard let table = self.table else { return }
		guard let configuration = table.configuration else { return }
		
		configuration.onRefresh?()
	}
	
	// MARK: UITableViewDataSource
	public func numberOfSections(in tableView: UITableView) -> Int {
		return table?.sections.count ?? 0
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let table = self.table else {
			return 0
		}
		
		return table.sections[section].rows.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let table = self.table else {
			fatalError("Table is required. We shouldn't be here")
		}

		guard let row = Table.rowAt(table, indexPath: indexPath) else {
			fatalError("Index out of bounds. This shouldn't happen")
		}
		
		let reusableId = row.reuseId
		let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath)
		
		self.configureCell(cell, row: row, indexPath: indexPath)
		
		return cell
	}
	
	public func configureCell(_ cell: UITableViewCell, row: Row, indexPath: IndexPath) {
		
		guard let cell = cell as? TableViewCell<T> else { return }
		
		onWillConfigureCell?(cell, cell.view, row, indexPath)
		
		let configuration = row.configuration
		cell.accessoryType = configuration?.accessoryType.cellAccessoryType ?? .none
		cell.accessoryView = configuration?.accessoryType.cellAccessoryView
		
		_ = configuration?.indentationLevel.map { cell.indentationLevel = $0 }
		_ = configuration?.indentationWidth.map { cell.indentationWidth = $0 }
		_ = configuration?.separatorInset.map { cell.separatorInset = $0 }
		
		cell.fill(row)
		
		onDidConfigureCell?(cell, cell.view, row, indexPath)
	}
	
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let table = self.table else { return nil }
		guard Table.sectionInsideBounds(table, section: section) else { return nil }
		
		return table.sections[section].header?.createView(self)
	}
	
	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let table = self.table else { return nil }
		guard Table.sectionInsideBounds(table, section: section) else { return nil }

		return table.sections[section].footer?.createView(self)
	}
	
	// MARK: UITableViewDataPrefetching
	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		self.prefetching.prefetchRows(tableView, indexPaths)
	}
	
	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		self.prefetching.cancelPrefetching(tableView, indexPaths)
	}
	
	// MARK: UITableViewDelegate
//	public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//		guard
//			let table = self.table,
//			let tableItem = table.rowAt(Table, indexPath: indexPath)
//		else {
//			return true
//		}
//
//		guard tableItem.onSelect != nil else {
//			return false
//		}
//
//		let configuration = tableItem.configuration as? TableRowConfiguration<T>
//		return configuration?.selectionStyle != UITableViewCellSelectionStyle.none
//	}
	
	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		if let tableConfiguration = self.table?.configuration, let fixedHeight = tableConfiguration.fixedRowHeight {
			return fixedHeight
		}
		return self.estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
	}
	
	open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let tableConfiguration = self.table?.configuration, let fixedHeight = tableConfiguration.fixedRowHeight {
			return fixedHeight
		}
		return self.heights[indexPath] ?? UITableView.automaticDimension
	}
	
	open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let table = self.table else { return 0 }
		guard Table.sectionInsideBounds(table, section: section) else { return 0 }

		guard table.sections[section].header != nil else { return 0 }

		return UITableView.automaticDimension
	}
	
	open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard let table = self.table else { return 0 }
		guard Table.sectionInsideBounds(table, section: section) else { return 0 }

		guard table.sections[section].footer != nil else { return 0 }

		return UITableView.automaticDimension
	}
	
	open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		self.estimatedHeights[indexPath] = cell.frame.size.height
		self.heights[indexPath] = cell.frame.size.height
		
			guard
			let aCell = cell as? TableViewCell<T>,
			let view = aCell.view,
			let table = self.table,
			let item = Table.rowAt(table, indexPath: indexPath)
		else { return }
		
		self.onCellShow?(aCell, view, item, indexPath)

	}
	
	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard
			let aCell = cell as? TableViewCell<T>,
			let view = aCell.view,
			let table = self.table,
			let item = Table.rowAt(table, indexPath: indexPath)
		else { return }
		
		self.onCellHide?(aCell, view, item, indexPath)
	}
	
	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: Move this to a different place
		
		guard let table = self.table else {
			return
		}
		
		let row = table.sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row]
		
		let configuration = row.configuration
		
		let animated = row.onSelect != nil && configuration?.selectionStyle != .noStyle
		
		tableView.deselectRow(at: indexPath, animated: animated)
		
		row.onSelect?(row)
	}
	
	open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		guard let table = self.table else {
			return
		}
		
		let row = table.sections[indexPath.section].rows[indexPath.row]
		
		let configuration = row.configuration
		configuration?.onAccessoryTap?(row)
	}
	
	open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		guard
			let table = self.table,
			Table.indexPathInsideBounds(table, indexPath: indexPath)
		else {
			return []
		}
		
		let row = table.sections[indexPath.section].rows[indexPath.row]
		
		let configuration = row.configuration
		
		return configuration?.swipeActions.map {
			action in
			return TableViewDataSource.rowAction(tableView, row: row, action: action)
		} ?? []
	}
	
	public static func rowAction(_ tableView: UITableView, row: Row, action: TableRowAction<T>) -> UITableViewRowAction {
		let rowAction = UITableViewRowAction(style: self.rowStyle(action.style), title: action.title) { _,_ in
			action.action(row)
			tableView.setEditing(false, animated: true)
		}
		rowAction.backgroundColor = action.tintColor
		return rowAction
	}
	
	public static func rowStyle(_ style : TableRowActionStyle) -> UITableViewRowAction.Style {
		switch style {
		case .default:
			return .default
		case .normal:
			return .normal
		}
	}
	
	// MARK: UIScrollViewDelegate
	public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		return scrollDelegate.shouldScrollToTop?(scrollView) ?? true
	}
	
	public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		scrollDelegate.didEndScrollingAnimation?(scrollView)
	}
	
	public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		scrollDelegate.willBeginDecelerating?(scrollView)
	}
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		scrollDelegate.didEndDecelerating?(scrollView)
	}
	
	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		scrollDelegate.didZoom?(scrollView)
	}
	
	public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
		scrollDelegate.didScrollToTop?(scrollView)
	}
	
	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		scrollDelegate.willBeginDragging?(scrollView)
	}
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		scrollDelegate.didScroll?(scrollView)
	}
	public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		scrollDelegate.willEndDragging?(scrollView, velocity, targetContentOffset)
	}
	
	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		scrollDelegate.didEndDragging?(scrollView, decelerate)
	}
	
	public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
		scrollDelegate.didChangeAdjustedContentInset?(scrollView)
	}
	
	public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		scrollDelegate.willBeginZooming?(scrollView, view)
	}
	
	public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		scrollDelegate.didEndZooming?(scrollView, view, scale)
	}
	
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return scrollDelegate.viewForZooming?(scrollView)
	}
}
