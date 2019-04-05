//
//  List+Filtrable.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 15/3/17.
//
//

import Foundation

public extension Table {
	static func filter(_ filter: @escaping (T?) -> Bool) -> (Table) -> Table {
		return { table in
			var result = table
			
			result.sections = table.sections.map { section in
				var filtered = section
				
				filtered.rows = section.rows.filter { item in
					return filter(item.value)
				}
				
				return filtered
			}
			
			return result
		}
	}
}
