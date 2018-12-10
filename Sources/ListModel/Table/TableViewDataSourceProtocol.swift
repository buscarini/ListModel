//
//  TableViewDataSourceProtocol.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 29/3/17.
//
//

import UIKit

public protocol TableViewDataSourceProtocol {
	associatedtype T: Equatable
	associatedtype HeaderT: Equatable
	associatedtype FooterT: Equatable
	
	typealias Table = ListModel.Table<T,HeaderT, FooterT>
	typealias Section = Table.Section
	typealias Row = Table.Row
	
	typealias Configuration = TableConfiguration
	typealias ItemConfiguration = TableRowConfiguration<T>

	
    var table: ListModel.Table<T, HeaderT, FooterT>? { get set }

	init(view: UITableView)
}

extension TableViewDataSource: TableViewDataSourceProtocol {}
//extension SearchTableViewDataSource: TableViewDataSourceProtocol {}
