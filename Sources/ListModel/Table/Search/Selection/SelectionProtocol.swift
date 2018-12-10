
import Foundation

public protocol SelectionProtocol {
	associatedtype Element
	init()

	func toggle(_ item: Element?) -> Self
	func isSelected(_ item: Element) -> Bool

	var selectedItems: [Element] { get set }
}
