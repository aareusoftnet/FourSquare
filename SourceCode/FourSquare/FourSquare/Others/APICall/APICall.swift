//
//  APICall.swift
//  FourSquare
//
//  Created by Vipul Patel on 17/01/22.
//

import UIKit

//MARK: Enum APIBaseURLType
enum APIBaseURLType {
    case development
    case staging
    case production
    
    var url: String {
        switch self {
        case .development:
            return "https://api.foursquare.com/"
        case .staging:
            return "https://api.foursquare.com/"
        case .production:
            return "https://api.foursquare.com/"
        }
    }
}

//MARK: - Enum APIError
enum APIError: Error {
    case invalidURL
    case responseError
    case unknown
}

//MARK: - Enum APIResponseType
enum APIResponseType {
    case success
    case failure
}

//MARK: - Enum APIEndPoint
enum APIEndPoint {
    case closestVenue
    
    var name: String {
        return "v3/places/search"
    }
}

//MARK: - Class APICall
class APICall {
    static let shared = APICall()
    private var baseURL = APIBaseURLType.production.url
    private var authorizationToken = "fsq33HOUXYXUKdNycY6KqfQdu/bxYFndcMxKcRak3vMYqdo="//REPLACE THIS TOKEN IF FOUR SQUARE ACCOUNT CHANGED.
    private init(){}

    private func getAPICall(_ httpBody: [String: String] = [:], apiEndPoint: APIEndPoint, completionHandler: (((_ responseType: APIResponseType, _ response: Any?, _ error: Error?) -> ())?)) {
        guard var validURLComponent = URLComponents(string: baseURL.appending(apiEndPoint.name)) else{
            DispatchQueue.main.async {completionHandler?(.failure, nil, APIError.invalidURL)}
            return
        }
        validURLComponent.queryItems = httpBody.map({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        })
        guard let validURL = validURLComponent.url else{
            DispatchQueue.main.async {completionHandler?(.failure, nil, APIError.invalidURL)}
            return
        }
        var validURLRequest = URLRequest(url: validURL)
        validURLRequest.httpMethod = "GET"
        validURLRequest.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
        print("RequestBody\t\t\t\t\t: ", httpBody)
        URLSession.shared.dataTask(with: validURLRequest) { data, response, error in
            guard let localData = data, let localResponse = response as? HTTPURLResponse, error == nil else {return}
            do {
                let statusCode = localResponse.statusCode
                let localDataResponse = try JSONSerialization.jsonObject(with: localData, options: .allowFragments)
                print("Response(\(apiEndPoint.name)\t: ", localDataResponse)
                if (200...299 ~= statusCode) {
                    DispatchQueue.main.async {completionHandler?(.success, localDataResponse, nil)}
                }else{
                    DispatchQueue.main.async {completionHandler?(.failure, localDataResponse, nil)}
                }
            }catch(let error) {
                DispatchQueue.main.async {completionHandler?(.failure, nil, error)}
            }
        }.resume()
    }
    
    private func postAPICall(_ httpBody: [String: AnyHashable] = [:], apiEndPoint: APIEndPoint, completionHandler: (((_ responseType: APIResponseType, _ response: Any?, _ error: Error?) -> ())?)) {
        guard let validURL = URL(string: baseURL.appending(apiEndPoint.name)) else{
            DispatchQueue.main.async {completionHandler?(.failure, nil, APIError.invalidURL)}
            return
        }
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: httpBody, options: .fragmentsAllowed)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let localData = data, let localResponse = response as? HTTPURLResponse, error == nil else {return}
            do {
                let statusCode = localResponse.statusCode
                let localDataResponse = try JSONSerialization.jsonObject(with: localData, options: .allowFragments)
                print("Response(\(apiEndPoint.name)\t: ", localDataResponse)
                if (200...299 ~= statusCode) {
                    DispatchQueue.main.async {completionHandler?(.success, localDataResponse, nil)}
                }else{
                    DispatchQueue.main.async {completionHandler?(.failure, localDataResponse, nil)}
                }
            }catch(let error) {
                DispatchQueue.main.async {completionHandler?(.failure, nil, error)}
            }
        }.resume()
    }

    func getClosestVenues(_ parameters: [String: String] = [:], completionHandler: (((_ responseType: APIResponseType, _ response: Any?, _ error: Error?) -> ())?)) {
        print("=========== FETCH CLOSEST VENUES ===========")
        getAPICall(parameters, apiEndPoint: .closestVenue, completionHandler: completionHandler)
    }
}
