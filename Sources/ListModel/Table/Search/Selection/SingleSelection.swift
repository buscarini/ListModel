
import Foundation

public struct SingleSelection<T: Hashable> {
	public var selected: T?
	
	public init() {}
	public init(selected: T?) {
		self.selected = selected
	}
}

extension SingleSelection: SelectionProtocol {
	var allowsContinue: Bool {
		return selected != nil
	}

	public func toggle(_ item: T?) -> SingleSelection {
		guard let item = item else { return self }

		let final: T? = item == self.selected ? nil : item
		return SingleSelection(selected: final)
	}

	public func isSelected(_ item: T) -> Bool {
		return self.selected == item
	}

	public var selectedItems: [T] {
		get {
			return [self.selected].compactMap { $0 }
		}

		set {
			self.selected = newValue.first
		}
	}
}
