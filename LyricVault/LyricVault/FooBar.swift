//
//  FooBar.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2023-01-01.
//

import CryptoKit
import Foundation
import CoreData
import Yaml


public class SongTunes: NSManagedObject {
    
    var songid: UUID?
    var hashStr: String?
    var artist: String?
    var title: String?
    var lyrics: String?
    var key: String?
    var genre: String?
    var tags: [String]?
    var chords: [String]?
    
    func processInputText(title: String, artist: String, rawtext: String) -> SongTunes {
        let cleanText = boldifyLyricSections(text: rawtext)
        let frontMatterPattern = "(?s)(?<=---).*(?=---)"
        self.songid = UUID()
        let lyrics = extractLyrics(text: cleanText, frontMatterPattern: frontMatterPattern)
        
        let frontMatterText:String? = extractFrontMatter(text: cleanText, frontMatterPattern: frontMatterPattern)
        let fm = FrontMatterParser(fileArtist: artist.capitalized, fileTitle: title.capitalized).parseFrontMatter(frontMatterText: frontMatterText)
        
//        switch frontMatter {
//        case .some(let fm):
//            print("foo")
//        case .none:
//            print("bar")
//        }
        
        self.songid = UUID()
        self.hashStr = computeHash(artist: artist, title: title)
        self.artist = fm.artist
        self.title = fm.title
        self.key = fm.key
        self.genre = fm.genre
        self.tags = fm.tags
        self.chords = fm.chords
        self.lyrics = lyrics
        
        return self
    }
    
    

    func createSong(artist: String, title: String, lyrics: String, key: String?, genre: String?, tags: [String]?, chords: [String]? ) -> SongTunes {
        self.songid = UUID()
        self.hashStr = computeHash(artist: artist, title: title)
        self.artist = artist
        self.title = title
        self.key = key ?? ""
        self.genre = genre ?? ""
        self.tags = tags ?? [""]
        self.chords = chords ?? [""]
        self.lyrics = lyrics
        return self
    }
    
    func printSongData() {
        print("- PRINT SONG DATA -")
        print("title:\t\(self.title ?? "" )")
        print("artist:\t\(self.artist ?? "" )")
        print("lyrics:\t\(self.lyrics ?? "" )")
    }
    
    // ======================================================================
    

    func extractFrontMatter(text: String, frontMatterPattern: String) -> String? {
        guard let frontMatter =  try? text.matching(pattern: frontMatterPattern).first else {
            return nil
        }
        return frontMatter
    }
        
    private func computeHash(artist: String, title: String) -> String {
        let inputString = "\(artist.lowercased()) \(title.lowercased())"
        let inputData = Data(inputString.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
    private func boldifyLyricSections(text: String) -> String {
        return text.components(separatedBy: "\n")
            .map{ processLyricLine(line: $0) }
            .joined(separator: "\n")
    }
        
    private func extractLyrics(text: String, frontMatterPattern: String) -> String {
        return text.replacingOccurrences(of: frontMatterPattern, with:"", options: .regularExpression)
            .replacingOccurrences(of: "--[-]+\n+", with: "", options: .regularExpression)
    }
    
    private func processLyricLine(line: String) -> String {
        var newline = line.strip()
        if isLyricSection(line: line) {
            newline = newline.replacingOccurrences(of: "\\[", with:"**[", options: .regularExpression)
                .replacingOccurrences(of: "\\]", with:"]**", options: .regularExpression)
        }
        return newline
    }
    
    private func isLyricSection(line: String) -> Bool {
        let sectionPattern = "^\\[[a-zA-Z1-9 -]+\\]$"
        guard let matches = try? line.matching(pattern: sectionPattern) else {
            return false
        }
        return matches.count > 0
    }
}

