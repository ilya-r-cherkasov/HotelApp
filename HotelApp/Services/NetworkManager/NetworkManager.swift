//
//  NetworkManager.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

//MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol: AnyObject {
    func obtainHotels(completion: @escaping HotelsCompletion)
    func obtainHotelProfile(withHotelId hotelId: Int, completion: @escaping HotelProfileCompletion)
    func dowloadImageById(imageId: String, completion: @escaping ImageCompletion)
}

//MARK: - NetworkManager Implementation

final class NetworkManager: NSObject {
    
}

//MARK: - NetworkManager Private Methods

extension NetworkManager {
    
    private func parseJson<T: Decodable>(data: Data, type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            print("JSON decode error:", error)
            return nil
        }
    }
    
    private func makeRequest(request: URLRequest, completion: @escaping NetworkRouterCompletion) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        dataTask.resume()
    }
    
    private func buildRequset(from endPoint: EndPoint) -> URLRequest? {
        let stringURL = endPoint.baseURL.appending(endPoint.path)
        return buildRequset(from: stringURL)
    }
    
    private func buildRequset(from stingURL: String) -> URLRequest? {
        guard let url = URL(string: stingURL) else { return nil }
        let requset = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 120.0)
        return requset
    }
    
    private func obtainParcingResult<T : Codable>(type: T.Type, endpoint: EndPoint, completion: @escaping (T?) -> ()) {
        guard let requset = buildRequset(from: endpoint) else { return }
        makeRequest(request: requset) { [weak self] data, response, error in
            guard let data = data,
                  error == nil else { print(error!.localizedDescription); return }
            let result = self?.parseJson(data: data, type: T.self)
            completion(result)
        }
    }
    
    private func croppImage(_ image: UIImage) -> UIImage? {
        guard let sourceImage = image.cgImage else { return nil }
        let redLineWidth: CGFloat = 1.0
        let width = image.size.width
        let height = image.size.height
        let cropRect = CGRect(x: redLineWidth,
                              y: redLineWidth,
                              width: width - 2 * redLineWidth,
                              height: height - 2 * redLineWidth)
        guard let sourceCroppedImage = sourceImage.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: sourceCroppedImage)
    }
}

//MARK: - NetworkManagerProtocol

extension NetworkManager: NetworkManagerProtocol {
    
    func dowloadImageById(imageId: String, completion: @escaping ImageCompletion) {
        let endpoint: EndPoint = .getHotelImage(hotelImageId: imageId)
        guard let request = buildRequset(from: endpoint) else { return }
        makeRequest(request: request) { [weak self] data, response, error in
            guard let data = data,
                  error == nil else { print(error!.localizedDescription); completion(nil); return }
            guard let image = UIImage(data: data) else { return completion(nil) }
            guard let croppedImage = self?.croppImage(image) else { completion(nil); return }
            completion(croppedImage)
        }
    }
    
    func obtainHotels(completion: @escaping HotelsCompletion) {
        obtainParcingResult(type: Hotels.self,
                                           endpoint: .getHotelsList) { hotels in
            completion(hotels)
        }
    }
    
    func obtainHotelProfile(withHotelId hotelId: Int, completion: @escaping HotelProfileCompletion) {
        obtainParcingResult(type: HotelProfile.self, endpoint: .getHotelProfile(hotelId: hotelId)) { profileHotel in
            completion(profileHotel)
        }
    }
}

