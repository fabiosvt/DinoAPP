//
//  LocalConfigLoader.swift
//  mTLS client
//
//  Created by Fabio Silvestri on 16/04/21.
//  Copyright © 2021 Fabio Silvestri. All rights reserved.
//

import Foundation

class LocalConfigLoader: LocalConfigLoading {
    private var cachedConfigUrl: URL? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return documentsUrl.appendingPathComponent(EnvironmentUtil.remoteConfigFile + "." + EnvironmentUtil.remoteConfigExt)
    }
    
    private var cachedConfig: Response? {
        let jsonDecoder = JSONDecoder()
        
        guard let configUrl = cachedConfigUrl,
              let data = try? Data(contentsOf: configUrl),
              let config = try? jsonDecoder.decode(Response.self, from: data) else {
            return nil
        }
        
        return config
    }
    
    private var defaultConfig: Response {
        let jsonDecoder = JSONDecoder()
        
        guard let url = Bundle.main.url(forResource: EnvironmentUtil.remoteConfigFile, withExtension: EnvironmentUtil.remoteConfigExt),
              let data = try? Data(contentsOf: url),
              let config = try? jsonDecoder.decode(Response.self, from: data) else {
            fatalError("bundle_must_include_default_config")
        }
        
        return config
    }
    
    func fetch() -> Response {
        if let cachedConfig = self.cachedConfig {
            return cachedConfig
        } else {
            let config = self.defaultConfig
            persist(config)
            return config
        }
    }
    
    func persist(_ config: Response) {
        guard let configUrl = cachedConfigUrl else {
            // should never happen, you might want to handle this
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(config)
            try data.write(to: configUrl)
        } catch {
            // you could forward this error somewhere
            print(error)
        }
    }
}
