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
    
    private(set) var userProfile: DataUseProfile?
    
    
    //save profile model with userdefault
    func setCurrentProfile(profile: Data) {
//        userProfile = profile
        UserDefaults.standard.set(profile, forKey: "UserProfileDefault")
    }
    
    func saveAccessToken(token: String) {
        // Mengkonversi token menjadi data yang dapat disimpan di Keychain
        let data = Data(token.utf8)
        
        // Menyiapkan query untuk operasi penambahan data ke Keychain
        let queary = [
            // Nama layanan (service) yang digunakan untuk identifikasi data
            kSecAttrService: "access-token",
            // Nama akun yang digunakan untuk identifikasi data
            kSecAttrAccount: "laza-account",
            // Jenis data yang akan disimpan (generic password)
            kSecClass: kSecClassGenericPassword,
            // Data yang akan disimpan
            kSecValueData: data
        ] as [CFString : Any]
        
        // Menyimpan data ke Keychain
        let status = SecItemAdd(queary as CFDictionary, nil)
        
        // Menyiapkan query untuk operasi pembaruan data di Keychain
        let quearyUpdate = [
            // Nama layanan (service) yang digunakan untuk identifikasi data
            kSecAttrService: "access-token",
            // Nama akun yang digunakan untuk identifikasi data
            kSecAttrAccount: "laza-account",
            // Jenis data yang akan diperbarui (generic password)
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        
        // Memperbarui data di Keychain dengan data yang baru
        let updateStatus = SecItemUpdate(quearyUpdate as CFDictionary, [kSecValueData: data] as CFDictionary)
        
        // Memeriksa status dari operasi penambahan dan pembaruan data
        if updateStatus == errSecSuccess {
            print("Update, \(status)")
        }
        // Jika penambahan sukses, mencetak pesan berikut
        else if status == errSecSuccess {
            print("User saved successfully in the keychain")
        } else {
            // Jika terjadi kesalahan dalam penambahan atau pembaruan data, mencetak pesan kesalahan
            print("Something went wrong trying to save the user in the keychain")
        }
        
    }
    
    func getAccessToken() -> String? {
        // Membuat query untuk mengambil data token dari Keychain
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any]
        
        var ref: CFTypeRef?
        // Melakukan pencocokan dan pengambilan data dari Keychain
        let status = SecItemCopyMatching(queary as CFDictionary, &ref)
        // Jika pengambilan data sukses, mencetak pesan berhasil
        if status == errSecSuccess{
            print("berhasil keychain profile")
        } else {
            // Jika terjadi kesalahan dalam pengambilan data, mencetak pesan kesalahan
            print("gagal, status: \(status)")
            return nil
        }
        let data = ref as! Data
        // Mengkonversi data yang diambil menjadi String
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteAccessToken() {
        // Membuat query untuk menghapus data token dari Keychain
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: true
        ] as [CFString : Any]
        
        // Melakukan operasi penghapusan data dari Keychain
        if SecItemDelete(queary as CFDictionary) == errSecSuccess {
            // Jika penghapusan sukses, mencetak pesan berhasil
            print("Deleted from keychain")
        } else {
            // Jika terjadi kesalahan dalam penghapusan data, mencetak pesan kesalahan
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
    
    //Menyimpan data profile
    func addProfileToKeychain(profile: DataUseProfile, service: String) {
        guard let data = try? JSONEncoder().encode(profile) else {
            print("Encode error")
            return
        }
        let addquery = [
            kSecAttrService: service,
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: service,
                kSecAttrAccount: "laza-account",
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus != errSecSuccess {
                print("Error updating profile to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding token to keychain, status: \(status)")
        }
    }
    
    //Mendapatkan data profile
    func getProfileFromKeychain(service: String) -> DataUseProfile? {
        
        let getquery = [
            kSecAttrService: service,
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
        guard let dataProfile = try? JSONDecoder().decode(DataUseProfile.self, from: data) else {
            print("Encode error")
            return nil
        }
        return dataProfile
    }
}
