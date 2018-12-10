import UIKit
import XCTest
import ListModel

class Tests: XCTestCase {
	
	typealias StringTable = Table<String, String, String>
	
	static func model(_ string: String?) -> TitleViewModel {
		return TitleViewModel(title: string ?? "")
	}
    
    func testIsEmpty() {
		let list = StringTable.tableFrom(
			[],
			viewConstructor: {
				return UIView.loadNib(TitleView.self, owner: self)
			},
			fill: { (m, v) in
				v.fill(Tests.model(m))
			}
		)
		
		XCTAssert(StringTable.isEmpty(list))
		
		let list2 = StringTable.tableFrom(
			[ "1", "2" ],
			viewConstructor: {
				return UIView.loadNib(TitleView.self, owner: self)
		},
			fill: { (m, v) in
				v.fill(Tests.model(m))
			}
		)
		
		XCTAssert(!StringTable.isEmpty(list2))
    }
	
	func testItemAt() {
		let createView = { return UIView.loadNib(TitleView.self, owner: self) }
		let fill: (String?, TitleView) -> Void = { (m, v) in v.fill(Tests.model(m))
		}
		let reuseId = "cell"
		
		let item1 = StringTable.row(viewConstructor: createView, id: "1", reuseId: reuseId, fill: fill, value: "1")
		let item2 = StringTable.row(viewConstructor: createView, id: "2", reuseId: reuseId, fill: fill, value: "2")
		let item3 = StringTable.row(viewConstructor: createView, id: "3", reuseId: reuseId, fill: fill, value: "3")
		
		let section1 = StringTable.Section(rows: [ item1, item2 ])
		let section2 = StringTable.Section(rows: [ item3 ])
	
		let list = StringTable(sections: [section1, section2])
		
		XCTAssert(StringTable.rowAt(list, indexPath: IndexPath(row: 0, section: 0)) == item1)
		XCTAssert(StringTable.rowAt(list, indexPath: IndexPath(row: 1, section: 0)) == item2)
		
		XCTAssert(StringTable.rowAt(list, indexPath: IndexPath(row: 0, section: 1)) == item3)
	}

