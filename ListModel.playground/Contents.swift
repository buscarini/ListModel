//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import ListModel


let vc = MyViewController()

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

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
