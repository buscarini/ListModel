import Foundation

public extension List {
	
	static func isEmpty(_ list: List) -> Bool {
		return list.sections.map { $0.items.count }.reduce(0, +) == 0
	}
	
	static func itemAt(_ list: List, indexPath: IndexPath) -> Item? {
		guard List.indexPathInsideBounds(list, indexPath: indexPath) else { return nil }
		
		return list.sections[indexPath.section].items[indexPath.row]
	}
	
	static func index(_ list: List, of: Item) -> IndexPath? {
		return list.sections.enumerated().reduce(nil) { (acc, both) in
			let item = both.1.items.enumerated().first { both in
				both.1 == of
			}
			
			guard let listItem = item else {
				return acc
			}
			
			return IndexPath(item: listItem.0, section: both.0)
		}
	}
	
	static func indexPathInsideBounds(_ list: List, indexPath: IndexPath) -> Bool {
		switch (indexPath.section, indexPath.row) {
		case (let section, _) where section >= list.sections.count:
			return false
		case (let section,_) where section<0:
			return false
		case (let section, let row) where row >= list.sections[section].items.count || row<0:
			return false
		default:
			return true
		}
	}
	
	var scrollToBottomInfo: ListScrollInfo {
		let indexPath = lastIndexPath ?? IndexPath(row: 0, section: 0)
		return ListScrollInfo(indexPath: indexPath, position: .start)
	}
	
	var lastIndexPath: IndexPath? {
		
		guard let section = self.lastNonEmptySection else { return nil }
	
		return IndexPath(row: self.sections[section].items.count-1, section: section)
	}
	
	var lastNonEmptySection: Int? {
		for i in self.sections.count-1 ... 0 {
			if self.sections[i].items.count > 0 {
				return i
			}
		}
		
		return nil
	}
	
	static func sectionInsideBounds(_ list: List, section: Int) -> Bool {
		return list.sections.count > section && section >= 0
	}
	
	static func sameItemsCount(_ table1: List, _ table2: List) -> Bool {
		guard (table1.sections.count == table2.sections.count) else { return false }
		
		return zip(table1.sections,table2.sections).filter {
			(section1, section2) in
			return section1.items.count != section2.items.count
		}.count==0
	}
	
	static func headersChanged(_ list1: List, _ list2: List) -> Bool {
		let headers1 = list1.sections.map {
			return $0.header
		}.compactMap { $0 }
		
		let headers2 = list2.sections.map {
			return $0.header
		}.compactMap { $0 }
		
		let footers1 = list1.sections.map {
			return $0.footer
		}.compactMap { $0 }
		
		let footers2 = list2.sections.map {
			return $0.footer
		}.compactMap { $0 }

		
		return headers1 != headers2 || footers1 != footers2
	}
	
	static func itemsChangedPaths(_ list1: List, _ list2: List) -> [IndexPath] {
		assert(sameItemsCount(list1, list2))
		
		let processed = zip(list1.sections, list2.sections).map {
			arg -> [Item?] in
			let (section1, section2) = arg
			return zip(section1.items,section2.items).map(newChangedItem)
		}
		
		return zip(processed,Array(0..<processed.count)).map {
			(items, sectionIndex) -> [IndexPath] in
			let numItems = items.count
			let indexes = zip(items,Array(0..<numItems))
				.map { // Convert non nil items to their indexes
					(item, index) in
					item.map { _ in index }
				}
				.compactMap{$0} // Remove nil items
			
				return indexes.map { IndexPath(row: $0, section: sectionIndex) } // Convert indexes to indexpath
			
			}.flatMap{$0} // Flatten [[IndexPath]]
	}
	
	static func newChangedItem(_ row1: Item, _ row2: Item) -> Item? {
		return row1 == row2 ? nil : row2
	}
	
	static func allReusableIds(_ list: List) -> [String] {
		return removeDups(list.sections.flatMap {
			section in
			return section.items.map {
				$0.reuseId
			}
		})
	}
	
	static func allHeaderIds(_ list: List) -> [String] {
		return allSectionIds(list) { section in
			guard let header = section.header else {
				return nil
			}
			
			return header.reuseId
		}
	}
	
	static func allFooterIds(_ list: List) -> [String] {
		return allSectionIds(list) { section in
			guard let footer = section.footer else {
				return nil
			}
			
			return footer.reuseId
		}
	}
	
	fileprivate static func allSectionIds(_ list: List, idForSection: (List.Section) -> String?) -> [String] {
		return removeDups(list.sections.map(idForSection).compactMap{ $0 })
	}
}


