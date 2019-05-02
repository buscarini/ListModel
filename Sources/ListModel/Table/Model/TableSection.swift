//
//  TableSection.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import Foundation
import DifferenceKit

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
//
//extension TableSection: Differentiable {
//	public var differenceIdentifier: String {
//		return id
//	}
//}
//
//extension TableSection: DifferentiableSection {
//	public init<C>(source: TableSection<T, HeaderT, FooterT>, elements: C) where C: Collection, C.Element == TableRow<T> {
//		self.init(rows: elements)
//	}
//	
//	@inlinable
//	public var differenceIdentifier: TableRow<T>.DifferenceIdentifier {
//		return model.differenceIdentifier
//	}
//	
//	public var elements: [TableRow<T>] {
//		return rows
//	}	
//}

public struct TableSectionDiffModel<HeaderT: Equatable, FooterT: Equatable>: Equatable, Differentiable {
	public var index: Int
	public var header: TableHeaderFooter<HeaderT>?
	public var footer: TableHeaderFooter<FooterT>?
	
	init(_ index: Int, header: TableHeaderFooter<HeaderT>?, footer: TableHeaderFooter<FooterT>?) {
		self.index = index
		self.header = header
		self.footer = footer
	}
	
	public var differenceIdentifier: Int {
		return index
	}
}
