import UIKit

public struct ListScrollInfo : Equatable {
	public var indexPath: IndexPath?
	public var position: ListScrollPosition
	public var animated: Bool = true
	
	public init(indexPath: IndexPath, position: ListScrollPosition) {
		self.indexPath = indexPath
		self.position = position
	}
}
