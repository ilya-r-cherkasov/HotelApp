//
//  FilterCasesSwitch.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 14.09.2021.
//

import UIKit

class FilterCasesSwitch: UISwitch {
    
    var filterCases: FilterCases
    
    init(filterCases: FilterCases) {
        self.filterCases = filterCases
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
