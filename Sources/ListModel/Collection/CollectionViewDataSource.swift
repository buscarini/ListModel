import UIKit

public class CollectionViewDataSource<T: Equatable, HeaderT: Equatable, FooterT: Equatable>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {

	public typealias List = ListModel.List<T, HeaderT, FooterT>
	public typealias Section = List.Section
	public typealias Item = List.Item

	public typealias Configuration = ListConfiguration<T>
	public typealias ItemConfiguration = ListItemConfiguration<T>

	fileprivate var refreshControl: UIRefreshControl?
	
	public typealias SizeChanged = (CGSize) -> ()
	public var contentSizeChanged: SizeChanged?
	
	public typealias CellDisplayEvent = (UICollectionViewCell, UIView?, Item, IndexPath) -> ()
	public var onCellShow: CellDisplayEvent?
	public var onWillConfigureCell: CellDisplayEvent?
	public var onDidConfigureCell: CellDisplayEvent?
	public var onCellHide: CellDisplayEvent?
	
	public var prefetching = ListDataPrefetching()
	public var scrollDelegate = ScrollViewDelegate()
	
	public var flowLayoutDelegate = FlowLayoutDelegate()
	
	fileprivate lazy var updateQueue: DispatchQueue = DispatchQueue(label: "TableViewDataSource update queue", attributes: [])

