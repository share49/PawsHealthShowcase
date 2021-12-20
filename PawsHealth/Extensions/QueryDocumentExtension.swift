//
//  QueryDocumentExtension.swift
//  ProjectPurple
//
//  Created by Pinto Diaz, Roger on 4/8/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import FirebaseFirestore
import Foundation

extension QueryDocumentSnapshot {

    func decoded<Type: Decodable>() throws -> Type {
        //MyLogD(data())

        let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
        let object = try JSONDecoder().decode(Type.self, from: jsonData)
        return object
    }
}

extension QuerySnapshot {

    func decoded<Type: Decodable>() throws -> [Type] {
        let objects: [Type] = try documents.map({ try $0.decoded() })
        return objects
    }
}
