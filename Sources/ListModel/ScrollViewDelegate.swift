//
//  ScrollViewDelegate.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 01/03/2019.
//

import UIKit

public struct ScrollViewDelegate {
	public typealias Callback = (UIScrollView) -> Void
	
	public var didScroll: Callback?
	public var didZoom: Callback?
	public var willBeginDecelerating: Callback?
	public var didEndDecelerating: Callback?
	public var didScrollToTop: Callback?
	public var didEndScrollingAnimation: Callback?
	public var shouldScrollToTop: ((UIScrollView) -> Bool)?
	
	public var willBeginDragging: Callback?
	public var willEndDragging: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void)?
	public var didEndDragging: ((UIScrollView, Bool) -> Void)?
	
	public var willBeginZooming: ((UIScrollView, UIView?) -> Void)?
	public var didEndZooming: ((UIScrollView, UIView?, CGFloat) -> Void)?
	public var viewForZooming: ((UIScrollView) -> UIView?)?
	
	public var didChangeAdjustedContentInset: Callback?
	
	public init() {}
	
	public init(
		didScroll: Callback?,
		didZoom: Callback?,
		willBeginDecelerating: Callback?,
		didEndDecelerating: Callback?,
		didScrollToTop: Callback?,
		didEndScrollingAnimation: Callback?,
		shouldScrollToTop: ((UIScrollView) -> Bool)?,
		
		willBeginDragging: Callback?,
		willEndDragging: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void)?,
		didEndDragging: ((UIScrollView, Bool) -> Void)?,
		
		willBeginZooming: ((UIScrollView, UIView?) -> Void)?,
		didEndZooming: ((UIScrollView, UIView?, CGFloat) -> Void)?,
		viewForZooming: ((UIScrollView) -> UIView?)?,
		
		didChangeAdjustedContentInset: Callback?
	) {
		self.didScroll = didScroll
		self.didZoom = didZoom
		self.willBeginDecelerating = willBeginDecelerating
		self.didEndDecelerating = didEndDecelerating
		self.didScrollToTop = didScrollToTop
		self.didEndScrollingAnimation = didEndScrollingAnimation
		self.shouldScrollToTop = shouldScrollToTop
		
		self.willBeginDragging = willBeginDragging
		self.willEndDragging = willEndDragging
		self.didEndDragging = didEndDragging
		
		self.willBeginZooming = willBeginZooming
		self.didEndZooming = didEndZooming
		self.viewForZooming = viewForZooming
		
		self.didChangeAdjustedContentInset = didChangeAdjustedContentInset
	}
}