	public init(view: UICollectionView) {
		self.view = view
		
		self.refreshControl = UIRefreshControl()

		super.init()
		
		self.refreshControl?.addTarget(self, action: #selector(CollectionViewDataSource.refresh(_:)), for: .valueChanged)

		self.viewChanged()
	}
	
	public var view : UICollectionView {
		didSet {
			self.viewChanged()
		}
	}
	
	fileprivate func viewChanged() {
		CollectionViewDataSource.registerViews(self.list, collectionView: self.view)
			
		self.view.dataSource = self
		self.view.delegate = self			
	}
	
	private var _list: List?

	public var list: List? {
		get {
			return _list
		}
		
		set {
			let oldValue = _list
			_list = newValue
			CollectionViewDataSource.registerViews(self.list, collectionView: self.view)
			self.update(oldValue, newList: list, completion: {})
		}
	}
	
	public func update(list: List?, completion: @escaping () -> Void) {
		let oldValue = _list
		_list = list
		
		CollectionViewDataSource.registerViews(self.list, collectionView: self.view)
		self.update(oldValue, newList: list, completion: completion)
	}
	
	public func reloadVisible(completion: @escaping () -> Void) {
		guard let list = self.list else {
			completion()
			return
		}
		
		DispatchQueue.main.async {
			let paths = self.view.indexPathsForVisibleItems

			Self.updateIndexPathsWithFill(
				list,
				view: self.view,
				indexPaths: paths
			)
			
			completion()
		}
	}
	
	public static func updateIndexPathsWithFill(
		_ newList: List,
		view: UICollectionView,
		indexPaths: [IndexPath]
	) {
		for indexPath in indexPaths {
			guard let listCell = view.cellForItem(at: indexPath) else {
				continue
			}
			
			let cell = listCell as! CollectionViewCell<T>
			
			guard let item = List.itemAt(newList, indexPath: indexPath) else {
				view.reloadData()
				return
			}
			
			cell.fill(item)
		}
	}
	
	fileprivate func update(
		_ oldList: List?,
		newList: List?,
		completion: @escaping () -> Void
	) {
		self.updateView(oldList, newList: newList) {
			self.refreshControl?.endRefreshing()
			if let refreshControl = self.refreshControl , newList?.configuration?.onRefresh != nil {
				self.view.addSubview(refreshControl)
				self.view.alwaysBounceVertical = true
			}
			else {
				self.refreshControl?.removeFromSuperview()
			}
			
			if let list = newList, let scrollInfo = self.list?.scrollInfo, let indexPath = scrollInfo.indexPath, List.indexPathInsideBounds(list, indexPath: indexPath) {
				self.view.scrollToItem(at: indexPath as IndexPath, at:  CollectionViewDataSource.scrollPositionWithPosition(scrollInfo.position, collectionView: self.view), animated: scrollInfo.animated)
			}
			
			self.contentSizeChanged?(self.view.contentSize)
			
			completion()
		}
	}
	
	fileprivate static func headersChanged(_ oldList: List?, _ newList: List?) -> Bool {
		guard let oldList = oldList, let newList = newList else {
			return false
		}
		
		return List.headersChanged(oldList, newList)
	}
	
	fileprivate func updateView(
		_ oldList: List?,
		newList: List?,
		completion: @escaping () -> Void
	) {
		guard Self.headersChanged(oldList, newList) == false else {
			self.view.reloadData()
			completion()
			return
		}
		
		if	let oldList = oldList, let newList = newList, List.sameItemsCount(oldList, newList) {
			
			let visibleIndexPaths = view.indexPathsForVisibleItems
			
			self.updateQueue.async {
				let (changedIndexPaths, _) = List.itemsChangedPaths(oldList, newList)
					.partition(by: visibleIndexPaths.contains)

				DispatchQueue.main.async {
					guard changedIndexPaths.count > 0 else {
						completion()
						return
					}
					
					for indexPath in changedIndexPaths {
						guard let cell = self.view.cellForItem(at: indexPath) as? CollectionViewCell<T> else { continue }
						let listItem = newList.sections[indexPath.section].items[indexPath.item]
						
						self.onWillConfigureCell?(cell, cell.view, listItem, indexPath)
						
						cell.fill(listItem)
						
						self.onDidConfigureCell?(cell, cell.view, listItem, indexPath)
					}
					
					completion()
				}
			}
		}
		else {
			self.view.reloadData()
			completion()
		}
	}
	
	public static func scrollPositionWithPosition(_ position: ListScrollPosition, collectionView: UICollectionView?) -> UICollectionView.ScrollPosition {
		guard let collectionView = collectionView else {
			return UICollectionView.ScrollPosition()
		}
		
		let scrollDirection : UICollectionView.ScrollDirection
		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			scrollDirection = flowLayout.scrollDirection
		}
		else {
			scrollDirection = .vertical
		}
		
		switch (position,scrollDirection) {
			case (.start,.horizontal):
				return .left
			case (.start,.vertical):
				return .top
			case (.middle,.vertical):
				return .centeredVertically
			case (.middle,.horizontal):
				return .centeredHorizontally
			case (.end, .vertical):
				return .bottom
			case (.end, .horizontal):
				return .right
			@unknown default:
				return .left
		}
	}
	
	public static func registerViews(_ list: List?, collectionView: UICollectionView?) {
		guard let list = list, let collectionView = collectionView else { return }
		
		let allReusableIds = List.allReusableIds(list)
		for reusableId in allReusableIds {
			collectionView.register(CollectionViewCell<T>.self, forCellWithReuseIdentifier: reusableId)
		}
		
		let allHeaderIds = List.allHeaderIds(list)
		for reusableId in allHeaderIds {
			collectionView.register(CollectionViewReusableView<HeaderT>.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusableId)
		}
		
		let allFooterIds = List.allFooterIds(list)
		for reusableId in allFooterIds {
			collectionView.register(CollectionViewReusableView<FooterT>.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reusableId)
		}
	}
	
	// MARK: Pull to Refresh
	@objc func refresh(_ sender: AnyObject?) {
		guard let list = self.list else { return }
		guard let configuration = list.configuration else { return }
		
		configuration.onRefresh?()
	}
	
	// MARK: UICollectionViewDataSource
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.list?.sections.count ?? 0
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard
			let list = self.list,
			list.sections.count > section
		else {
			return 0
		}
		
