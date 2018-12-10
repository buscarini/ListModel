//
//  ListSection.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import Foundation

public struct ListSection<T: Equatable, HeaderT: Equatable, FooterT: Equatable> : Equatable {
	public var items: [ListItem<T>]
	public var header: ListHeaderFooter<HeaderT>?
	public var footer: ListHeaderFooter<FooterT>?
	
	public init(items: [ListItem<T>], header: ListHeaderFooter<HeaderT>? = nil, footer: ListHeaderFooter<FooterT>? = nil) {
		self.items = items
		self.header = header
		self.footer = footer
	}
}

public func ==<T, HeaderT, FooterT>(lhs : ListSection<T, HeaderT, FooterT>, rhs: ListSection<T, HeaderT, FooterT>) -> Bool {
	guard lhs.items == rhs.items else { return false }
	guard lhs.header == rhs.header else { return false }
	guard lhs.footer == rhs.footer else { return false }
	return true
}

