//
//  QuotesModel.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit

public class QuotesModel {
    var quote: String
    var author: String
    var image: UIImage
    
    public init(quote: String, author: String, image: UIImage) {
        self.quote = quote
        self.author = author
        self.image = image
    }
    
    public func getQuote() -> String {
        return self.quote
    }
    
    public func getAuthor() -> String {
        return self.author
    }
    
    public func getImage() -> UIImage {
        return self.image
    }
}
