//
//  MovieEntity+CoreDataProperties.swift
//  
//
//  Created by Oscar Santos on 12/3/17.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var backdrop: NSData?
    @NSManaged public var genres: NSArray?
    @NSManaged public var id: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster: NSData?
    @NSManaged public var releaseDate: String?
    @NSManaged public var score: String?
    @NSManaged public var title: String?
    @NSManaged public var movieCastRelation: NSSet?

}

// MARK: Generated accessors for movieCastRelation
extension MovieEntity {

    @objc(addMovieCastRelationObject:)
    @NSManaged public func addToMovieCastRelation(_ value: CastEntity)

    @objc(removeMovieCastRelationObject:)
    @NSManaged public func removeFromMovieCastRelation(_ value: CastEntity)

    @objc(addMovieCastRelation:)
    @NSManaged public func addToMovieCastRelation(_ values: NSSet)

    @objc(removeMovieCastRelation:)
    @NSManaged public func removeFromMovieCastRelation(_ values: NSSet)

}
