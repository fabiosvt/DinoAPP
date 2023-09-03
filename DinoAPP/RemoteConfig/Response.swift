//
//  Response.swift
//  mTLS client
//
//  Created by Fabio Silvestri on 16/04/21.
//  Copyright © 2021 Fabio Silvestri. All rights reserved.
//

import Foundation

public struct publicKey: Codable {
    let host: String
    let port: Int?
    let sha256: String?

    init (host: String, port: Int, sha256: String) {
        self.host = host
        self.port = port
        self.sha256 = sha256
    }
}

public struct configurations: Codable {
    let app_name: String
    let app_link: String
    
    init (app_name: String, app_link: String) {
        self.app_name = app_name
        self.app_link = app_link
    }
}

public struct defaultOptions: Codable {
    let enableInsertDumbData: Bool
    
    init (enableInsertDumbData: Bool) {
        self.enableInsertDumbData = enableInsertDumbData
    }
}

public struct Response: Codable {
    let minVersion: String
    let configurations: configurations
    let defaultOptions: defaultOptions
    let hardCodedPublicKey: [publicKey]

    init (minVersion: String, configurations: configurations, defaultOptions: defaultOptions, hardCodedPublicKey: [publicKey]) {
        self.minVersion = minVersion
        self.configurations = configurations
        self.defaultOptions = defaultOptions
        self.hardCodedPublicKey = hardCodedPublicKey
    }
}
