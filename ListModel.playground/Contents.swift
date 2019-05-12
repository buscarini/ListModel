//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import ListModel


//DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//	let rows = Array(50...1)
//		.map { index in
//			"\(index)"
//		}
//		.map { string in
//			MyViewController.Table.row(
//				viewConstructor: UILabel.init,
//				id: string,
//				fill: { string, view in
//					view.text = string
//			},
//				value: string
//			)
//		}
//	
//	vc.dataSource.table = MyViewController.Table.init(sections: [
//		MyViewController.Table.Section(rows: rows)
//	])
//}


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
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		let rows = Array(1...50)
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
		
		//		dataSource.table = Table.init(sections: [
		//			Table.Section(rows: rows)
		//		])
	}
}


let vc = MyViewController.init(nibName: nil, bundle: nil)


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = vc
//PlaygroundPage.current.needsIndefiniteExecution = true
