//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import ListModel

class MyViewController : UIViewController {
	public typealias DataSource = TableViewDataSource<String, String, String>
	public typealias Table = DataSource.Table
	
	public var dataSource: DataSource?
	
	let table = UITableView()
	
    override func loadView() {
		
		let view = UIView(frame: CGRect(x: 150, y: 200, width: 320, height: 600))
		
		table.backgroundColor = .white
		table.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(table)
		
        self.view = view
		
		NSLayoutConstraint.activate([
			table.topAnchor.constraint(equalTo: view.topAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			])
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.dataSource = DataSource(view: table)
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let model = [ "Blah", "Blih", "Bluh" ]
		let rows = model.map {
			Table.row(
				viewConstructor: {
					return UILabel()
			},
				id: $0,
				reuseId: "cell",
				fill: { (m, v) in
					v.text = m
			},
				value: $0)
		}
		
		dataSource?.table = Table(sections: [ Table.Section(rows: rows) ])
	}
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
