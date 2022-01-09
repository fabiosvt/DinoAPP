//
//  QuotesModel.swift
//  ReusableFrameworkTestApp
//
//  Created by Fabio Silvestri on 27/09/21.
//

import Foundation

public struct QuotesJsonModel: Codable {
    var quote: String
    var author: String
    var image: String
    
    public func getQuote() -> String {
        return quote
    }
    
    public func getAuthor() -> String {
        return author
    }
    
    public func getImage() -> String {
        return image
    }
}
