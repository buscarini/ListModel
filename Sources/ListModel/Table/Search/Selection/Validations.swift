
import Foundation

typealias SelectionValidation<T> = (_ all: [T], _ selected: [T]) -> Bool

public func onlyOne<T>(_ all: [T], _ selected: [T]) -> Bool {
	return selected.count == 1
}

public func oneOrMore<T>(_ all: [T], _ selected: [T]) -> Bool {
	return selected.count >= 1
}

public func zeroOrMore<T>(_ all: [T], _ selected: [T]) -> Bool {
	return selected.count >= 0
}

public func all<T>(_ all: [T], _ selected: [T]) -> Bool {
	return selected.count == all.count
}
