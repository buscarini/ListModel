//
//  ConcurrencyTests.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 06/04/2020.
//

import Foundation
import UIKit
import XCTest
import ListModel

class ConcurrencyTests: XCTestCase {
	typealias DataSource = PlainTableViewDataSource<UInt32>
	typealias Table = DataSource.Table
	
	static func row(_ value: UInt32) -> Table.Row {
		Table.row(
			viewConstructor: UILabel.init,
			id: "\(value)",
			fill: { (value, label) in
				label.text = "\(String(describing: value))"
			},
			value: value
		)
	}
	func testConcurrent() {
		let count = 500
		
		let finish = expectation(description: "no crash")
		finish.expectedFulfillmentCount = count
		
		let view = UITableView(frame: .init(origin: .zero, size: .init(width: 300, height: 300)))
		let vc = UIViewController()
		let win = UIWindow.init(frame: UIScreen.main.bounds)
		win.rootViewController = vc
		vc.view.addSubview(view)
		
		let dataSource = DataSource(view: view)
		
		(1...count).forEach { _ in
			DispatchQueue.global().async {
				let numRows = Array(0...5000).randomElement()!
				let rows = (0...numRows).map { _ in
					ConcurrencyTests.row(arc4random())
				}
				
				dataSource.update(table: Table(sections: [
					Table.Section.init(rows: rows)
				])) {
					finish.fulfill()
				}
			}
		}
		
		waitForExpectations(timeout: 25, handler: nil)
	}
}
