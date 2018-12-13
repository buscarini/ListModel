//
//  List.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 07/12/2018.
//

import UIKit

public struct List<T: Equatable, HeaderT: Equatable, FooterT: Equatable> : Equatable {
	
	public typealias Configuration = ListConfiguration<T>
	public typealias ItemConfiguration = ListItemConfiguration<T>
	
	public typealias Section = ListSection<T,HeaderT,FooterT>
	public typealias Header = ListHeaderFooter<HeaderT>
	public typealias Footer = ListHeaderFooter<FooterT>
	public typealias Item = ListItem<T>
	
	public var sections : [Section]
	public var header: Header?
	public var footer: Footer?
	
	public var scrollInfo: ListScrollInfo?
	public var configuration: Configuration?
	
	public init(sections: [Section],
				header: Header? = nil,
				footer: Footer? = nil,
				scrollInfo: ListScrollInfo? = nil,
				configuration: Configuration? = nil)
	{
		self.sections = sections
		self.header = header
		self.footer = footer
		self.scrollInfo = scrollInfo
		self.configuration = configuration
	}
}

