
import Foundation

public struct MultipleSelection<T: Hashable> {
	public typealias Storage = Set<T>

	public var selection = Storage()
	
	public init() {}
	public init(selection: Storage) {
		self.selection = selection
	}
}

extension MultipleSelection: SelectionProtocol {
	public func toggle(_ item: T?) -> MultipleSelection {
		guard let item = item else { return self }
		
		var newSelection = self.selection
		if self.selection.contains(item) {
			newSelection.remove(item)
		}
		else {
			newSelection.insert(item)
		}		

		return MultipleSelection(selection: newSelection)
	}

	public func isSelected(_ item: T) -> Bool {
		return self.selection.contains(item)
	}

	public var selectedItems: [T] {
		get {
			return Array(self.selection)
		}

		set {
			self.selection = Storage(newValue)
		}
	}
}
