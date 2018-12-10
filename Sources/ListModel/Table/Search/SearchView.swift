
import UIKit

public typealias PlainSearchView<S: SelectionProtocol, T: Hashable, V: UIView, HeaderT: Equatable, FooterT: Equatable> = SearchView<S, T, V, HeaderT, FooterT> where S.Element == T

public class SearchView<S: SelectionProtocol, T: Hashable, V: UIView, HeaderT: Equatable, FooterT: Equatable>: UIViewController where S.Element == T {

	public typealias DataSource = SearchTableViewDataSource<T, HeaderT, FooterT>
	public typealias Table = ListModel.Table<T, HeaderT, FooterT>

	public var selection: S = S() {
		didSet {
			self.update()
		}
	}

	public var isValid: (_ all: [T], _ selected: [T]) -> Bool = { _, _ in return true }

	// Parameters
	public var viewConstructor: () -> V
	public var fill: (T?, V) -> Void
	
	public var items: [T] = [] { didSet { updateTable() } }
	
	public typealias Filter = (T?, String) -> Bool
	public var filter: Filter
	
	public var completion: (([T]) -> ())?

	public init(
		viewConstructor: @escaping () -> V,
		fill: @escaping (T?, V) -> Void,
		items: [T] = [],
		filter: @escaping Filter,
		completion: (([T]) -> ())? = nil
		) {
		self.viewConstructor = viewConstructor
		self.fill = fill
		self.items = items
		self.filter = filter
		self.completion = completion
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    // MARK: Properties

    var dataSource: DataSource?	

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!


	// MARK: Life Cycle
	override public func viewDidLoad() {
        super.viewDidLoad()

		setupDataSource()

		//KeyboardUtils.autoAdjust(tableView: tableView, disposeBag: disposeBag)
    }

	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		update()
	}

	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		stopSearching()
	}

	func update() {
		self.navigationItem.rightBarButtonItem?.isEnabled = self.isValid(items, selection.selectedItems)
		updateTable()
	}

	func stopSearching() {
		if let searchDataSource = self.dataSource as? PlainSearchTableViewDataSource<T> {
            guard searchDataSource.searchController.isActive else { return }
			searchDataSource.searchController.dismiss(animated: true, completion: nil)
		}
	}

	// MARK: IBActions
	@IBAction @objc func cancel(_ sender: AnyObject?) {
		self.close()
	}

	@IBAction @objc func done(_ sender: AnyObject?) {
		guard self.isValid(items, selection.selectedItems) else { return }

		stopSearching()

		completion?(self.selection.selectedItems)
		self.close()
	}
}
