//
//  AppConfig.swift
//  mTLS client
//
//  Created by Fabio Silvestri on 02/06/23.
//  Copyright © 2023 fabiosvt, Inc. All rights reserved.
//

import Foundation


final public class AppConfig{
    
    // MARK: Shared Instance

    public static let shared = AppConfig()
    
    // MARK: Local Variable

    private var config:Response? = nil
    
    // Can't init is singleton
    private init() {}

    // MARK: Public methods

    public func get() -> Response {
        return config!
    }
    
    public func set(_ data: Response) {
        self.config = data
    }

}
