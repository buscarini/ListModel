//
//  EmptyType.swift
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/3/16.
//
//

import Foundation

/// This is just an empty type that conforms to equatable to use when you don't have headers, for example
public struct EmptyType : Equatable {
	public init() {}
}

public func ==(left: EmptyType, right: EmptyType) -> Bool {
	return true
}
