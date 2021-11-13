//
//  UserInfo.swift
//  StudyWithMe
//
//  Created by 배한결 on 2021/11/02.
//

import Foundation

struct UserInfo: Codable {
    let id, name, password: String
}

extension UserInfo {
    static var savedUser : UserInfo? {
        get{
            var user : UserInfo?
            if let data = UserDefaults.standard.value(forKey: "SAVED_USER") as? Data {
                user = try? PropertyListDecoder().decode(UserInfo.self, from: data)
            }
            return user
        }
        
        set{
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "SAVED_USER")
        }
    }
}
