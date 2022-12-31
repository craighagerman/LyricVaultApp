//
//  Song+CoreDataProperties.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-30.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var artist: String?
    @NSManaged public var lyrics: String?
    @NSManaged public var songid: UUID?
    @NSManaged public var title: String?
    @NSManaged public var hashStr: String?
    @NSManaged public var key: String?
    @NSManaged public var genre: String?
    @NSManaged public var chords: String?
    @NSManaged public var tags: [String]?
    @NSManaged public var setlist: Setlist?

}

extension Song : Identifiable {

}
