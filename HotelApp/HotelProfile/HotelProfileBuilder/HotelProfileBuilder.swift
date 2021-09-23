//
//  HotelProfileBuilder.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

final class HotelProfileBuilder {
    
    static func createHotelProfileModule(withHotel hotel: Hotel) -> UIViewController {
        
        let networkManager = NetworkManager()
        let presenter = HotelProfilePresenter(hotel: hotel,
                                              networkManager: networkManager)
        let view = HotelProfileViewController()
        view.presenter = presenter
        presenter.view = view
        presenter.hotel = hotel
        return view
    }
}
