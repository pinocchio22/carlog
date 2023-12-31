//
//  Comment.swift
//  CarLog
//
//  Created by t2023-m0056 on 2023/10/11.
//

import Foundation

struct Comment: Codable {
    let id: String?
    let postId: String?
    var content: String?
    let userName: String?
    let userEmail: String?
    let timeStamp: String?
}
