import Foundation

public func removeDups<S : Sequence, T : Hashable>(_ source: S) -> [T] where S.Iterator.Element == T {
	var buffer = [T]()
	var added = Set<T>()
	for elem in source {
		if !added.contains(elem) {
			buffer.append(elem)
			added.insert(elem)
		}
	}
	return buffer
}

