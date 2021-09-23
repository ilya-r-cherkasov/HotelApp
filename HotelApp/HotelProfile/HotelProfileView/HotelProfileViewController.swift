//
//  HotelProfileViewController.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

protocol HotelProfileViewProtocol: UIViewController {
    func setHotelProfile(_ profile: HotelProfile)
    func setHotelImage(_ image: UIImage?)
}

extension HotelProfileViewController {
    struct Appearance {
        let rootViewBackgroundColor: UIColor = .white
        let initialHotelImageViewHeight: CGFloat = 100.0
        let activityIndicatorSize: CGSize = CGSize(width: 80.0, height: 80.0)
    }
}

class HotelProfileViewController: UIViewController {
    
    var presenter: HotelProfilePresenterProtocol!
    private var appearance = Appearance()
    private var hotelImageViewHeightConstraint: NSLayoutConstraint!
    private var hotelProfile: HotelProfile = HotelProfile() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                let profile = self?.hotelProfile
                self?.setHotelInformation(profile)
            }
        }
    }
    
    private lazy var hotelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var hotelInformation: HotelInformationView = {
        HotelInformationView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
}

extension HotelProfileViewController {
    
    private func setupUI() {
        view.backgroundColor = appearance.rootViewBackgroundColor
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(hotelImageView)
        view.addSubview(activityIndicator)
        view.addSubview(hotelInformation)
    }
    
    private func makeConstraints() {
        hotelImageViewHeightConstraint = hotelImageView.heightAnchor.constraint(equalToConstant: appearance.initialHotelImageViewHeight)
        NSLayoutConstraint.activate([
            //hotelImageView
            hotelImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hotelImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hotelImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hotelImageViewHeightConstraint,
            //hotelInformation
            hotelInformation.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hotelInformation.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hotelInformation.topAnchor.constraint(equalTo: hotelImageView.safeAreaLayoutGuide.bottomAnchor),
            //activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: hotelImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: hotelImageView.centerYAnchor)
        ])
    }
    
    private func updateHotelImageViewHeightConstraint() {
        guard let image = hotelImageView.image else { return }
        let actualImageWidth = hotelImageView.frame.width
        hotelImageViewHeightConstraint.constant = getActualImageHeight(image: image, actualWidth: actualImageWidth)
        view.layoutIfNeeded()
    }
    
    private func getActualImageHeight(image: UIImage, actualWidth: CGFloat) -> CGFloat {
        return image.size.height / image.size.width * actualWidth
    }
    
    private func setHotelInformation(_ hotelProfile: HotelProfile?) {
        hotelInformation.setInformation(hotelName: hotelProfile?.name,
                                        hotelAddress: hotelProfile?.address,
                                        hotelStars: hotelProfile?.stars,
                                        distanceToCenter: hotelProfile?.distanceToCenterText,
                                        availableSuites: hotelProfile?.availableSuitesText)
    }
}

extension HotelProfileViewController: HotelProfileViewProtocol {
    
    func setHotelProfile(_ profile: HotelProfile) {
        self.hotelProfile = profile
    }
    
    func setHotelImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.hotelImageView.image = (image != nil) ? (image) : (UIImage(named: "noPhoto"))
            self.updateHotelImageViewHeightConstraint()
            self.activityIndicator.stopAnimating()
        }
    }
}
