//
//  HotelsListBuilder.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

final class HotelsListBuilder {
    
    static func createHotelsListModule() -> UIViewController {
        let networkManager: NetworkManagerProtocol? = NetworkManager()
        let hotelsListTableViewManager = HotelsListTableViewManager()
        let presenter = HotelsListPresenter()
        let view = HotelsListViewController()
        view.presenter = presenter
        presenter.view = view
        presenter.networkManager = networkManager
        presenter.tableViewManager = hotelsListTableViewManager
        return view
    }
}
