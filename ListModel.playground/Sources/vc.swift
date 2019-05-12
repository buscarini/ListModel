import UIKit
import ListModel

//public class MyViewController : UIViewController {
//	
//	public typealias DataSource = PlainTableViewDataSource<String>
//	public typealias Table = DataSource.Table
//	public var dataSource = DataSource(view: UITableView())
//	
//	override public func loadView() {
//		let view = UIView()
//		view.backgroundColor = .white
//		
//		
////		let table = dataSource.view
////		table.translatesAutoresizingMaskIntoConstraints = false
////		view.addSubview(table)
////		
////		NSLayoutConstraint.activate([
////			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////			table.topAnchor.constraint(equalTo: view.topAnchor),
////			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
////			])
//		
////		dataSource = DataSource(view: table)
//		
//		self.view = view
//	}
//	
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
////		dataSource.table = Table.init(sections: [
////			Table.Section(rows: rows)
////		])
//	}
//}
