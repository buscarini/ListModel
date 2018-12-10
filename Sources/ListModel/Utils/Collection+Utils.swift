//
//  Collection+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 29/8/17.
//
//

import Foundation

extension Collection {
    func partition(by predicate: (Iterator.Element) -> Bool) -> (matching: [Iterator.Element], notMatching: [Iterator.Element]) {
        var groups: ([Iterator.Element],[Iterator.Element]) = ([],[])
        for element in self {
            if predicate(element) {
                groups.0.append(element)
            } else {
                groups.1.append(element)
            }
        }
        return groups
    }
}
