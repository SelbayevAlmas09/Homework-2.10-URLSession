//
//  Models.swift
//  Homework 2.10 URLSession
//
//  Created by Almas Selbayev on 10.04.2022.
//

struct House: Decodable {
    let id: String?
    let name: String?
    let houseColours: String?
    let founder: String?
    let animal: String?
    let element: String?
    let ghost: String?
    let commonRoom: String?
    
    let heads: [Head]?
    let traits: [Trait]?
    
    init(houseData: [String: Any], houseHeads: [Head], houseTraits: [Trait]) {
        id = houseData["id"] as? String
        name = houseData["name"] as? String
        houseColours = houseData["houseColours"] as? String
        founder = houseData["founder"] as? String
        animal = houseData["animal"] as? String
        element = houseData["element"] as? String
        ghost = houseData["ghost"] as? String
        commonRoom = houseData["commonRoom"] as? String
        heads = houseHeads
        traits = houseTraits
    }
    
    static func getHouses() -> [House] {
        var house: [House] = []
        NetworkManager.shared.fetchHouse(completion: { (houses) in house = houses })
        return house
    }
    
//    static func getHousesWithAF(from value: Any) -> [House] {
//
//    }
}

struct Head: Decodable {
    let id: String?
    let firstName: String?
    let lastName: String?
    
    init(headData: [String: Any]) {
        id = headData["id"] as? String
        firstName = headData["firstName"] as? String
        lastName = headData["lastName"] as? String
    }
}

struct Trait: Decodable {
    let id: String?
    let name: String?
    
    init(traitData: [String: Any]) {
        id = traitData["id"] as? String
        name = traitData["name"] as? String
    }
}
