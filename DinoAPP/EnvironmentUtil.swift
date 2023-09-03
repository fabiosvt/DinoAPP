//
//  EnvironmentUtil.swift
//  DinoAPP
//
//  Created by Fabio Silvestri on 03/09/23.
//

import Foundation

internal protocol Versionable {
    static var versionNumber: String { get }
}

internal enum EnvironmentUtil: Versionable {
    internal static var bundleIdentifier: String {
        guard let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
            fatalError("Did Not Find CFBundleIdentifier")
        }
        return bundleIdentifier
    }
    
    internal static var versionNumber: String {
        guard let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            fatalError("Did Not Find CFBundleShortVersionString")
        }
        return versionNumber
    }
    
    internal static var buildNumber: String {
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            fatalError("Did Not Find CFBundleVersion")
        }
        return buildNumber
    }
    
    internal static var targetName: String {
        guard let targetName = (Bundle.main.infoDictionary?["CFBundleName"] as? String)?.replacingOccurrences(of: " ", with: "_") else {
            fatalError("Did Not Find CFBundleName")
        }
        return targetName
    }
    
    internal static var displayName: String {
        guard let targetName = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) else {
            fatalError("Did Not Find CFBundleDisplayName")
        }
        return targetName
    }
    
    internal static var environment: [String: AnyObject]? {
        guard let environment = Bundle.main.infoDictionary?["EnvironmentConfig"] as? [String: AnyObject] else {
            fatalError("Did Not Find EnvironmentConfig")
        }
        return environment
    }
        
    internal static var isCertificatePinningEnabled: Bool {
        guard let useCertificate = environment?["REMOTE_CERTIFICATE_PINNING_ENABLED"] as? String else {
            fatalError("Did Not Find REMOTE_CERTIFICATE_PINNING_ENABLED")
        }
        return useCertificate == "YES" ? true : false
    }

    internal static var remoteConfigCertificate: String {
        guard let remoteConfigExt = environment?["REMOTE_CONFIG_CERTIFICATE"] as? String else {
            fatalError("Did Not Find REMOTE_CONFIG_CERTIFICATE")
        }
        return remoteConfigExt
    }

    internal static var remoteConfigCertificateHash: String {
        guard let remoteConfigExt = environment?["REMOTE_CONFIG_CERTIFICATE_HASH"] as? String else {
            fatalError("Did Not Find REMOTE_CONFIG_CERTIFICATE_HASH")
        }
        return remoteConfigExt
    }
    
    internal static var remoteURL: String {
        guard let remoteURL = environment?["REMOTE_URL"] as? String else {
            fatalError("Did Not Find REMOTE_URL")
        }
        return remoteURL
    }

    internal static var remoteConfigURL: String {
        guard let remoteConfigURL = environment?["REMOTE_CONFIG_URL"] as? String else {
            fatalError("Did Not Find REMOTE_CONFIG_URL")
        }
        return remoteConfigURL
    }
    
    internal static var remoteConfigFile: String {
        guard let remoteConfigFile = environment?["REMOTE_CONFIG_FILE"] as? String else {
            fatalError("Did Not Find REMOTE_CONFIG_FILE")
        }
        return remoteConfigFile
    }
    
    internal static var remoteConfigExt: String {
        guard let remoteConfigExt = environment?["REMOTE_CONFIG_EXT"] as? String else {
            fatalError("Did Not Find REMOTE_CONFIG_EXT")
        }
        return remoteConfigExt
    }

}
