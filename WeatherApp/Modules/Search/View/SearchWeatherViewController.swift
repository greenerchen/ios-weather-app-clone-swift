//
//  SearchWeatherViewController.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOpenWeatherMap

class SearchWeatherViewController: UIViewController {
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        setupTableView()
        bindTableView()
        bindSearchBar()
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    var viewModel: SearchWeatherViewModel!
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(SearchWeatherCell.self, forCellReuseIdentifier: SearchWeatherCell.reuseIdentifier())
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.becomeFirstResponder()
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = true
        return searchController
    }()
}

// MARK: - UI Binding
extension SearchWeatherViewController {
    private func bindTableView() {
        tableView.rx
            .modelSelected(Location.self)
            .bind(to: viewModel.selectedLocation)
            .disposed(by: disposeBag)
        
        viewModel.selectedLocation
            .flatMap({ [unowned self] (location) -> Observable<OneCallResponse> in
                try self.viewModel.searchWeather(latitude: location.latitude, longitude: location.longitude)
            })
            .bind(to: viewModel.selectedWeather)
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        // TODO: handle empty or error results
        searchController.searchBar.rx.text
            .orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
//            .debug("Query city")
            .filter { $0.count > 0 }
            .flatMapLatest { [unowned self] (query) -> Observable<[Location]> in
                try self.viewModel.searchLocation(query: query)
                    .retry(3)
                    .startWith([])
                    .catchAndReturn([])
            }
            .materialize()
            .compactMap { $0.element }
            .map { $0 }
            .bind(to: tableView.rx.items(cellIdentifier: SearchWeatherCell.reuseIdentifier(), cellType: SearchWeatherCell.self)) { index, location, cell in
                cell.viewModel = SearchWeatherCellViewModel(location: location)
            }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [unowned self] (_) in
                self.searchController.dismiss(animated: false, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup UI
extension SearchWeatherViewController {
    private func setupNavItems() {
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.prompt = "Enter city or country"
        definesPresentationContext = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    private func setupTableView() {
        let stackView = UIStackView(arrangedSubviews: [
            errorLabel,
            tableView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
