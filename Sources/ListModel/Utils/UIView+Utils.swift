//
//  UIView+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 31/5/16.
//
//

import UIKit

extension UIView {
	func size(_ forWidth: CGFloat) -> CGSize {
		return self.systemLayoutSizeFitting(CGSize(width: forWidth, height: UIView.layoutFittingCompressedSize.height))
	}

	public static var autoNibName: String {
		return String(describing: self)
	}
	
	public static var autoBundle: Bundle? {
		return Bundle(for: self)
	}
	
	public static func loadNib<V: UIView>(_ type: V.Type, owner: AnyObject, nibName: String? = nil, bundle: Bundle? = nil) -> V {
		let nibName = nibName ?? V.autoNibName
		let bundle = bundle ?? V.autoBundle
		
		let views = bundle!.loadNibNamed(nibName, owner: owner, options: nil)!
		return views.first! as! V
	}
}
