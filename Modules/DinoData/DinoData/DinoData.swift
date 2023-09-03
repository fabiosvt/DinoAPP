//
//  DinoData.swift
//  DinoData
//
//  Created by Fabio Silvestri on 28/09/21.
//

import Foundation

public enum DataError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
}

public class DinoData {
    public init() {}
    
    public typealias result<T> = (Result<[T], Error>) -> Void

    public func readDinoJSON<T: Decodable>(of type: T.Type, url: String, completion: @escaping result<T>) {
        
        guard var components = URLComponents(string: url) else {
            completion(.failure(DataError.invalidData))
            return
        }
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let interval = date.timeIntervalSince1970

        components.queryItems = [
            URLQueryItem(name: "api_key", value: "DEMO_KEY"),
            URLQueryItem(name: "date", value: dateString)
        ]
        
        guard let url = components.url else {
            completion(.failure(DataError.invalidData))
            return
        }
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        let sessionDelegate = CertificatePinning()
        let backgroundSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        let task = backgroundSession.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(DataError.invalidData))
                return
            }
            
            do {
                let decodedData: [T] = try JSONDecoder().decode([T].self, from: jsonData)
                completion(.success(decodedData))
            }
            catch {
                completion(.failure(DataError.decodingError))
            }
            
        }
        task.resume()
    }
    
    public func readLoremIpsum(url: String, completion: @escaping (_ result: Array<String>) -> Void) {
        var dataParsed = Array<String>()
        guard var components = URLComponents(string: url) else {
            completion(dataParsed)
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "DEMO_KEY"),
            URLQueryItem(name: "date", value: "date")
        ]
        
        guard let url = components.url else {
            completion(dataParsed)
            return
        }
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        let sessionDelegate = CertificatePinning()
        let backgroundSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else {
                completion(dataParsed)
                return
            }
            
            dataParsed = try! JSONDecoder().decode([String].self, from: jsonData)
            completion(dataParsed)
            
        }
        task.resume()
    }

}
