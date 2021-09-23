//
//  EndPoint.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

enum EndPoint {
    case getHotelsList
    case getHotelProfile(hotelId: Int)
    case getHotelImage(hotelImageId: String)
}

extension EndPoint {
    
    var baseURL: String {
        "https://storage.yandexcloud.net/ilya-cherkasov/test"
    }
    
    var path: String {
        switch self {
        case .getHotelsList:
            return "/0777.json"
        case .getHotelProfile(hotelId: let hotelId):
            return "/\(hotelId).json"
        case .getHotelImage(hotelImageId: let hotelImageId):
            return "/\(hotelImageId)"
        }
    }
}

