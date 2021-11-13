//
//  UserRepository.swift
//  StudyWithMe
//
//  Created by 배한결 on 2021/11/02.
//

import Foundation

class UserInfoRepository {
    
    
    // 서버에 로그인 시도
    func login(id:String,pw:String,completion: @escaping (_ user:UserInfo?,_ errorMessage:String?) -> Void){
        completion(UserInfo(id: id, name: "홍길동", password: pw),nil)
    }
    
    func register(_ id:String, _ pw:String, _ name: String, completion : @escaping (_ user : UserInfo?,_ errorMessage : String?) -> Void ){
        completion(UserInfo(id: id, name: pw, password: name),nil)
    }
}
