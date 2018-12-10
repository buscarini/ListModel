//
//  AssignNotNil.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 28/3/17.
//
//

import Foundation

infix operator ?=: AssignmentPrecedence

public func ?= <T>(lhs: inout T, rhs: T?) {
    lhs = rhs ?? lhs
}


