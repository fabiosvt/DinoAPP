//
//  CertificatePinning.swift
//  DinoAPP
//
//  Created by Fabio Silvestri on 03/09/23.
//

import Foundation
import Security
import CommonCrypto
import CryptoKit

class CertificatePinning:NSObject, URLSessionDelegate {
    static let shared = CertificatePinning()
    
    var isCertificatePinning:Bool = true
    
    var hardcodedPublicKey:String = EnvironmentUtil.remoteConfigCertificateHash

    let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]

    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        return Data(SHA256.hash(data: keyWithHeader)).base64EncodedString()
    }
    
    func addAnchorToTrust(trust: SecTrust, certificate: SecCertificate) -> SecTrust {
        let array: NSMutableArray = NSMutableArray()
        array.add(certificate)
        SecTrustSetAnchorCertificates(trust, array)
        return trust
    }

    private func validate(trust: SecTrust, with policy: SecPolicy) -> Bool {
        let status = SecTrustSetPolicies(trust, policy)
        guard status == errSecSuccess else { return false }
        return SecTrustEvaluateWithError(trust, nil)
    }

    //MARK:- URLSessionDelegate
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge,nil)
            return
        }
        
        if EnvironmentUtil.isCertificatePinningEnabled {
            if let serverCertificate = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] {
                guard let pathToCertificate = Bundle.main.path(forResource: EnvironmentUtil.remoteConfigCertificate, ofType: "der") else {
                    debugPrint("no local path found \(EnvironmentUtil.remoteConfigCertificate)")
                    return
                }
                if let localCertiData = NSData(contentsOfFile: pathToCertificate), let rootCert = SecCertificateCreateWithData(kCFAllocatorDefault, localCertiData) {
                    let sslInput = addAnchorToTrust(trust: serverTrust, certificate: rootCert)
                    var result: SecTrustResultType = SecTrustResultType.unspecified
                    let error: OSStatus = SecTrustEvaluate(sslInput, &result)
                    if (error != 0){
                        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                        return
                    }
                    guard self.validate(trust: serverTrust, with: SecPolicyCreateBasicX509()), let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
                    else {
                        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                        return
                    }
                    
                    let isSecuredServer = SecTrustEvaluateWithError(serverTrust, nil)
                    let remoteCertiData = SecCertificateCopyData(serverCertificate) as NSData
                    if isSecuredServer && localCertiData.isEqual(to: remoteCertiData as Data) {
                        debugPrint("Certificate Pinning Completed Successfully")
                        completionHandler(.useCredential, URLCredential(trust: serverTrust))
                        return
                    } else {
                        debugPrint("Local Certificate: \(localCertiData as Any)")
                        debugPrint("Remote Certificate: \(remoteCertiData)")
                        completionHandler(.cancelAuthenticationChallenge,nil)
                    }
                }
            }
        } else {
            //compare Keys
            if let serverCertificate = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] {
                let serverPublicKey = SecCertificateCopyKey(serverCertificate.first!)! as SecKey
                let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil)
                let data:Data = serverPublicKeyData! as Data

                let serverHashKey = sha256(data: data)
                if serverHashKey == self.hardcodedPublicKey {
                    debugPrint("PublicKey Pinning Completed Successfully")
                    completionHandler(.useCredential, URLCredential.init(trust: serverTrust))
                } else {
                    debugPrint("Local PublicKey: \(self.hardcodedPublicKey)")
                    debugPrint("Remote PublicKey: \(serverHashKey)")
                    completionHandler(.cancelAuthenticationChallenge,nil)
                }
            }
        }
    }
    
    func callAnyApi(urlString:String,isCertificatePinning:Bool,response:@escaping ((Data?, URLResponse?, Error?)-> ())){
        
        let sessionObj = URLSession(configuration: .ephemeral,delegate: self,delegateQueue: nil)
        self.isCertificatePinning = isCertificatePinning
        
        guard let url = URL.init(string: urlString) else {
            fatalError("please add valid url first")
        }
        
        let task = sessionObj.dataTask(with: url) { (data, res, error) in
            
            if error?.localizedDescription == "cancelled" {
                response(data, res, error)
            }
            if let data = data {
                response(data, res, error)
            }
            
        }
        task.resume()
    }

}
