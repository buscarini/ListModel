//
//  SearchTableViewDataSource.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 13/3/17.
//
//

import UIKit

public class SearchTableViewDataSource<T: Equatable, HeaderT: Equatable, FooterT: Equatable>: NSObject, UISearchResultsUpdating, UISearchControllerDelegate {

	private var cachedListConfig: TableConfiguration?
	
	public typealias DataSourceType = TableViewDataSource<T, HeaderT, FooterT>
	public typealias Table = DataSourceType.Table
	public typealias Configuration = DataSourceType.Configuration
	public typealias ItemConfiguration = DataSourceType.ItemConfiguration
	
	private var searching = false
	
	private var searchText = ""

	public var dataSource: DataSourceType {
		didSet {
			updateTable()
		}
	}
	
	public var searchController: UISearchController
	
	public typealias Filter = (T?, String) -> Bool
	public var filter: Filter
	
	public var table: Table? {
		willSet {
			if newValue?.header != nil {
				fatalError("Filtrable lists can't have headers. The table header is already used for the search bar.")
			}
		}
		didSet {
			updateTable()
		}
	}
	
	public required init(view: UITableView, filter: @escaping Filter) {
		self.dataSource = DataSourceType(view: view)
		self.searchController = UISearchController(searchResultsController: nil)
		self.filter = filter
		
		super.init()
		
		setupSearchController()
	}
	
	func setupSearchController() {
		searchController.dimsBackgroundDuringPresentation = true
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchResultsUpdater = self
		searchController.delegate = self
	}
	
	func updateTable() {
		let searchString = self.searchText //searchController.searchBar.text ?? ""
		
		var appliedList = table
		
//		let headerView = LayoutUtils.embedSearchBar(searchController.searchBar)
		appliedList?.header = Table.header(
			viewConstructor: {
				return self.searchController.searchBar
			},
			fill: { (_, v) in
				v.text = searchString
			},
			id: "search",
			reuseId: "search",
			value: nil
		)
				
		let config = appliedList?.configuration
		appliedList?.configuration = searching ? nil : config
		
		guard searchString.count > 0 else {
			self.dataSource.table = appliedList
			return
		}
		
		self.dataSource.table = appliedList.map(Table.filter { value in
				self.filter(value, searchString)
			})
	}

	// MARK: UISearchResultsUpdating
	public func updateSearchResults(for searchController: UISearchController) {
		self.searchText = searchController.searchBar.text ?? ""
	
		updateTable()
	}
	

	// MARK: UISearchControllerDelegate
	public func willPresentSearchController(_ searchController: UISearchController) {
		self.cachedListConfig = self.dataSource.table?.configuration
		searching = true
			
		updateTable()
	}
	
	public func willDismissSearchController(_ searchController: UISearchController) {
		self.cachedListConfig = nil
		searching = false
		
		updateTable()
	}
}
