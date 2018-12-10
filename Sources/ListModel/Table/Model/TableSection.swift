//
//  TableSection.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import Foundation

public struct TableSection<T: Equatable, HeaderT: Equatable, FooterT: Equatable> : Equatable {
	public var rows: [TableRow<T>]
	public var header: TableHeaderFooter<HeaderT>?
	public var footer: TableHeaderFooter<FooterT>?
	
	public init(rows: [TableRow<T>], header: TableHeaderFooter<HeaderT>? = nil, footer: TableHeaderFooter<FooterT>? = nil) {
		self.rows = rows
		self.header = header
		self.footer = footer
	}
}

public func ==<T, HeaderT, FooterT>(lhs : TableSection<T, HeaderT, FooterT>, rhs: TableSection<T, HeaderT, FooterT>) -> Bool {
	guard lhs.rows == rhs.rows else { return false }
	guard lhs.header == rhs.header else { return false }
	guard lhs.footer == rhs.footer else { return false }
	return true
}