	func testIndexPathInsideBounds() {
		let createView = { return UIView.loadNib(TitleView.self, owner: self) }
		let fill: (String?, TitleView) -> Void = { (m, v) in v.fill(Tests.model(m))
		}
		let reuseId = "cell"
		
		let item1 = StringTable.row(viewConstructor: createView, id: "1", reuseId: reuseId, fill: fill, value: "1")
		let item2 = StringTable.row(viewConstructor: createView, id: "2", reuseId: reuseId, fill: fill, value: "2")
		let item3 = StringTable.row(viewConstructor: createView, id: "3", reuseId: reuseId, fill: fill, value: "3")
		
		let section1 = StringTable.Section(rows: [ item1, item2 ])
		let section2 = StringTable.Section(rows: [ item3 ])
	
		let list = StringTable(sections: [section1, section2])

		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: 0, section: 0)) == true)
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: 1, section: 0)) == true)
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: 0, section: 1)) == true)
		
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: 0, section: -1)) == false)
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: -1, section: 0)) == false)
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: 0, section: 2)) == false)
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: 2, section: 0)) == false)
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: -1, section: 1)) == false)
		XCTAssert(StringTable.indexPathInsideBounds(list, indexPath: IndexPath(row: 1, section: 1)) == false)
	}
	
	func testIndexOf() {
		let createView = { return UIView.loadNib(TitleView.self, owner: self) }
		let fill: (String?, TitleView) -> Void = { (m, v) in v.fill(Tests.model(m))
		}
		let reuseId = "cell"
		
		let item1 = StringTable.row(viewConstructor: createView, id: "1", reuseId: reuseId, fill: fill, value: "1")
		let item2 = StringTable.row(viewConstructor: createView, id: "2", reuseId: reuseId, fill: fill, value: "2")
		let item3 = StringTable.row(viewConstructor: createView, id: "3", reuseId: reuseId, fill: fill, value: "3")
		
		let section1 = StringTable.Section(rows: [ item1, item2 ])
		let section2 = StringTable.Section(rows: [ item3 ])
	
		let list = StringTable(sections: [section1, section2])
		
		XCTAssert(StringTable.index(list, of: item1)?.row == 0)
		XCTAssert(StringTable.index(list, of: item1)?.section == 0)
		
		XCTAssert(StringTable.index(list, of: item2)?.row == 1)
		XCTAssert(StringTable.index(list, of: item2)?.section == 0)
		
		XCTAssert(StringTable.index(list, of: item3)?.row == 0)
		XCTAssert(StringTable.index(list, of: item3)?.section == 1)
	}


	func testSectionInsideBounds() {
		let createView = { return UIView.loadNib(TitleView.self, owner: self) }
		let fill: (String?, TitleView) -> Void = { (m, v) in v.fill(Tests.model(m))
		}
		let reuseId = "cell"
		
		let item1 = StringTable.row(viewConstructor: createView, id: "1", reuseId: reuseId, fill: fill, value: "1")
		let item2 = StringTable.row(viewConstructor: createView, id: "2", reuseId: reuseId, fill: fill, value: "2")
		let item3 = StringTable.row(viewConstructor: createView, id: "3", reuseId: reuseId, fill: fill, value: "3")
		
		let section1 = StringTable.Section(rows: [ item1, item2 ])
		let section2 = StringTable.Section(rows: [ item3 ])
	
		let list = StringTable(sections: [section1, section2])

		XCTAssert(StringTable.sectionInsideBounds(list, section: -1) == false)
		XCTAssert(StringTable.sectionInsideBounds(list, section: 0) == true)
		XCTAssert(StringTable.sectionInsideBounds(list, section: 1) == true)
		XCTAssert(StringTable.sectionInsideBounds(list, section: 2) == false)
		XCTAssert(StringTable.sectionInsideBounds(list, section: 3) == false)
	}
	
	func testSameItemsCount() {
		let createView = { return UIView.loadNib(TitleView.self, owner: self) }
		let fill: (String?, TitleView) -> Void = { (m, v) in v.fill(Tests.model(m))
		}
		let reuseId = "cell"
		
		let item1 = StringTable.row(viewConstructor: createView, id: "1", reuseId: reuseId, fill: fill, value: "1")
		let item2 = StringTable.row(viewConstructor: createView, id: "2", reuseId: reuseId, fill: fill, value: "2")
		let item3 = StringTable.row(viewConstructor: createView, id: "3", reuseId: reuseId, fill: fill, value: "3")
		
		let section1 = StringTable.Section(rows: [ item1, item2 ])
		let section2 = StringTable.Section(rows: [ item3 ])
	
		let list = StringTable(sections: [section1, section2])

		XCTAssert(StringTable.sameItemsCount(list, list) == true)
		
		let list2 = StringTable.tableFrom(
			[ "1", "2" ],
			viewConstructor: {
				return UIView.loadNib(TitleView.self, owner: self)
			},
				fill: { (m, v) in
					v.fill(Tests.model(m))
			}
		)
		
		XCTAssert(StringTable.sameItemsCount(list, list2) == false)
		
		let list3 = StringTable.tableFrom(
			[ "4", "1" ],
			viewConstructor: {
				return UIView.loadNib(TitleView.self, owner: self)
		},
			fill: { (m, v) in
				v.fill(Tests.model(m))
		}
		)
		
		XCTAssert(StringTable.sameItemsCount(list2, list3) == true)
	}

	func testHeadersChanged() {
		let createView = { return UIView.loadNib(TitleView.self, owner: self) }
		let fill: (String?, TitleView) -> Void = { (m, v) in v.fill(Tests.model(m))
		}
		let reuseId = "cell"
		
		let item1 = StringTable.row(viewConstructor: createView, id: "1", reuseId: reuseId, fill: fill, value: "1")
		let item2 = StringTable.row(viewConstructor: createView, id: "2", reuseId: reuseId, fill: fill, value: "2")
		let item3 = StringTable.row(viewConstructor: createView, id: "3", reuseId: reuseId, fill: fill, value: "3")
		
		let section1 = StringTable.Section(
			rows: [ item1, item2 ],
			header: StringTable.header(viewConstructor: createView, fill: { (m, v) in
				v.fill(Tests.model(m))
			}, id: "header", reuseId: "header", value: "header"))
		
		let section2 = StringTable.Section(rows: [ item3 ])
	
		let list = StringTable(sections: [section1, section2])

		XCTAssert(StringTable.headersChanged(list, list) == false)


		let section1a = StringTable.Section(
			rows: [ item1, item2 ],
			header: StringTable.header(viewConstructor: createView, fill: { (m, v) in
				v.fill(Tests.model(m))
			}, id: "header", reuseId: "header", value: "header"))
		let section2b = StringTable.Section(rows: [ item3 ])
	
		let list2 = StringTable(sections: [section1a, section2b])
		
		XCTAssert(StringTable.headersChanged(list, list2) == false)
		
		let section1c = StringTable.Section(
			rows: [ item1, item2 ],
			header: StringTable.header(viewConstructor: createView, fill: { (m, v) in
				v.fill(Tests.model(m))
			}, id: "header", reuseId: "header", value: "header_"))
		let section2d = StringTable.Section(rows: [ item3 ])
	
		let list3 = StringTable(sections: [section1c, section2d])
		
		XCTAssert(StringTable.headersChanged(list2, list3) == true)
	}
	
	func testItemsChangedPaths() {
		let createView = { return UIView.loadNib(TitleView.self, owner: self) }
		let fill: (String?, TitleView) -> Void = { (m, v) in v.fill(Tests.model(m))
		}
		let reuseId = "cell"
		
		let item1 = StringTable.row(viewConstructor: createView, id: "1", reuseId: reuseId, fill: fill, value: "1")
		let item2 = StringTable.row(viewConstructor: createView, id: "2", reuseId: reuseId, fill: fill, value: "2")
		let item3 = StringTable.row(viewConstructor: createView, id: "3", reuseId: reuseId, fill: fill, value: "3")
	
		let section1 = StringTable.Section(
			rows: [ item1, item2 ],
			header: StringTable.header(viewConstructor: createView, fill: { (m, v) in
				v.fill(Tests.model(m))
			}, id: "header", reuseId: "header", value: "header"))
		let section2 = StringTable.Section(rows: [ item3 ])
	
		let list = StringTable(sections: [section1, section2])
		
		XCTAssert(StringTable.itemsChangedPaths(list, list).count == 0)
		
		
		let section1a = StringTable.Section(
			rows: [ item1, item3 ],
			header: StringTable.header(viewConstructor: createView, fill: { (m, v) in
				v.fill(Tests.model(m))
			}, id: "header", reuseId: "header", value: "header"))
		let section2b = StringTable.Section(rows: [ item3 ])
	
		let list2 = StringTable(sections: [section1a, section2b])
		
		let changes = StringTable.itemsChangedPaths(list, list2)
		XCTAssert(changes.count == 1)
		XCTAssert(changes.first?.section == 0)
		XCTAssert(changes.first?.row == 1)
	}

}

