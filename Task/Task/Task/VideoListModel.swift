//
//  VideoListModel.swift
//  Task
//
//

import Foundation


/*struct Reel: Decodable {
    let reels: [ReelList]
   
    enum CodingKeys: String, CodingKey {
        case reels = "reels"
    }
    
}

struct ReelList: Decodable {
    let arr: [Video]?
    enum CodingKeys: String, CodingKey {
        case arr = "arr"
    }
}

struct Video: Decodable {
    let id: String?
    let videoURL: String?
    let thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case videoURL = "video"
        case thumbnailURL = "thumbnail"
    }
} */



struct Reels: Codable {
    let reel: [Reel]?
    enum CodingKeys: String, CodingKey {
        case reel = "reels"
    }
}

// MARK: - Reel
struct Reel: Codable {
    let arr: [Arr]?
    
    enum CodingKeys: String, CodingKey {
        case arr = "arr"
    }
}

// MARK: - Arr
struct Arr: Codable {
    let id: String?
    let video: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case video, thumbnail
    }
}
