//
//  Typealias.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit
//enteties
typealias Hotels = [Hotel]
typealias FilterSettings = (filterCase: FilterCases, value: Float)
//completions
typealias VoidCompletion = () -> ()
typealias ResultCompletion = (Result<Any, Error>) -> ()
typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()
typealias ImageCompletion = (UIImage?) -> ()
typealias HotelsCompletion = (Hotels?) -> ()
typealias HotelProfileCompletion = (HotelProfile?) -> ()
