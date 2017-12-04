//
//  CastEntity+CoreDataProperties.swift
//  
//
//  Created by Oscar Santos on 12/3/17.
//
//

import Foundation
import CoreData


extension CastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CastEntity> {
        return NSFetchRequest<CastEntity>(entityName: "CastEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var character: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var castMovieRelation: MovieEntity?

}
