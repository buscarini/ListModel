//
//  ViewSizingMode.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 30/3/17.
//
//

import UIKit

public enum ImageSizingMode {
	case auto
	case fixed(width: CGFloat, height: CGFloat)
	case proportional(width: CGFloat, height: CGFloat)
	case fixedWidth(width: CGFloat, ratio: CGFloat)
	case proportionalWidth(width: CGFloat, ratio: CGFloat)
	case fixedHeight(height: CGFloat, ratio: CGFloat)
	case proportionalHeight(height: CGFloat, ratio: CGFloat)
	
}

extension ImageSizingMode: Equatable {}
public func ==(left: ImageSizingMode, right: ImageSizingMode) -> Bool {

	switch (left, right) {
		case (.auto, .auto):
			return true
		case (.fixed(let a1, let b1), .fixed(let a2, let b2)):
			return a1 == a2 && b1 == b2
		case (.proportional(let a1, let b1), .proportional(let a2, let b2)):
			return a1 == a2 && b1 == b2
		case (.fixedWidth(let a1, let b1), .fixedWidth(let a2, let b2)):
			return a1 == a2 && b1 == b2
		case (.proportionalWidth(let a1, let b1), .proportionalWidth(let a2, let b2)):
			return a1 == a2 && b1 == b2
		case (.fixedHeight(let a1, let b1), .fixedHeight(let a2, let b2)):
			return a1 == a2 && b1 == b2
		case (.proportionalHeight(let a1, let b1), .proportionalHeight(let a2, let b2)):
			return a1 == a2 && b1 == b2
		
		default:
			return true
	}
}

