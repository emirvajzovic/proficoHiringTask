//
//  StandardKeychainRepository.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

import Foundation

final class StandardKeychainRepository: KeychainRepository {
    
    private enum KeychainKeys: String {
        case apiKey = "Keychain.ApiKey"
    }
    
    func store(apiKey: String) {
        let data: Foundation.Data = .init(apiKey.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.apiKey.rawValue,
            kSecValueData as String: data
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getApiKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.apiKey.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Foundation.Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func deleteApiKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.apiKey.rawValue
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
