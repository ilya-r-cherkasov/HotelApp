//
//  UITableViewExtensions.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

extension UITableView {

    func registerCell(type: UITableViewCell.Type) {
        let cellId = String(describing: type)
        register(type, forCellReuseIdentifier: cellId)
    }
}

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

