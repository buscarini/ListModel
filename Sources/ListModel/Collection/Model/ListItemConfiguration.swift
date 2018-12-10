//
//  ListItemConfiguration.swift
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 1/3/16.
//
//

import UIKit

public struct ListItemConfiguration<T: Equatable>: Equatable {
	public var backgroundColor: UIColor?

	public static var `default`: ListItemConfiguration {
		return ListItemConfiguration()
	}
}
