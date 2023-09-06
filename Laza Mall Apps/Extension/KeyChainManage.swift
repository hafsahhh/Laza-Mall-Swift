//
//  KeyChainManage.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 20/08/23.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    func saveAccessToken(token: String) {
        let data = Data(token.utf8)
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any]
        let status = SecItemAdd(queary as CFDictionary, nil)
        
        let quearyUpdate = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        let updateStatus = SecItemUpdate(quearyUpdate as CFDictionary, [kSecValueData: data] as CFDictionary)
        if updateStatus == errSecSuccess {
            print("Update, \(status)")
        }
        else if status == errSecSuccess {
            print("User saved successfully in the keychain")
        } else {
            print("Something went wrong trying to save the user in the keychain")
        }
        
    }
    
    func getAccessToken() -> String? {
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any]
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(queary as CFDictionary, &ref)
        if status == errSecSuccess{
            print("berhasil keychain profile")
        } else {
            print("gagal, status: \(status)")
            return nil
        }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteAccessToken() {
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: true
        ] as [CFString : Any]
        
        if SecItemDelete(queary as CFDictionary) == errSecSuccess {
            print("Deleted from keychain")
        } else {
            print("Delete from keychain failed")
        }
        
    }
    
    func saveRefreshToken(token: String) {
        let data = Data(token.utf8)
        let addquery = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: "refresh-token",
                kSecAttrAccount: "laza-account",
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus != errSecSuccess {
                print("Error updating refresh token to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding refresh token to keychain, status: \(status)")
        }
    }
    
    func getRefreshToken() -> String? {
        let getquery = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(getquery, &ref)
        guard status == errSecSuccess else {
            // Error
            print("Error retrieving refresh token from keychain, status: \(status)")
            return nil
        }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteRefreshToken() {
        let query = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary
        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Delete refresh token from keychain failed")
            return
        }
    }
    
    func savePassword(token: String) {
        let data = Data(token.utf8)
        let queary = [
            kSecAttrService: "user-password",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any]
        let status = SecItemAdd(queary as CFDictionary, nil)
        
        let quearyUpdate = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        let updateStatus = SecItemUpdate(quearyUpdate as CFDictionary, [kSecValueData: data] as CFDictionary)
        if updateStatus == errSecSuccess {
            print("Update, \(status)")
        }
        else if status == errSecSuccess {
            print("Password saved successfully in the keychain")
        } else {
            print("Something went wrong trying to save the user in the keychain")
        }
        
    }
    
    
    func getPassword() -> String? {
        let getquery = [
            kSecAttrService: "user-password",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(getquery, &ref)
        guard status == errSecSuccess else {
            // Error
            print("Error retrieving refresh token from keychain, status: \(status)")
            return nil
        }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deletePassword() {
        let queary = [
            kSecAttrService: "user-password",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: true
        ] as [CFString : Any]
        
        if SecItemDelete(queary as CFDictionary) == errSecSuccess {
            print("Deleted from keychain")
        } else {
            print("Delete from keychain failed")
        }
        
    }
}
