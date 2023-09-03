//
//  ConfigProvider.swift
//  mTLS client
//
//  Created by Fabio Silvestri on 16/04/21.
//  Copyright © 2021 Fabio Silvestri. All rights reserved.
//

import Foundation
import Combine

protocol LocalConfigLoading {
    func fetch() -> Response
    func persist(_ config: Response)
}

protocol RemoteConfigLoading {
    func fetch() -> AnyPublisher<Response, Error>
}

class ConfigProvider: ObservableObject {
    
    @Published private(set) var config: Response
    
    private let localConfigLoader: LocalConfigLoading
    private let remoteConfigLoader: RemoteConfigLoading
    
    init(localConfigLoader: LocalConfigLoading, remoteConfigLoader: RemoteConfigLoading) {
        self.localConfigLoader = localConfigLoader
        self.remoteConfigLoader = remoteConfigLoader
        
        config = localConfigLoader.fetch()
    }
    
    private var cancellable: AnyCancellable?
    private var syncQueue = DispatchQueue(label: "config_queue_\(UUID().uuidString)")
    
    func updateConfig() {
        syncQueue.sync {
            guard self.cancellable == nil else {
                return
            }
            
            self.cancellable = self.remoteConfigLoader.fetch()
                .sink(receiveCompletion: { completion in
                    // clear cancellable so we could start a new load
                    self.cancellable = nil
                }, receiveValue: { [weak self] newConfig in
                    DispatchQueue.main.async {
                        self?.config = newConfig
                        let singleton = AppConfig.shared
                        singleton.set(newConfig)
                    }
                    self?.localConfigLoader.persist(newConfig)
                })
        }
    }
    
    func get() -> Response {
        return config
    }
}
