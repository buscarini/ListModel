//
//  ContainerView.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 10/12/2018.
//

import UIKit

public class ContainerView<V: UIView>: UIView {
	public var subview: V? {
		didSet {
			for view in self.subviews {
				view.removeFromSuperview()
			}
			
			guard let s = subview else { return }
			self.addSubview(s)
		}
	}
}
