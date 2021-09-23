//
//  HotelProfilePresenter.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

protocol HotelProfilePresenterProtocol {
    func viewDidLoad()
}

final class HotelProfilePresenter {
    
    weak var view: HotelProfileViewProtocol!
    var hotel: Hotel
    var networkManager: NetworkManagerProtocol
    
    init(hotel: Hotel, networkManager: NetworkManagerProtocol) {
        self.hotel = hotel
        self.networkManager = networkManager
    }
}

extension HotelProfilePresenter {
    
    private func obtainHotelProfile() {
        networkManager.obtainHotelProfile(withHotelId: hotel.id) { [weak self] hotelProfile in
            guard let hotelProfile = hotelProfile else { return }
            self?.view.setHotelProfile(hotelProfile)
            guard let image = hotelProfile.image,
                  !image.isEmpty else {
                      self?.view.setHotelImage(nil)
                      return
                  }
            self?.networkManager.dowloadImageById(imageId: image) { image in
                self?.view.setHotelImage(image)
            }
        }
    }
}

extension HotelProfilePresenter: HotelProfilePresenterProtocol {
    
    func viewDidLoad() {
        obtainHotelProfile()
    }
}
