//
//  HotelsFilterViewController.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 13.09.2021.
//

import UIKit

enum FilterCases {
    case distance
    case availableSuites
    case noFiltering
}

extension HotelsFilterViewController {
    struct Appearance {
        //UI
        let spacingBetweenStackViews: CGFloat = 10.0
        let spacingBetweenElementsInStackView: CGFloat = 10.0
        let sideInset: CGFloat = 20.0
        let sliderHeight: CGFloat = 50.0
        //initial values
        let maxDistance: Float = 1000.0
        let maxNumberOfAvailableSuites: Float = 15.0
    }
}

protocol HotelsFilterViewProtocol: AnyObject {
    func setFilterSettings(filterSettings: FilterSettings)
}

class HotelsFilterViewController: UIViewController {
    
    var presenter: HotelsFilterPresenter!
    private let appearance = Appearance()
    private var radioSwitchesSet = Set<FilterCasesSwitch>()
    private var currentFilterCase: FilterCases = .noFiltering
    private var savingDistance: Float = 1000.0
    private var savingNumberOfAvailableSuites: Float = 15.0
    
    private lazy var distanceFilterSwitchButton: UIStackView = {
        makeSwitchButton(withTitle: "Distance", filterCases: .distance)
    }()
    
    private lazy var availableSuitesFilterSwitchButton: UIStackView = {
        makeSwitchButton(withTitle: "Suite", filterCases: .availableSuites)
    }()
    
    private lazy var switchButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [distanceFilterSwitchButton, availableSuitesFilterSwitchButton])
        stackView.distribution = .equalSpacing
        stackView.spacing = appearance.spacingBetweenStackViews
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.0
        slider.isEnabled = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Set filter type"
        return label
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply!", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        turnOnSwitchButton(filterCases: currentFilterCase)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
}

extension HotelsFilterViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Filter"
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(switchButtonStackView)
        view.addSubview(slider)
        view.addSubview(infoLabel)
        view.addSubview(applyButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            //switchButtonStackView
            switchButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: appearance.sideInset),
            switchButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -appearance.sideInset),
            switchButtonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: appearance.sideInset),
            //slider
            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: appearance.sideInset),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -appearance.sideInset),
            slider.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            slider.heightAnchor.constraint(equalToConstant: appearance.sliderHeight),
            //infoLabel
            infoLabel.topAnchor.constraint(equalTo: slider.bottomAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //applyButton
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -appearance.sideInset),
            applyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            applyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func makeSwitchButton(withTitle title: String, filterCases: FilterCases) -> UIStackView {
        //switch button
        let switchButton = FilterCasesSwitch(filterCases: filterCases)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        radioSwitchesSet.insert(switchButton)
        //title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //stack view
        let stackView = UIStackView(arrangedSubviews: [titleLabel, switchButton])
        stackView.distribution = .fill
        stackView.setCustomSpacing(10.0, after: switchButton)
        return stackView
    }
        
    @objc private func sliderValueChanged() {
        switch currentFilterCase {
        case .distance:
            infoLabel.setDistanceText(distande: (Int(savingDistance)))
            savingDistance = slider.value
        case .availableSuites:
            infoLabel.setAvailableSuitesText(availableSuites: Int(slider.value))
            savingNumberOfAvailableSuites = slider.value
        case .noFiltering:
            break
        }
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let sender = sender as! FilterCasesSwitch
        if sender.isOn {
            slider.isEnabled = true
            infoLabel.isEnabled = true
            radioSwitchesSet
                .filter({$0 != sender })
                .forEach { $0.setOn(false, animated: true) }
            currentFilterCase = sender.filterCases
            setSlider(filterCases: sender.filterCases)
        } else {
            slider.isEnabled = false
            infoLabel.text = "Set filter type"
            currentFilterCase = FilterCases.noFiltering
        }
    }
    
    @objc private func applyButtonTapped() {
        presenter.apllyFilter(filterCase: currentFilterCase, value: slider.value)
    }
    
    private func setSlider(filterCases: FilterCases) {
        switch filterCases {
        case .distance:
            slider.isEnabled = true
            infoLabel.setDistanceText(distande: (Int(savingDistance)))
            slider.maximumValue = appearance.maxDistance
            slider.value = savingDistance
        case .availableSuites:
            slider.isEnabled = true
            infoLabel.setAvailableSuitesText(availableSuites: Int(savingNumberOfAvailableSuites))
            slider.maximumValue = Float(appearance.maxNumberOfAvailableSuites)
            slider.value = savingNumberOfAvailableSuites
        case .noFiltering:
            break
        }
    }
    
    private func turnOnSwitchButton(filterCases: FilterCases) {
        radioSwitchesSet
            .filter({$0.filterCases == filterCases })
            .forEach { $0.setOn(true, animated: false) }
    }
}

extension HotelsFilterViewController: HotelsFilterViewProtocol {
    
    func setFilterSettings(filterSettings: FilterSettings) {
        currentFilterCase = filterSettings.filterCase
        switch currentFilterCase {
        case .distance:
            savingDistance = filterSettings.value
        case .availableSuites:
            savingNumberOfAvailableSuites = filterSettings.value
        case .noFiltering:
            break
        }
        setSlider(filterCases: currentFilterCase)
    }
}

internal extension UILabel {
    
    func setDistanceText(distande: Int) {
        self.text = "Distance: \(distande) m or less"
    }
    
    func setAvailableSuitesText(availableSuites: Int) {
        self.text = "Available suites: \(availableSuites) or more"
    }
}
