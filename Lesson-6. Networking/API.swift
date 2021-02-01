//
//  API.swift
//  Lesson-6. Networking
//
//  Created by Sultangazy Bukharbay on 2/1/21.
//

import Foundation
import Moya

enum API {
    case random
    case login
}

extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://dog.ceo/api/breeds/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .random, .login:
            return "image/random"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .random:
            return .get
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .random, .login:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
