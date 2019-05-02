//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import ListModel


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

		let table = UITableView()
		table.translatesAutoresizingMaskIntoConstraints = false
		
		
        view.addSubview(table)
		
		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.topAnchor.constraint(equalTo: view.topAnchor),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
