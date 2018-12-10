//
//  Bundle+Utils.swift
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/3/16.
//
//

import Foundation
import UIKit

extension Bundle {

	func loadView(_ nibName : String?, owner: AnyObject) -> UIView? {
		guard let nibName = nibName else {
			return nil
		}
		
		if let views = self.loadNibNamed(nibName, owner: owner, options: nil) {
			return views.first as? UIView
		}
		
		return nil
	}	
}

