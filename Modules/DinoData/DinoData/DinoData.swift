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
            
            do {
                guard let jsonData = data else {
                    completion(.failure(DataError.invalidData))
                    return
                }
                let decodedData: [T] = try JSONDecoder().decode([T].self, from: jsonData)
                completion(.success(decodedData))
                return
            } catch DecodingError.dataCorrupted(let context) {
                debugPrint(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                debugPrint("Key '\(key)' not found:", context.debugDescription)
                debugPrint("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                debugPrint("Value '\(value)' not found:", context.debugDescription)
                debugPrint("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                debugPrint("codingPath:", context.codingPath)
            } catch {
                debugPrint("error: ", error)
            }
            completion(.failure(DataError.decodingError))
            
        }
        task.resume()
    }
    
    public func readLoremIpsum(url: String, completion: @escaping (_ result: Array<String>) -> Void) {
        guard var components = URLComponents(string: url) else {
            completion([])
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "DEMO_KEY"),
            URLQueryItem(name: "date", value: "date")
        ]
        
        guard let url = components.url else {
            completion([])
            return
        }
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        let sessionDelegate = CertificatePinning()
        let backgroundSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        let task = backgroundSession.dataTask(with: url) { (data, response, error) in
            do {
                guard let jsonData = data else {
                    completion([])
                    return
                }
                let dataParsed = try JSONDecoder().decode([String].self, from: jsonData)
                completion(dataParsed)
                return
            } catch DecodingError.dataCorrupted(let context) {
                debugPrint(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                debugPrint("Key '\(key)' not found:", context.debugDescription)
                debugPrint("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                debugPrint("Value '\(value)' not found:", context.debugDescription)
                debugPrint("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                debugPrint("codingPath:", context.codingPath)
            } catch {
                debugPrint("error: ", error)
            }
            completion([])

        }
        task.resume()
    }

}
