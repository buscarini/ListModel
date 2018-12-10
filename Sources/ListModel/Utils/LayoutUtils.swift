import Foundation
import UIKit

public struct LayoutUtils {
	public static func fill(_ container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriority.required) {
		LayoutUtils.fillH(container, view: view, priority: priority)
		LayoutUtils.fillV(container, view: view, priority: priority)
	}
	
	public static func fillV(_ container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriority.required) {
		let constraints : [NSLayoutConstraint]
		
		if #available(iOS 9.0, *) {
			constraints = [
				container.topAnchor.constraint(equalTo: view.topAnchor),
				container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			]
		} else {
			constraints = [
				NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
			]
		}
		
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)
	}

	public static func fillH(_ container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriority.required) {
		let constraints : [NSLayoutConstraint]
		
		if #available(iOS 9.0, *) {
			constraints = [
				container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				container.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		} else {
			constraints = [
				NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
			]
		}
		
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)

	}
		
	public static func equal(_ view1: UIView,view2 : UIView, attribute: NSLayoutConstraint.Attribute, multiplier : CGFloat = 1, constant : CGFloat = 0, priority : UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view1, attribute: attribute, relatedBy: .equal, toItem: view2, attribute: attribute, multiplier: multiplier, constant: constant)
		constraint.priority = priority
		return constraint
	}

	public static func equal(_ view : UIView, attribute: NSLayoutConstraint.Attribute, constant : CGFloat, priority : UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
		constraint.priority = priority
		return constraint
	}

	public static func embedSearchBar(_ view: UISearchBar) -> ContainerView<UISearchBar> {
		let container = ContainerView<UISearchBar>()
		container.addSubview(view)
	
		let topC = NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let leftC = NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		
		let bottomC = NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		bottomC.priority = UILayoutPriority(rawValue: 999)
		
		let rightC = NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		rightC.priority = UILayoutPriority(rawValue: 999)
		
		let heightC = self.equal(container, attribute: .height, constant: 44)
	
		container.addConstraints([ topC, leftC, bottomC, rightC, heightC ])
		
		return container
	}
	
	public static func embedToAllowResize<V: UIView>(_ view: V) -> ContainerView<V> {
		let container = ContainerView<V>()
		container.addSubview(view)
	
		let topC = NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let leftC = NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		
		let bottomC = NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		bottomC.priority = UILayoutPriority(rawValue: 990)
		
		let rightC = NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		rightC.priority = UILayoutPriority(rawValue: 990)
	
		container.addConstraints([ topC, leftC, bottomC, rightC ])
		
		return container
	}
}

