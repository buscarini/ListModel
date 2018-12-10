//
//  LabelModel.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 28/3/17.
//
//

import UIKit

public struct LabelModel {
	public var title: String?
	public var font: UIFont?
	public var textColor: UIColor?
	public var textAlign = NSTextAlignment.justified
	public var numberOfLines = 1
	public var alpha: CGFloat = 1
	public var isHidden = false

	public init(title: String?, font: UIFont? = nil, textColor: UIColor? = nil, textAlign: NSTextAlignment = .justified, alpha: CGFloat = 1, isHidden: Bool = false) {
		self.title = title
		self.font = font
		self.textColor = textColor
		self.textAlign = textAlign
		self.alpha = alpha
		self.isHidden = isHidden
	}
}

extension LabelModel {
	public func apply(view: UILabel) {
		view.text = self.title
		view.font ?= self.font
		view.textColor ?= self.textColor
		view.textAlignment = self.textAlign
		view.numberOfLines = self.numberOfLines
		view.alpha = self.alpha
		view.isHidden = self.isHidden
	}
}

extension LabelModel: Equatable {}
public func ==(left: LabelModel, right: LabelModel) -> Bool {
	guard left.title == right.title else { return false }
	guard left.font == right.font else { return false }
	guard left.textColor == right.textColor else { return false }
	guard left.textAlign == right.textAlign else { return false }
	guard left.numberOfLines == right.numberOfLines else { return false }
	guard left.alpha == right.alpha else { return false }
	guard left.isHidden == right.isHidden else { return false }
	
	return true
}
