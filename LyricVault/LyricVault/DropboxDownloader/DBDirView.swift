//
//  DBDirListView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-22.
//

import SwiftyDropbox
import SwiftUI
import CoreData




// ----------------------------------------------------------------------------------------------------
// Primary view - display button "list dropbox files"
//      n.b. this view is a temporary WIP. Later move this functionally to a Settings view
// ----------------------------------------------------------------------------------------------------
struct DBDirListView: View {
    
    @State var title: String = "Legs"
    @State var artist: String = "ZZ Top"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let dropboxClient = DropboxClientsManager.authorizedClient
    
    var body: some View {
        // NavigationView has been deprecated in favor of NavigationStack
        NavigationView {
            VStack {
                NavigationLink(destination: DropBoxDirView(title: "Dropbox Files",
                                                           viewContext: viewContext, metadata: [])) {
                    Text("List Dropbox Files").foregroundColor(Color.blue)
                }.onTapGesture {
                    print("Tapped")
                }
                
            }
            .onAppear {
                let listFolders = dropboxClient?.files.listFolder(path: "")
                listFolders?.response{ response, error in
                    guard let result = response else{
                        return
                    }
                    for entry in result.entries{
                        print(type(of: result))
                        print(entry)
                    }
                }
            }
        }
    }
}


struct DBDirListView_Previews: PreviewProvider {
    static var previews: some View {
        DBDirListView()
    }
}


// ----------------------------------------------------------------------------------------------------
//  Second view - display list of (txt/md) files in the Dropbox App directory
// ----------------------------------------------------------------------------------------------------
struct DropBoxDirView: View {
    var title: String
    var viewContext: NSManagedObjectContext
    
    @EnvironmentObject var router: TabRouter
    @State var isEditing = true
    @State private var selection = Set<DBSongMetadata>()
    @State var metadata: [DBSongMetadata]
    
    let dropboxClient = DropboxClientsManager.authorizedClient
    let txtOrMdPattern = "\\.[txt|text|md|markdown]+$"
    
    func isMarkdown(name: String) -> Bool {
        guard let matches = try? name.matching(pattern: txtOrMdPattern) else{
            return false
        }
        return matches.count > 0
    }
    
    func downloadFiles() {
        selection.forEach {data in
            print("\n")
            print("---------------------")
            print("path: \(data.path)")
            dropboxClient?.files.download(path: data.path)
                .response { response, error in
                    if let response = response {
                        let responseMetadata = response.0
                        let name = responseMetadata.name
                        let songMetadata = DBSongMetadata(name: name, path: data.path)
                        print("responseMetadata: \(responseMetadata)")
                        let encryptedContents = response.1
                        print("fileContents: \(encryptedContents)")
                        let contents = String(data: encryptedContents, encoding: String.Encoding.utf8)!
                        print("contents: \(contents)")
                        
                        let foo = SongDeserializer().parseRawData(title: songMetadata.title, artist: songMetadata.artist, rawtext: contents)
                        
                        
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print("progressData: \(progressData)")
                }
        }
    }
    
    var body: some View {
        VStack {
            List(metadata, id: \.self, selection: $selection) { data in
                Text(data.artist + ": " + data.title).font(.body)
            }.environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                .navigationTitle("Results")
            Spacer()
            Button {
                downloadFiles()
            } label: {
                Text("Download Files")
            }
        }
        .task {
            let listFolders = dropboxClient?.files.listFolder(path: "")
            listFolders?.response{ response, error in
                guard let result = response else{
                    return
                }
                for entry in result.entries{
                    if isMarkdown(name: entry.name) {
                        let songMetadata = DBSongMetadata(name: entry.name, path: entry.pathDisplay!)
                        metadata.append(songMetadata)
                    }
                }
            }
        }
    }
}






// ----------------------------------------------------------------------------------------------------
//  String Extension for cleaning text
// ----------------------------------------------------------------------------------------------------
//extension String {
//    // internal helper
//    func matching(expression regex: @autoclosure () throws -> NSRegularExpression) rethrows -> [String] {
//        let results = try regex().matches(in: self, range: NSRange(self.startIndex..., in: self))
//        return results.map {
//            String(self[Range($0.range, in: self)!])
//        }
//    }
//    // match regex pattern - use to determine if valid file extension exists
//    func matching(pattern regexPattern: String) throws -> [String] {
//        return try self.matching(expression: NSRegularExpression(pattern: regexPattern))
//    }
//
//    func stripExtension() -> String {
//        return replacingOccurrences(of: #"\.[a-zA-Z]+$"#, with:"", options: .regularExpression)
//    }
//
//    func strip(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
//        return trimmingCharacters(in: characterSet)
//    }
//
//    func clean() -> String {
//        return replacingOccurrences(of: #"\s+"#, with:" ", options: .regularExpression)
//    }
//
//    func removeUnderscores() -> String {
//        return replacingOccurrences(of: #"_"#, with:" ", options: .regularExpression)
//    }
//
//
//    func isSection(line: String) -> Bool {
//        let sectionPattern = "^\\[[a-zA-Z1-9 -]+\\]$"
//        /*
//         guard let matches = try? name.matching(pattern: txtOrMdPattern) else{
//             return false
//         }
//         */
//
//        guard let matches = try? line.matching(pattern: sectionPattern) else {
//            return false
//        }
//        return matches.count > 0
//    }
//
//    func processLyricLine(line: String) -> String {
//        var newline = line.strip()
//        if isSection(line: line) {
//            newline = newline.replacingOccurrences(of: "\\[", with:"**[", options: .regularExpression)
//                .replacingOccurrences(of: "\\]", with:"]**", options: .regularExpression)
//        }
//        return newline
//    }
//
//}






//// ----------------------------------------------------------------------------------------------------
////  Dataclass-like object for holding Dropbox Directory song metadata
//// ----------------------------------------------------------------------------------------------------
//struct DBSongMetadata: Identifiable, Decodable, Hashable {
//    var id: UUID?
//    var name: String
//    var title: String
//    var artist: String
//    var path: String
//    var isInDB: Bool
//    
//    init(name: String, path: String) {
//        id = UUID()
//        self.name = name
//        self.path = path
//        let (first, last) = Self.parseName(name: name)
//        title = last
//        artist = first
//        isInDB = false
//    }
//    
//    private static func parseName(name: String) -> (String, String){
//        let cleanName = name.stripExtension()
//            .removeUnderscores()
//            .clean()
//            .strip().capitalized
//        // TODO : parametize separator. Allow user to specify different separator
//        let ss = cleanName.split(separator: "-")
//        let first = String(ss[0]).strip()
//        let last = String(ss[1]).strip()
//        return (first, last)
//    }
//}
