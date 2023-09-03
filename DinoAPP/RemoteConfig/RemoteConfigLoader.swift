//
//  RemoteConfigLoader.swift
//  mTLS client
//
//  Created by Fabio Silvestri on 16/04/21.
//  Copyright © 2021 Fabio Silvestri. All rights reserved.
//

import Foundation
import Combine

class RemoteConfigLoader: RemoteConfigLoading {
    func fetch() -> AnyPublisher<Response, Error> {
        if let configUrl = URL(string: EnvironmentUtil.remoteConfigURL + EnvironmentUtil.remoteConfigFile + "." + EnvironmentUtil.remoteConfigExt) {
            let sessionConfig = URLSessionConfiguration.ephemeral
            let sessionDelegate = CertificatePinning()
            let backgroundSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
            return backgroundSession.dataTaskPublisher(for: configUrl)
                .map(\.data)
                .decode(type: Response.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "Missing URL", code: -10001, userInfo: nil)).eraseToAnyPublisher()
    }
}
