//
//  UIImage+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 30/3/17.
//
//

import UIKit

extension UIImage {
	public var aspectRatio: CGFloat {
		guard self.size.height != 0 else {
			return 1
		}
		
		return self.size.width/self.size.height
	}
}

