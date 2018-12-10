import UIKit

public struct TableScrollInfo : Equatable {
	public var indexPath: IndexPath?
	public var position: TableScrollPosition
	public var animated: Bool = true
	
	public init(indexPath: IndexPath, position: TableScrollPosition) {
		self.indexPath = indexPath
		self.position = position
	}
}
