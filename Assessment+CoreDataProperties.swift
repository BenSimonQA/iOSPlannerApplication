//
//  Assessment+CoreDataProperties.swift
//  FinalMobileApplicationIOSCW2
//
//  Created by Benjamin Simon on 18/05/2020.
//  Copyright © 2020 Benjamin Simon. All rights reserved.
//
//

import Foundation
import CoreData


extension Assessment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assessment> {
        return NSFetchRequest<Assessment>(entityName: "Assessment")
    }

    @NSManaged public var name: String?
    @NSManaged public var module: String?
    @NSManaged public var level: String?
    @NSManaged public var aValue: String?
    @NSManaged public var aMark: String?
    @NSManaged public var dueDate: String?
    @NSManaged public var notes: String?

}
