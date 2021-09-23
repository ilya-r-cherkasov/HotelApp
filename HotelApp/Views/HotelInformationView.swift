//
//  HotelInformationView.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 14.09.2021.
//

import UIKit

extension HotelInformationView {
    
    struct Appearance {
        let hotelNameLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
    }
}

class HotelInformationView: UIStackView {
    
    private let appearance = Appearance()
    
    private lazy var hotelNameLabel: UILabel = {
        let label = makeLabel()
        label.font = appearance.hotelNameLabelFont
        return label
    }()
    
    private lazy var hotelAddressLabel: UILabel = {
        makeLabel()
    }()
    
    private lazy var hotelStarsLabel: UILabel = {
        makeLabel()
    }()
    
    private lazy var distanceToCenterLabel: UILabel = {
        makeLabel()
    }()
    
    private lazy var availableSuitesLabel: UILabel = {
        makeLabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInformation(hotelName: String?,
                        hotelAddress: String?,
                        hotelStars: String?,
                        distanceToCenter: String?,
                        availableSuites: String?) {
        self.hotelNameLabel.text = hotelName
        self.hotelAddressLabel.text = hotelAddress
        self.hotelStarsLabel.text = hotelStars
        self.distanceToCenterLabel.text = distanceToCenter
        self.availableSuitesLabel.text = availableSuites
    }
}

extension HotelInformationView {
    
    private func setupStackView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        self.addArrangedSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }    
}
