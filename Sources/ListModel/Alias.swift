//
//  Alias.swift
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/3/16.
//
//

import Foundation

// Aliases for tables and collections without headers nor footers

public typealias PlainTableViewDataSource<A: Equatable> = TableViewDataSource<A, EmptyType, EmptyType>
public typealias PlainList<A: Equatable> = List<A, EmptyType, EmptyType>
public typealias PlainListSection<A: Equatable> = ListSection<A, EmptyType, EmptyType>

public typealias PlainSearchTableViewDataSource<A: Equatable> = SearchTableViewDataSource<A, EmptyType, EmptyType>

public typealias PlainCollectionViewDataSource<A: Equatable> = CollectionViewDataSource<A, EmptyType, EmptyType>

