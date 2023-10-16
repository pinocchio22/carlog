//
//  Comment.swift
//  CarLog
//
//  Created by t2023-m0056 on 2023/10/11.
//

import Foundation

struct Comment: Codable {
    let id: String
    let content: String
    let userId: String
    let userName: String
    
    func toDictionary() -> [String: Any] {
           return [
               "id": id,
               "content": content,
               "userId": userId,
               "userName": userName
           ]
       }
}
