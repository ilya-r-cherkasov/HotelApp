//
//  Hotel.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import Foundation

// MARK: - Hotel
struct Hotel: Codable {
    let id: Int
    let name, address: String
    let stars: String
    let distance: Float
    let suitesAvailability: [String]
    let image: String?
    
    var distanceToCenterText: String {
        "Distance to center: \(distance) m"
    }
    
    var availableSuitesText: String {
        "Available Suites: " + suitesAvailability.map{$0}.joined(separator: ", ")
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, image
        case suitesAvailability = "suites_availability"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        do {
            var stars: String
            switch try container.decode(Int.self, forKey: .stars) {
            case 1:
                stars = "One"
            case 2:
                stars = "Two"
            case 3:
                stars = "Three"
            case 4:
                stars = "Four"
            case 5:
                stars = "Five"
            default:
                stars = "None"
            }
            self.stars = stars + "-star hotel"
        } catch let error {
            print(error.localizedDescription)
            self.stars = "No stars informations"
        }
        do {
            self.suitesAvailability = try container.decode(String.self, forKey: .suitesAvailability)
                .components(separatedBy: ":")
                .filter({$0 != ""})
        } catch let error {
            print(error)
            self.suitesAvailability = []
        }
        self.distance = try container.decode(Float.self, forKey: .distance)
        self.image = try? container.decode(String.self, forKey: .image)
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.address = ""
        self.stars = ""
        self.distance = 0.0
        self.image = ""
        self.suitesAvailability = []
    }
}
