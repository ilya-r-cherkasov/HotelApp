//
//  HotelsFilterPresenter.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 13.09.2021.
//

import UIKit

protocol HotelsFilterPresenterProtocol: AnyObject {
    func apllyFilter(filterCase: FilterCases, value: Float)
    func viewWillDisappear()
}

protocol HotelsFilterPresenterDelegate: AnyObject {
    func routeBack()
}

protocol HotelsFilterDataFlowDelegate: AnyObject {
    func valueChanged(filterCase: FilterCases, value: Float)
}

class HotelsFilterPresenter {
    weak var view: HotelsFilterViewProtocol!
    weak var delegate: HotelsFilterPresenterDelegate?
    weak var dataFlowDelegate: HotelsFilterDataFlowDelegate?
    var filterSettings: FilterSettings? {
        didSet {
            guard let filterSettings = filterSettings else { return }
            view.setFilterSettings(filterSettings: filterSettings)
        }
    }
}

extension HotelsFilterPresenter: HotelsFilterPresenterProtocol {
    
    func apllyFilter(filterCase: FilterCases, value: Float) {
        dataFlowDelegate?.valueChanged(filterCase: filterCase, value: value)
        delegate?.routeBack()
    }
    
    func viewWillDisappear() {
        delegate?.routeBack()
    }
}
