//
//  HotelTableViewCell.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 22.09.2021.
//

import UIKit

extension HotelTableViewCell {
    
    struct Appearance {
        let sideInset: CGFloat = 5.0
        let hotelNameLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
    }
}

class HotelTableViewCell: UITableViewCell {
    
    var hotel: Hotel? {
        didSet {
            hotelInformation.setInformation(hotelName: hotel?.name,
                                            hotelAddress: hotel?.address,
                                            hotelStars: hotel?.stars,
                                            distanceToCenter: hotel?.distanceToCenterText,
                                            availableSuites: hotel?.availableSuitesText)
            activityIndicator.stopAnimating()
        }
    }
    private var appearance = Appearance()
    
    private lazy var hotelInformation: HotelInformationView = {
        HotelInformationView()
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            activityIndicator = UIActivityIndicatorView()
            activityIndicator.bounds = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        }
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hotelInformation.setInformation(hotelName: nil,
                                        hotelAddress: nil,
                                        hotelStars: nil,
                                        distanceToCenter: nil,
                                        availableSuites: nil)
    }
}

extension HotelTableViewCell {
    
    private func setupUI() {
        self.backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(hotelInformation)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            //hotelInformation constraints
            hotelInformation.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: appearance.sideInset),
            hotelInformation.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -appearance.sideInset),
            hotelInformation.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                                  constant: appearance.sideInset),
            hotelInformation.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -appearance.sideInset),
            //activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
