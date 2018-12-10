//
//  TableViewDataSource+Utils.swift
//  ListModel
//
//  Created by José Manuel Sánchez Peñarroja on 1/8/18.
//

import UIKit

extension TableViewDataSource {
	func view(for item: Row) -> UIView? {
		return self.table
			.flatMap { Table.index($0, of: item) }
			.flatMap { self.view.cellForRow(at: $0) }
	}
}
