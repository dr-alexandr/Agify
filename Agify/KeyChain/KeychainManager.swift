//
//  KeychainManager.swift
//  Agify
//
//  Created by Dr.Alexandr on 14.11.2022.
//

import Foundation

final class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case undefined(OSStatus)
    }
    
    static func save(service: String,
                     account: String,
                     password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.undefined(status)
        }
    }
    
    static func get(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        _ = SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }
    
    deinit {
        print("Deallocation \(self)")
    }
}
