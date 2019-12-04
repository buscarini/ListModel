
import UIKit

// MARK: Wireframe
extension SearchView {
	// MARK: Basic utility methods
	public static func moduleViewController(
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T] = [],
		filter: @escaping Filter,
		completion: (([T]) -> ())? = nil
		) -> SearchView {
		let searchVC = SearchView(
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			filter: filter,
			completion: completion
		)

		let tableView = UITableView()
		searchVC.tableView = tableView

		searchVC.view.addSubview(tableView)
		[
			tableView.topAnchor.constraint(equalTo: searchVC.view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: searchVC.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: searchVC.view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: searchVC.view.bottomAnchor),
		].forEach { $0.isActive = true }
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
//		tableView.autoPin(toTopLayoutGuideOf: searchVC, withInset: 0)
//		tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
		tableView.keyboardDismissMode = .onDrag

		searchVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: searchVC, action: #selector(cancel(_:)))
		searchVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: searchVC, action: #selector(done(_:)))

//		searchVC.view.tintColor = ThemeColor.blue

		return searchVC
    }

	public func close() {
		guard (self.navigationController?.viewControllers.firstIndex(of: self) ?? -1) > 0 else {
			self.navigationController?.dismiss(animated: true, completion: nil)
			return
		}
	
		_ = self.navigationController?.popViewController(animated: true)
	}
	
	public static func chooseOne(
		from vc: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selected: T?,
		animated: Bool = true,
		filter: @escaping Filter,
		completion: @escaping (T) -> Void) {
		self.present(
			from: vc,
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			selection: [ selected ].compactMap { $0 },
			isValid: onlyOne,
			filter: filter,
			completion: { items in
				guard let first = items.first else { return }
				completion(first)
			}
		)
	}
	
	public static func present(
		from: UIViewController,
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T],
		selection: [T],
		isValid: @escaping ([T], [T]) -> Bool,
		animated: Bool = true,
		filter: @escaping Filter,
		completion: @escaping ([T]) -> Void
	) {
		
		let navC = UINavigationController()

		let searchView = self.moduleViewController(
			viewConstructor: viewConstructor,
			fill: fill,
			items: items,
			filter: filter,
			completion: { [weak navC] items in
				completion(items)
				navC?.dismiss(animated: animated, completion: nil)
			}
		)
		
		searchView.isValid = isValid
		searchView.selection.selectedItems = selection
		navC.viewControllers = [searchView]

		from.present(navC, animated: animated, completion: nil)
	}
}
