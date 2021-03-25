//
//  SettingsViewController.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/25.
//

import RxSwift
import RxDataSources

class WeatherListViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindTableView()
    }
    
    // MARK: - Perperties
    private let disposeBag = DisposeBag()
    
    var viewModel: WeatherListViewModel!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherListTableViewCell.self, forCellReuseIdentifier: "WeatherListTableViewCell")
        tableView.register(WeatherListTableFooterView.self, forHeaderFooterViewReuseIdentifier: "WeatherListTableFooterView")
        return tableView
    }()
}

// MARK: - Binding
extension WeatherListViewController {
    private func bindTableView() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.cellViewModels
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: WeatherListTableViewCell.reuseIdentifier(), cellType: WeatherListTableViewCell.self)) { index, viewModel, cell in
                cell.viewModel = viewModel
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(WeatherListCellViewModel.self)
            .bind(to: viewModel.selectedWeatherLocation)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] (indexPath) in
                self.viewModel.selectedRow.onNext(indexPath.row)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableFooterView(_ footerView: WeatherListTableFooterView) {
        footerView.viewModel = WeatherListFooterViewModel()
        
        footerView.viewModel.searchWeather
            .bind(to: viewModel.searchWeather)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup UI
extension WeatherListViewController {
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherListTableFooterView.reuseIdentifier()) as! WeatherListTableFooterView
        bindTableFooterView(footer)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return 44
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row > 0 else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
            WeatherManager.shared.deleteWeather(at: indexPath.row)
            completion(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
