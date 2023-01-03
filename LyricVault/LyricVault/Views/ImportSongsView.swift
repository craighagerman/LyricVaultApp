//
//  ImportSongsView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-26.
//


import SwiftyDropbox
import SwiftUI
import CoreData


// ----------------------------------------------------------------------------------------------------
// Primary view - display button "list dropbox files"
//      n.b. this view is a temporary WIP. Later move this functionally to a Settings view
// ----------------------------------------------------------------------------------------------------
struct ImportSongsView: View {
    
//    @State var title: String = "Legs"
//    @State var artist: String = "ZZ Top"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let dropboxClient = DropboxClientsManager.authorizedClient
    
    var body: some View {
        VStack {
            NavigationLink(destination: DropBoxDirectoryView(viewContext: viewContext, metadata: [])) {
                Text("List Dropbox Files").foregroundColor(Color.blue)
            }.onTapGesture {
                print("Tapped")
            }
        }
    }
}


// ----------------------------------------------------------------------------------------------------
//  Second view - display list of (txt/md) files in the Dropbox App directory
// ----------------------------------------------------------------------------------------------------
struct DropBoxDirectoryView: View {
    var viewContext: NSManagedObjectContext
    @State var isEditing = true
    @State private var selection = Set<DBSongMetadata>()
    @State var metadata: [DBSongMetadata]
    
    let dropboxClient = DropboxClientsManager.authorizedClient
    let txtOrMdPattern = "\\.[txt|text|md|markdown]+$"
    
    var body: some View {
        VStack {
            Text("Dropbox Files")
            List(metadata, id: \.self, selection: $selection) { data in
                Text(data.artist + ": " + data.title).font(.body)
            }.environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
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
    
    // ------------------------------
    private func isMarkdown(name: String) -> Bool {
        guard let matches = try? name.matching(pattern: txtOrMdPattern) else{
            return false
        }
        return matches.count > 0
    }
    
    // ------------------------------
    private func downloadFiles() {
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
                        

                        let st = SongTunes()
                        let song = st.processInputText(title: songMetadata.title, artist: songMetadata.artist, rawtext: contents)
                        
                        print("==========")
                        st.printSongData(song:song)
                        print("==========")
                        
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print("progressData: \(progressData)")
                }
        }
    }
    
}


// ----------------------------------------------------------------------------------------------------
//  String Extension for cleaning text
// ----------------------------------------------------------------------------------------------------
// TODO : move elsewhere to a lib group
extension String {
    // internal helper
    func matching(expression regex: @autoclosure () throws -> NSRegularExpression) rethrows -> [String] {
        let results = try regex().matches(in: self, range: NSRange(self.startIndex..., in: self))
        return results.map {
            String(self[Range($0.range, in: self)!])
        }
    }
    // match regex pattern - use to determine if valid file extension exists
    func matching(pattern regexPattern: String) throws -> [String] {
        return try self.matching(expression: NSRegularExpression(pattern: regexPattern))
        // TODO: add this to NSRegularExpression:  options:NSRegularExpressionCaseInsensitive
        
    }
    
    func stripExtension() -> String {
        return replacingOccurrences(of: #"\.[a-zA-Z]+$"#, with:"", options: .regularExpression)
    }
    
    func strip(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
    
    func clean() -> String {
        return replacingOccurrences(of: #"\s+"#, with:" ", options: .regularExpression)
    }
    
    func removeUnderscores() -> String {
        return replacingOccurrences(of: #"_"#, with:" ", options: .regularExpression)
    }
    
}


// ====================================================================================================

struct ImportSongsView_Previews: PreviewProvider {
    static var previews: some View {
        ImportSongsView()
    }
}
