
import Foundation
import UIKit

extension SearchView {

	func setupDataSource() {
		self.dataSource = DataSource(view: self.tableView, filter: self.filter)

		if let searchDataSource = self.dataSource {
//			searchDataSource.searchController.searchBar.barTintColor = ThemeColor.blue
			searchDataSource.searchController.hidesNavigationBarDuringPresentation = false
			searchDataSource.searchController.dimsBackgroundDuringPresentation = false
			
			if #available(iOS 9.1, *) {
				searchDataSource.searchController.obscuresBackgroundDuringPresentation = false
			}
		}

		updateTable()
	}

	func updateTable() {
		let selectedItemConfig = DataSource.ItemConfiguration(accessoryType: .checkmark)

		let listItems = zip(0..., self.items).map { (index, item) -> DataSource.Table.Row in
			let config: DataSource.ItemConfiguration? = self.selection.isSelected(item) ? selectedItemConfig : nil
			
			return Table.row(viewConstructor: self.viewConstructor, id: "\(index)", reuseId: "cell", fill: self.fill, value: item, configuration: config, onSelect: { selected in
				self.selection = self.selection.toggle(selected.value)
				
				self.updateTable()
			})
		}

		self.dataSource?.table = Table(sections: [ Table.Section(rows: listItems) ])
	}
}
