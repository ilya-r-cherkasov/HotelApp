//
//  HotelsListViewController.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

protocol HotelsListViewProtocol: UIViewController {
    func showHotelsList()
    func showNothingLabel(_ bool: Bool)
}

extension HotelsListViewController {
    struct Appearance {
        let rootViewBackgroundColor: UIColor = .white
        let tableViewBackground: UIColor = .white
        let cellSideInset: CGFloat = 20.0
        let activityIndicatorSize: CGSize = CGSize(width: 80.0, height: 80.0)
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

class HotelsListViewController: UIViewController {
    
    var presenter: HotelsListPresenterProtocol!
    private let appearance = Appearance()
    
    private lazy var hotelsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.backgroundColor = appearance.tableViewBackground
        return tableView
    }()
    
    private lazy var nothingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Nothing Was Found"
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView()
            activityIndicator.bounds = CGRect(x: 0.0,
                                              y: 0.0,
                                              width: appearance.activityIndicatorSize.width,
                                              height: appearance.activityIndicatorSize.height)
        }
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: "Filter",
                                          style: .plain,
                                          target: self,
                                          action: #selector(filterButtonTapped))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = appearance.rootViewBackgroundColor
        title = "Hotels"
        presenter.setTableView(hotelsTableView)
        presenter.viewDidLoad()
    }
}

extension HotelsListViewController {
    
    private func setupUI() {
        view.backgroundColor = appearance.rootViewBackgroundColor
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(hotelsTableView)
        view.addSubview(activityIndicator)
        view.addSubview(nothingLabel)
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            //hotelsTableView constraints
            hotelsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hotelsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hotelsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hotelsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //nothingLabel
            nothingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func filterButtonTapped() {
        presenter.filterButtonTapped()
    }
}

extension HotelsListViewController: HotelsListViewProtocol {
    
    func showHotelsList() {
        hotelsTableView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func showNothingLabel(_ bool: Bool) {
        nothingLabel.isHidden = !bool
    }
}

