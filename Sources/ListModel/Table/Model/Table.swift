//
//  Table.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import UIKit

public struct Table<T: Equatable, HeaderT: Equatable, FooterT: Equatable> : Equatable {
	
	public typealias Section = TableSection<T,HeaderT,FooterT>
	public typealias Header = TableHeaderFooter<HeaderT>
	public typealias Footer = TableHeaderFooter<FooterT>
	public typealias Row = TableRow<T>
	
	public var sections : [Section]
	public var header: Header?
	public var footer: Footer?
	
	public var scrollInfo: TableScrollInfo?
	public var configuration: TableConfiguration?
	
	public init(sections: [Section],
				header: Header? = nil,
				footer: Footer? = nil,
				scrollInfo: TableScrollInfo? = nil,
				configuration: TableConfiguration? = nil)
	{
		self.sections = sections
		self.header = header
		self.footer = footer
		self.scrollInfo = scrollInfo
		self.configuration = configuration
	}
	
	public init(
		rows: [Row],
		header: Header? = nil,
		footer: Footer? = nil,
		scrollInfo: TableScrollInfo? = nil,
		configuration: TableConfiguration? = nil
	) {
		self.sections = [ Section.init(rows: rows) ]
		self.header = header
		self.footer = footer
		self.scrollInfo = scrollInfo
		self.configuration = configuration
	}
}
//
//public func ==<T, HeaderT, FooterT>(lhs: Table<T, HeaderT, FooterT>, rhs: Table<T, HeaderT, FooterT>) -> Bool {
//	guard lhs.sections == rhs.sections else { return false }
//	guard lhs.header == rhs.header else { return false }
//	guard lhs.footer == rhs.footer else { return false }
//
//	guard lhs.scrollInfo == rhs.scrollInfo else { return false }
//
//	return true
//}
