//
//  Person+CoreDataProperties.swift
//  CoreDataCRUD
//
//  Created by MACBOOK on 28/12/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int64

}
