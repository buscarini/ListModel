import Foundation

public extension Table {
	
	static func isEmpty(_ table: Table) -> Bool {
		return table.sections.map { $0.rows.count }.reduce(0, +) == 0
	}
	
	static func rowAt(_ table: Table, indexPath: IndexPath) -> Row? {
		guard Table.indexPathInsideBounds(table, indexPath: indexPath) else { return nil }
		
		return table.sections[indexPath.section].rows[indexPath.row]
	}
	
	static func index(_ table: Table, of: Row) -> IndexPath? {
		return table.sections.enumerated().reduce(nil) { (acc, both) in
			let item = both.1.rows.enumerated().first { both in
				both.1 == of
			}
			
			guard let row = item else {
				return acc
			}
			
			return IndexPath(item: row.0, section: both.0)
		}
	}
	
	static func indexPathInsideBounds(_ table: Table, indexPath: IndexPath) -> Bool {
		guard indexPath.count == 2 else { // Avoid crash with table view sometimes returning invalid index paths
			return false
		}
		
		switch (indexPath.section, indexPath.row) {
		case (let section, _) where section >= table.sections.count:
			return false
		case (let section,_) where section<0:
			return false
		case (let section, let row) where row >= table.sections[section].rows.count || row<0:
			return false
		default:
			return true
		}
	}
	
	var scrollToBottomInfo: TableScrollInfo {
		let indexPath = lastIndexPath ?? IndexPath(row: 0, section: 0)
		return TableScrollInfo(indexPath: indexPath, position: .start)
	}
	
	var lastIndexPath: IndexPath? {
		
		guard let section = self.lastNonEmptySection else { return nil }
	
		return IndexPath(row: self.sections[section].rows.count-1, section: section)
	}
	
	var lastNonEmptySection: Int? {
		for i in self.sections.count-1 ... 0 {
			if self.sections[i].rows.count > 0 {
				return i
			}
		}
		
		return nil
	}
	
	static func sectionInsideBounds(_ table: Table, section: Int) -> Bool {
		return table.sections.count > section && section >= 0
	}
	
	static func sameItemsCount(_ table1: Table, _ table2: Table) -> Bool {
		guard (table1.sections.count == table2.sections.count) else { return false }
		
		return zip(table1.sections,table2.sections).filter {
			(section1, section2) in
			return section1.rows.count != section2.rows.count
		}.count==0
	}
	
	static func headersChanged(_ table1: Table, _ table2: Table) -> Bool {
		let headers1 = table1.sections.map {
			return $0.header
		}.compactMap { $0 }
		
		let headers2 = table2.sections.map {
			return $0.header
		}.compactMap { $0 }
		
		let footers1 = table1.sections.map {
			return $0.footer
		}.compactMap { $0 }
		
		let footers2 = table2.sections.map {
			return $0.footer
		}.compactMap { $0 }

		
		return headers1 != headers2 || footers1 != footers2
	}
	
	static func itemsChangedPaths(_ table1: Table, _ table2: Table) -> [IndexPath] {
		assert(sameItemsCount(table1, table2))
		
		let processed = zip(table1.sections, table2.sections).map {
			arg -> [Row?] in
			let (section1, section2) = arg
			return zip(section1.rows,section2.rows).map(newChangedItem)
		}
		
		return zip(processed,Array(0..<processed.count)).map {
			(rows, sectionIndex) -> [IndexPath] in
			let numRows = rows.count
			let indexes = zip(rows,Array(0..<numRows))
				.map { // Convert non nil items to their indexes
					(row, index) in
					row.map { _ in index }
				}
				.compactMap{$0} // Remove nil items
			
				return indexes.map { IndexPath(row: $0, section: sectionIndex) } // Convert indexes to indexpath
			
			}.flatMap{$0} // Flatten [[IndexPath]]
	}
	
	static func newChangedItem(_ row1: Row, _ row2: Row) -> Row? {
		return row1 == row2 ? nil : row2
	}
	
	static func allReusableIds(_ table: Table) -> [String] {
		return removeDups(table.sections.flatMap {
			section in
			return section.rows.map {
				$0.reuseId
			}
		})
	}
	
	static func allHeaderIds(_ table: Table) -> [String] {
		return allSectionIds(table) { section in
			guard let header = section.header else {
				return nil
			}
			
			return header.reuseId
		}
	}
	
	static func allFooterIds(_ table: Table) -> [String] {
		return allSectionIds(table) { section in
			guard let footer = section.footer else {
				return nil
			}
			
			return footer.reuseId
		}
	}
	
	fileprivate static func allSectionIds(_ table: Table, idForSection: (Table.Section) -> String?) -> [String] {
		return removeDups(table.sections.map(idForSection).compactMap{ $0 })
	}
}


