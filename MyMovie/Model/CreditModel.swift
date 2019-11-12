//
//  CreditModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import Foundation

struct CreditResponseModel: Decodable {
    let credits: [CreditModel]?
    
    enum CodingKeys: String, CodingKey {
        case cast
        case crew
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cast = try container.decodeIfPresent([CastModel].self, forKey: .cast)?.compactMap { CreditModel(title: $0.name, subTitle: $0.character, profileUrlPath: $0.profileUrlPath) }
        let crew = try container.decodeIfPresent([CrewModel].self, forKey: .crew)?.compactMap { CreditModel(title: $0.name, subTitle: $0.job, profileUrlPath: $0.profileUrlPath) }
        credits = (cast ?? []) + (crew ?? [])
    }
}

struct CastModel: Decodable {
    let name: String?
    let character: String?
    let profileUrlPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case character
        case profileUrlPath = "profile_path"
    }
}

struct CrewModel: Decodable {
    let name: String?
    let job: String?
    let profileUrlPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case job
        case profileUrlPath = "profile_path"
    }
}

struct CreditModel: Decodable {
    let title: String?
    let subTitle: String?
    let profileUrlPath: String?
}
