//
//  FrontMatter.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-31.
//

import Foundation
import Yaml
import Yams

/*
 NOTE:
 This whole module is a work-in-progress. Currently rather ugly solution/engineering, just to get
 to a working POC. I plan to re-factor properly in the future.
 I am using two data structures to hold front matter (struct FrontMatter, struct FMType)
 plus an Array<String> (or Dictionary<String, String>) to hold chords. The intention is to eventually
 use only one data structure (Codable FMType). The problem is that I currently can't figure out how to
 define a Codeable to deal with chords (sequence of maps).
 */


struct FrontMatter {
    var artist: String
    var title: String
    var key:String = ""
    var genre: String = ""
    var tags: [String] = [String]()
    var chords: [String] = [String]()
}





struct FrontMatterParser {
    let fileArtist: String
    let fileTitle: String
    
    // --------------------------------------------------
    // parse front matter
    // --------------------------------------------------
    func parseFrontMatter(frontMatterText: String!) -> FrontMatter {
        var fm = FrontMatter(artist: fileArtist, title: fileTitle)
        if frontMatterIsEmpty(text: frontMatterText) {
            return fm
        }
        frontMatterText.map{
            if let yml = serializeUsingYams(fmText: $0) {
                fm.title = yml.title ?? fileTitle
                fm.artist = yml.artist ?? fileArtist
                fm.key = yml.key ?? ""
                fm.genre = yml.genre ?? ""
                fm.tags = yml.tags ?? [String]()
            }
            if let chords = extractChords(fmText: $0) {
                fm.chords = chords
            }
        }
        return fm
    }
    
    
    func frontMatterIsEmpty(text: String!) -> Bool {
        do {
            let yml = try Yams.load(yaml: text ?? "")
            return yml == nil
        } catch {
            print("Error thrown by Yams.load")
            return false
        }
    }
    
    
    // --------------------------------------------------
    // Use YamlSwift to extract `chords` into dictionary
    // --------------------------------------------------
    func extractChords(fmText: String) -> [String]? {
        if hasChords(text: fmText) == false {
            return nil
        }
        let yml = try! Yaml.load(fmText)
        let chords = yml["chords"].array!
        let chordKeys: [String] = chords.flatMap({ $0.dictionary!.map( { $0.key } )  }).map({ $0.string! })
        // FIXME : throws an error when importing John Legend
        let chordValues: [String] = chords.flatMap({ $0.dictionary!.map( { $0.value } )  }).map({ $0.string! })
        let sectionChords = Array(zip(chordKeys, chordValues)).map{ $0 + ": " + $1 }
        //        let sectionToChords = Dictionary(uniqueKeysWithValues: zip(chordKeys, chordValues))
        //        return sectionToChords
        return sectionChords
    }
    
    
    private func hasChords(text: String) -> Bool {
        let yml = try! Yaml.load(text)
        return yml["chords"] != Yaml.null
    }
    
    // --------------------------------------------------
    // Use Yams to extract front matter other than `chords`
    // --------------------------------------------------
    func serializeUsingYams(fmText: String) -> FMType? {
        do {
            let yml = try YAMLDecoder().decode(FMType.self, from: fmText)
            return yml
        } catch {
            print("Error thrown by Yams YAMLDecoder().decode")
            return nil
        }
    }
}


struct FMType: Codable {
    var title: String?
    var artist: String?
    var key: String?
    var genre: String?
    var bpm: String?
    var duration: String?
    var tags: [String]?
}


//extension CodingUserInfoKey {
//   static let title = CodingUserInfoKey(rawValue: "title")
//   static let artist = CodingUserInfoKey(rawValue: "artist")
//   static let key = CodingUserInfoKey(rawValue: "key")
//   static let genre = CodingUserInfoKey(rawValue: "genre")
//   static let bpm = CodingUserInfoKey(rawValue: "bpm")
//   static let duration = CodingUserInfoKey(rawValue: "duration")
//}


