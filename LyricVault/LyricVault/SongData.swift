//
//  SongData.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-24.
//

import Foundation

// ----------------------------------------------------------------------------------------------------
//  Dataclass-like object for holding Dropbox Directory song metadata
// ----------------------------------------------------------------------------------------------------
struct DBSongMetadata: Identifiable, Decodable, Hashable {
    var id: UUID?
    var name: String
    var title: String
    var artist: String
    var path: String
    var isInDB: Bool
    
    init(name: String, path: String) {
        id = UUID()
        self.name = name
        self.path = path
        let (first, last) = Self.parseName(name: name)
        title = last
        artist = first
        isInDB = false
    }
    
    private static func parseName(name: String) -> (String, String){
        let cleanName = name.stripExtension()
            .removeUnderscores()
            .clean()
            .strip().capitalized
        // TODO : parametize separator. Allow user to specify different separator
        let ss = cleanName.split(separator: "-")
        let first = String(ss[0]).strip()
        let last = String(ss[1]).strip()
        return (first, last)
    }
}
