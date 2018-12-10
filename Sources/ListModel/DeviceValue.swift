//
//  DeviceValue.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 30/5/16.
//
//

import Foundation
import UIKit

public struct DeviceValue<T> {
	public var defaultValue: T
	public var defaultLandscape: T?
	
	public var iPhone: T?
	public var iPad: T?
	
	public var iPhoneLandscape: T?
	public var iPadLandscape: T?
	
	public func value(_ orientation: UIDeviceOrientation) -> T {
		let idiom = UIDevice.current.userInterfaceIdiom
		switch (idiom, orientation.isPortrait, orientation.isLandscape) {
			case (.pad, true, false):
				return self.iPad ?? self.defaultValue
			case (.pad, false, true):
				return self.iPadLandscape ?? self.defaultLandscape ?? self.defaultValue
			case (.phone, true, false):
				return self.iPhone ?? self.defaultValue
			case (.phone, false, true):
				return self.iPhoneLandscape ?? self.defaultLandscape ?? self.defaultValue
			case (_, false, true):
				return self.defaultLandscape ?? self.defaultValue
			default:
				return self.defaultValue
		}
	}
	
	public init(defaultValue: T) {
		self.defaultValue = defaultValue
	}
}
