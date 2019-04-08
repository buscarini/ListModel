
import UIKit

public extension ListHeaderFooter {
	func createView(_ owner: NSObject) -> UIView {
		let view = self.viewConstructor()
		
		self.fill(self.value, view)
		
		return view
	}
}
