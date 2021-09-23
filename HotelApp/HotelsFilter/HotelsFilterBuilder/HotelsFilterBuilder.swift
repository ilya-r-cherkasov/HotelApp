//
//  HotelsFilterBuilder.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 13.09.2021.
//

import UIKit

final class HotelsFilterBuilder {
    
    static func createHotelsFilterModule(_ dataFlowDelegate: HotelsFilterDataFlowDelegate, filterSettings: FilterSettings) -> UIViewController {
        let view = HotelsFilterViewController()
        let presenter = HotelsFilterPresenter()
        view.presenter = presenter
        presenter.view = view
        presenter.dataFlowDelegate = dataFlowDelegate
        presenter.filterSettings = filterSettings
        return view
    }
}
