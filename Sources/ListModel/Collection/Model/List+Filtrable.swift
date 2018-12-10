//
//  List+Filtrable.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 15/3/17.
//
//

import Foundation

public extension List {
	public static func filter(_ filter: @escaping (String, T?) -> Bool) -> (List, String) -> List {
		return { (list, string) in
			
			var result = list
			
			result.sections = list.sections.map { section in
				var filtered = section
				
				filtered.items = section.items.filter { item in
					return filter(string, item.value)
				}
				
				return filtered
			}
			
			return result
		}
	}
}
