//
//  WeatherPageViewController.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/24.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherPageViewController: UIViewController {
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
                
        pageContainer.dataSource = self
        pageContainer.delegate = self
        
        
        setupUI()
        setupToolbarItems()
    }
        
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    var viewModel: WeatherPageViewModel! {
        didSet {
            configure()
        }
    }
    
    lazy var pageContainer: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return viewController
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundStyle = .automatic
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.allowsContinuousInteraction = true
        pageControl.numberOfPages = 10
        pageControl.currentPage = 0
        pageControl.preferredIndicatorImage = UIImage(systemName: "circle.fill")
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        return pageControl
    }()
    
    lazy var pageControlItem: UIBarButtonItem = {
        let item = UIBarButtonItem(customView: pageControl)
        item.tintColor = .white
        return item
    }()
    
    lazy var listBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: nil, action: nil)
        item.tintColor = .white
        return item
    }()
    
    var pendingPage: Int = 0
}

// MARK: - Binding
extension WeatherPageViewController {
    private func configure() {
        bindBackgroundColor()
        bindViewControllers()
        bindPageControl()
    }
    
    private func bindBackgroundColor() {
        viewModel.backgroundColor
            .observe(on: MainScheduler.instance)
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func bindViewControllers() {
        viewModel.weatherViewModels
            .observe(on: MainScheduler.instance)
            .filter { $0.count > 0 }
            .map { zip($0.indices, $0).map { WeatherViewController(pageIndex: $0, viewModel: $1) } }
            .subscribe(onNext: { [unowned self] (viewControllers) in
                self.pageContainer.setViewControllers([viewControllers[0]], direction: .reverse, animated: false, completion: nil)
                self.viewModel.selectedPage.onNext(0)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindPageControl() {
        Observable.combineLatest(viewModel.weatherViewModels, viewModel.selectedPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (viewModels, selectedPage) in
                guard viewModels.count > 0 else { return }
                let currentPage = self.pageControl.currentPage
                self.pageControl.numberOfPages = viewModels.count
                self.pageControl.currentPage = selectedPage
                self.pageControl.setNeedsDisplay()
                self.scrollToPage(selectedPage, from: currentPage)
            })
            .disposed(by: disposeBag)
        
        pageControl.rx.controlEvent(.valueChanged)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                guard let currentPage = try? viewModel.selectedPage.value() else { return }
                self.scrollToPage(self.pageControl.currentPage, from: currentPage)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup UI
extension WeatherPageViewController {
    private func setupUI() {
        view.addSubview(pageContainer.view)
        addChild(pageContainer)
        
        NSLayoutConstraint.activate([
            pageContainer.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageContainer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageContainer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageContainer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        pageContainer.didMove(toParent: self)
        
        for view in pageContainer.view.subviews {
          if let scrollView = view as? UIScrollView {
            scrollView.delegate = self
          }
        }
    }
    
    private func setupToolbarItems() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        listBarButtonItem.rx.tap
            .bind(to: viewModel.showWeatherList)
            .disposed(by: disposeBag)
        
        toolbarItems = [
            flexibleSpace,
            pageControlItem,
            flexibleSpace,
            listBarButtonItem
        ]
    }
    
    private func scrollToPage(_ page: Int, from current: Int) {
        guard page != current else { return }
        guard let viewController = weatherViewController(page: page) else { return }
        
        if page - current == 0 || abs(page - current) > 1 {
            pageContainer.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        } else {
            if page - current > 0 {
                pageContainer.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            } else {
                pageContainer.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
            }
        }
        viewModel.selectedPage.onNext(page)
    }
}

extension WeatherPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! WeatherViewController).pageIndex
        return weatherViewController(page: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! WeatherViewController).pageIndex
        return weatherViewController(page: index + 1)
    }
    
    private func weatherViewController(page: Int) -> WeatherViewController? {
        guard let viewModels = try? viewModel.weatherViewModels.value() else { return nil }
        guard page >= 0 && page < viewModels.count else { return nil }
        return WeatherViewController(pageIndex: page, viewModel: viewModels[page])
    }
}

extension WeatherPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            pageControl.currentPage = pendingPage
            viewModel.selectedPage.onNext(pendingPage)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first as? WeatherViewController {
            pendingPage = viewController.pageIndex
        }
    }
}

extension WeatherPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let pageWidth = UIScreen.main.bounds.width
        let swipeLeft = offsetX > 0
        do {
            let viewModels: [WeatherViewModel] = try viewModel.weatherViewModels.value()
            let pageIndex: Int = try viewModel.selectedPage.value()
            let pendingIndex: Int = min(max(0, pageIndex + (swipeLeft ? 1 : -1)), viewModels.count - 1)
            let progress: CGFloat = CGFloat((Int(offsetX) % Int(pageWidth))) / pageWidth
            let currentColor = viewModels[pageIndex].backgroundColor
            let pendingColor = viewModels[pendingIndex].backgroundColor
            guard let color = currentColor.interpolateRGBColorTo(pendingColor, fraction: progress) else { return }
            viewModel.backgroundColor.onNext(color)
        } catch {
            print(error)
        }
    }
}
