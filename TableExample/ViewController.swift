//
//  ViewController.swift
//  TableExample
//
//  Created by José Manuel Sánchez Peñarroja on 12/05/2019.
//

import UIKit
import ListModel

public class MyViewController : UIViewController {
	
	public typealias DataSource = PlainTableViewDataSource<String>
	public typealias Table = DataSource.Table
	public var dataSource: DataSource?
	
	override public func loadView() {
		let view = UIView()
		view.backgroundColor = .white
		
		let table = UITableView.init()
		dataSource = DataSource(view: table)
		
		//				let table = dataSource.view
		table.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(table)
		
		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.topAnchor.constraint(equalTo: view.topAnchor),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
		
		//				dataSource = DataSource(view: table)
		
		self.view = view
	}
	
//	override public func viewDidLoad() {
//		super.viewDidLoad()
//
//		let rows = Array(1...50)
//			.map { index in
//				"\(index)"
//			}
//			.map { string in
//				Table.row(
//					viewConstructor: UILabel.init,
//					id: string,
//					fill: { string, view in
//						view.text = string
//				},
//					value: string
//				)
//		}
//
//		dataSource?.table = Table.init(sections: [
//			Table.Section(rows: rows)
//		])
//	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.shuffle()
		}
	}
	
	func shuffle() {
		let rows = Array(1...50)
			.shuffled()
			.map { index in
				"\(index)"
			}
			.map { string in
				Table.row(
					viewConstructor: UILabel.init,
					id: string,
					fill: { string, view in
						view.text = string
				},
					value: string
				)
		}
		
		dataSource?.table = Table.init(sections: [
			Table.Section(rows: rows)
			])
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.shuffle()
		}
	}
}
