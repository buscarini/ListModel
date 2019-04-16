//
//  FlowLayoutDelegate.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 16/04/2019.
//

import Foundation
import UIKit

public struct FlowLayoutDelegate {
	public var sizeForItem: ((IndexPath, UICollectionViewLayout, UICollectionView) -> CGSize)?
	public var sectionInset: ((Int, UICollectionViewLayout, UICollectionView) -> UIEdgeInsets)?
	public var minSectionLineSpacing: ((Int, UICollectionViewLayout, UICollectionView) -> CGFloat)?
	public var minSectionItemSpacing: ((Int, UICollectionViewLayout, UICollectionView) -> CGFloat)?
	public var headerReferenceSize: ((Int, UICollectionViewLayout, UICollectionView) -> CGSize)?
	public var footerReferenceSize: ((Int, UICollectionViewLayout, UICollectionView) -> CGSize)?
	
	public init() {}
	public init(
		sizeForItem: ((IndexPath, UICollectionViewLayout, UICollectionView) -> CGSize)?,
		sectionInset: ((Int, UICollectionViewLayout, UICollectionView) -> UIEdgeInsets)?,
		minSectionLineSpacing: ((Int, UICollectionViewLayout, UICollectionView) -> CGFloat)?,
		minSectionItemSpacing: ((Int, UICollectionViewLayout, UICollectionView) -> CGFloat)?,
		headerReferenceSize: ((Int, UICollectionViewLayout, UICollectionView) -> CGSize)?,
		footerReferenceSize: ((Int, UICollectionViewLayout, UICollectionView) -> CGSize)?
	) {
		self.sizeForItem = sizeForItem
		self.sectionInset = sectionInset
		self.minSectionLineSpacing = minSectionLineSpacing
		self.minSectionItemSpacing = minSectionItemSpacing
		self.headerReferenceSize = headerReferenceSize
		self.footerReferenceSize = footerReferenceSize
	}
}
