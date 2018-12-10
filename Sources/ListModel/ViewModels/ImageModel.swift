//
//  ImageModel.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 29/3/17.
//
//

import UIKit

public struct ImageModel {
	public var image: UIImage?
	public var contentMode = UIView.ContentMode.scaleAspectFit
	public var sizingMode = ImageSizingMode.auto
	public var alpha: CGFloat = 1
	public var isHidden = false

	public init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFit, sizingMode: ImageSizingMode = .auto, alpha: CGFloat = 1, isHidden: Bool = false) {
		self.image = image
		self.contentMode = contentMode
		self.sizingMode = sizingMode
		self.alpha = alpha
		self.isHidden = isHidden
	}
}

extension ImageModel {
	public func apply(view: UIImageView, containerView: UIView) {
		view.image = self.image
		view.contentMode = self.contentMode
		
		view.alpha = self.alpha
		view.isHidden = self.isHidden
		
		// TODO: Apply sizing mode
		view.removeConstraints(view.constraints)
		switch self.sizingMode {
			case .auto:
				guard let image = self.image else { break }
				
				let maxWidthProportion: CGFloat = 0.8
			
				if (image.size.height > containerView.bounds.size.height ) {
					ImageModel.fix(view: view, attribute: .height, value: containerView.bounds.size.height)
					ImageModel.ratio(view: view, value: image.aspectRatio)
				}
				else if (image.size.width > containerView.bounds.size.width * maxWidthProportion ) {
					ImageModel.fix(view: view, attribute: .width, value: containerView.bounds.size.width * maxWidthProportion)
					ImageModel.ratio(view: view, value: image.aspectRatio)
				}
				else {
					ImageModel.fix(view: view, attribute: .width, value: image.size.width)
					ImageModel.ratio(view: view, value: image.aspectRatio)
				}
			
			
			case .fixed(let w, let h):
				ImageModel.fix(view: view, attribute: .width, value: w)
				ImageModel.fix(view: view, attribute: .height, value: h)
			
			case .proportional(let w, let h):
				ImageModel.proportional(view: view, container: containerView, attribute: .width, value: w)
				ImageModel.proportional(view: view, container: containerView, attribute: .height, value: h)
			
			case .fixedWidth(let w, let ratio):
				ImageModel.fix(view: view, attribute: .width, value: w)
				ImageModel.ratio(view: view, value: ratio)
			
			case .proportionalWidth(let w, let ratio):
				ImageModel.proportional(view: view, container: containerView, attribute: .width, value: w)
				ImageModel.ratio(view: view, value: ratio)
			
			case .fixedHeight(let h, let ratio):
				ImageModel.fix(view: view, attribute: .height, value: h)
				ImageModel.ratio(view: view, value: ratio)
			
			case .proportionalHeight(let h, let ratio):
				ImageModel.proportional(view: view, container: containerView, attribute: .height, value: h)
				ImageModel.ratio(view: view, value: ratio)
		}
		
	}
	
	public static func fix(view: UIImageView, attribute: NSLayoutConstraint.Attribute, value: CGFloat) {
		view.addConstraint(NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value))
	}
	
	public static func proportional(view: UIImageView, container: UIView, attribute: NSLayoutConstraint.Attribute, value: CGFloat) {
		view.addConstraint(NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: container, attribute: attribute, multiplier: value, constant: 0))
	}

	public static func ratio(view: UIImageView, value: CGFloat) {
		view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: value, constant: 0))
	}
	
}

extension ImageModel: Equatable {}
public func ==(left: ImageModel, right: ImageModel) -> Bool {
	guard left.image == right.image else { return false }
	guard left.contentMode == right.contentMode else { return false }
	guard left.sizingMode == right.sizingMode else { return false }
	guard left.alpha == right.alpha else { return false }
	guard left.isHidden == right.isHidden else { return false }
	
	return true
}
