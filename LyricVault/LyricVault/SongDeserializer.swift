//
//  SongDeserializer.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-24.
//
//  Purpose:
//      - parse md (or txt) file containing song lyrics to extract front matter and/or title - artist and convert into a dataclass for storage in Core Data


import CryptoKit
import Foundation


struct SongDeserializer {

    private func isSection(line: String) -> Bool {
        let sectionPattern = "^\\[[a-zA-Z1-9 -]+\\]$"
        guard let matches = try? line.matching(pattern: sectionPattern) else {
            return false
        }
        return matches.count > 0
    }
    
    private func processLyricLine(line: String) -> String {
        var newline = line.strip()
        if isSection(line: line) {
            newline = newline.replacingOccurrences(of: "\\[", with:"**[", options: .regularExpression)
                .replacingOccurrences(of: "\\]", with:"]**", options: .regularExpression)
        }
        return newline
    }
    
    func parseRawData(title: String, artist: String, rawtext: String) -> Songdata {
        let frontMatterPattern = "(?s)(?<=---).*(?=---)"
        
        let cleanText = rawtext.components(separatedBy: "\n")
            .map{ processLyricLine(line: $0) }
            .joined(separator: "\n")
        
        let frontMatter = try? cleanText.matching(pattern: frontMatterPattern)[0]
        
        let lyrics = cleanText.replacingOccurrences(of: frontMatterPattern, with:"", options: .regularExpression)
            .replacingOccurrences(of: "--[-]+\n+", with: "", options: .regularExpression)
        
        return Songdata(title: title, artist: artist, lyrics: lyrics, frontMatter: frontMatter)
    }
}



// ----------------------------------------------------------------------------------------------------
//  Dataclass-like object for holding Core Data song data
// ----------------------------------------------------------------------------------------------------
struct Songdata: Identifiable, Decodable, Hashable {
    var id: UUID?
    var title: String
    var artist: String
    var lyrics: String

    
    init(title: String, artist: String, lyrics: String, frontMatter: String?) {
        id = UUID()
        self.title = title
        self.artist = artist
        self.lyrics = lyrics
    }
    
    private func getId(title: String, artist: String) -> String {
        // OPTION 1:
        // id = UUID()
        let inputString = "\(artist) \(title)"
        let inputData = Data(inputString.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
    
}