		return list.sections[section].items.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard
			let list = self.list,
			let listItem = List.itemAt(list, indexPath: indexPath)
		else {
			print("List is required. We shouldn't be here")
			return UICollectionViewCell()
		}

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listItem.reuseId, for: indexPath)
		let fillCell = cell as! CollectionViewCell<T>
		
		onWillConfigureCell?(cell, fillCell.view, listItem, indexPath)
		
		
		fillCell.fill(listItem)
		
		onDidConfigureCell?(cell, fillCell.view, listItem, indexPath)
		
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let section = indexPath.section
		
		guard
			let list = self.list,
			List.sectionInsideBounds(list, section: section)
		else {
			print("Invalid situation. Something bad happened")
			return UICollectionReusableView()
		}
		
		let view: UICollectionReusableView
		switch kind {
			case UICollectionView.elementKindSectionHeader:
				guard let header = list.sections[section].header else {
					print("Header not found for section \(section)")
					return UICollectionReusableView()
				}
				
				let viewId = header.reuseId
				
				view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewId, for: indexPath)
		
				let cell = view as! CollectionViewReusableView<HeaderT>
				cell.fill(header)
			
			case UICollectionView.elementKindSectionFooter:
				guard let footer = list.sections[section].footer else {
					print("Footer not found for section \(section)")
					return UICollectionReusableView()
				}
				
				view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footer.reuseId, for: indexPath)
		
				let cell = view as! CollectionViewReusableView<FooterT>
				cell.fill(footer)
			
			default:
				print("Unsupported supplementary view kind")
				return UICollectionReusableView()

		}
		
		return view
	}
	
	// MARK : UICollectionViewDelegate
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard
			let list = self.list,
			List.indexPathInsideBounds(list, indexPath: indexPath),
			let listItem = List.itemAt(list, indexPath: indexPath)
		else {
			return
		}
		
		if let onSelect = listItem.onSelect {
			onSelect(listItem)
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard
			let aCell = cell as? CollectionViewCell<T>,
			let view = aCell.view,
			let list = self.list,
			let item = List.itemAt(list, indexPath: indexPath)
		else {
			return
		}
		
		self.onCellShow?(aCell, view, item, indexPath)
		
	}
	
	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard
			let aCell = cell as? CollectionViewCell<T>,
			let view = aCell.view,
			let list = self.list,
			let item = List.itemAt(list, indexPath: indexPath)
		else {
			return
		}
		
		self.onCellHide?(aCell, view, item, indexPath)

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
	
	// MARK: UICollectionViewDataSourcePrefetching
	public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		self.prefetching.prefetchRows(collectionView, indexPaths)
	}
	
	public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
		self.prefetching.cancelPrefetching(collectionView, indexPaths)
	}
	
	// MARK: UICollectionViewFlowDelegate
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
		return flowLayoutDelegate.sizeForItem?(indexPath, collectionViewLayout, collectionView)
			?? flowLayout?.itemSize
			?? UICollectionViewFlowLayout.automaticSize
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
		return flowLayoutDelegate.sectionInset?(section, collectionViewLayout, collectionView)
			?? flowLayout?.sectionInset
			?? .zero
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
		return flowLayoutDelegate.minSectionLineSpacing?(section, collectionViewLayout, collectionView)
			?? flowLayout?.minimumLineSpacing
			?? 0
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
		return flowLayoutDelegate.minSectionItemSpacing?(section, collectionViewLayout, collectionView)
			?? flowLayout?.minimumInteritemSpacing
			?? 0
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		guard list?.sections[section].header != nil else {
			return .zero
		}
		
		let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
		return flowLayoutDelegate.headerReferenceSize?(section, collectionViewLayout, collectionView)
			?? flowLayout?.headerReferenceSize
			?? UICollectionViewFlowLayout.automaticSize
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		guard list?.sections[section].footer != nil else {
			return .zero
		}
		
		let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
		return flowLayoutDelegate.footerReferenceSize?(section, collectionViewLayout, collectionView)
			?? flowLayout?.footerReferenceSize
			?? UICollectionViewFlowLayout.automaticSize
	}
}
