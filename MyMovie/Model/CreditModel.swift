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
        let cast = try container.decodeIfPresent([Safe<CastModel>].self, forKey: .cast)?.compactMap { CreditModel(title: $0.value?.name, subTitle: $0.value?.character, profileUrlPath: $0.value?.profileUrlPath) }
        let crew = try container.decodeIfPresent([Safe<CrewModel>].self, forKey: .crew)?.compactMap { CreditModel(title: $0.value?.name, subTitle: $0.value?.job, profileUrlPath: $0.value?.profileUrlPath) }
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
