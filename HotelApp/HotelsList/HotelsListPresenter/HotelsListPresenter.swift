//
//  HotelsListPresenter.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

protocol HotelsListPresenterProtocol: AnyObject {
    func setTableView(_ tableView: UITableView)
    func viewDidLoad()
    func filterButtonTapped()
}

final class HotelsListPresenter {

    weak var view: HotelsListViewProtocol!
    var networkManager: NetworkManagerProtocol!
    var tableViewManager: HotelsListTableViewManagerProtocol!
    private var hotels = Hotels()
    private var filterSettings: FilterSettings = (filterCase: .noFiltering, value: 0.0)
}

extension HotelsListPresenter: HotelsListPresenterProtocol {
    
    func setTableView(_ tableView: UITableView) {
        tableViewManager.attachHotelsTableView(tableView)
        tableViewManager.delegate = self
        view.showHotelsList()
    }
    
    func viewDidLoad() {
        networkManager.obtainHotels { [weak self] hotels in
            guard let hotels = hotels else { return }
            self?.hotels = hotels
            self?.tableViewManager.setHotels(hotels)
        }
    }
    
    func filterButtonTapped() {
        let vc = HotelsFilterBuilder.createHotelsFilterModule(self, filterSettings: filterSettings)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HotelsListPresenter: HotelsListTableViewManagerDelegate {
    
    func didSelectHotel(_ hotel: Hotel) {
        let vc = HotelProfileBuilder.createHotelProfileModule(withHotel: hotel)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HotelsListPresenter: HotelsFilterDataFlowDelegate {
    
    func valueChanged(filterCase: FilterCases, value: Float) {
        filterSettings = (filterCase: filterCase, value: value)
        var filtredHotels: Hotels
        switch filterCase {
        case .distance:
            filtredHotels = hotels.filter{$0.distance <= value}
        case .availableSuites:
            filtredHotels = hotels.filter{$0.suitesAvailability.count >= Int(value)}
        case .noFiltering:
            filtredHotels = hotels
        }
        self.tableViewManager.setHotels(filtredHotels)
        view.showNothingLabel(filtredHotels.isEmpty)
    }
}
