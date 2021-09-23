//
//  HotelsTableViewManager.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

protocol HotelsListTableViewManagerProtocol {
    var delegate: HotelsListTableViewManagerDelegate? { get set }
    func attachHotelsTableView(_ tableView: UITableView)
    func setHotels(_ hotels: Hotels)
}

protocol HotelsListTableViewManagerDelegate: AnyObject {
    func didSelectHotel(_ hotel: Hotel)
}

final class HotelsListTableViewManager: NSObject {
    
    weak var delegate: HotelsListTableViewManagerDelegate?
    private var hotels: Hotels = Hotels() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.reloadData()
            }
        }
    }
    private var tableView: UITableView?
}

extension HotelsListTableViewManager: HotelsListTableViewManagerProtocol {
    
    func attachHotelsTableView(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerCell(type: HotelTableViewCell.self)
    }
    
    func setHotels(_ hotels: Hotels) {
        self.hotels = hotels
    }
}

extension HotelsListTableViewManager: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableViewCell.reuseIdentifier, for: indexPath) as! HotelTableViewCell
        cell.hotel = hotels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectHotel(hotels[indexPath.row])
    }
}
