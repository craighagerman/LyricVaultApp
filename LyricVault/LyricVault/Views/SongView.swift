//
//  SongView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-29.
//

import SwiftUI

struct SongView: View {
    let persistenceController = PersistenceController.shared
    @State var song: Song
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var displayChords:Bool = false
    
    var body: some View {
        let markdownText:AttributedString = getMarkdown(text: song.lyrics ?? "UNKNOWN")
        ScrollView {
            VStack {
                Text("\(song.artist!) - \(song.title!)").font(.title)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button {
                                displayChords.toggle()
                            } label: {
//                                Image(systemName: "music.note.list")
                                Text("Show Chords")
                            }
                        }
                        ToolbarItemGroup(placement: .secondaryAction) {
                            // TODO - refactor to a NavigationLink
                            Button("Edit Song") {
                                print("Edit Song tapped")
                            }
                            NavigationLink(destination: ImportSongsView() ) {
                                Text("View Chords")
                            }
                        }
                    }
                
                if displayChords {
                    HStack {
                        Text("G  Em  C  G  Am")
//                            .padding(5)
                            .foregroundColor(.yellow)
                            .background(.black)
                        Spacer()
                    }.padding(5)
                }
                Text(markdownText).lineLimit(nil).padding(2)
            }.frame(maxWidth: .infinity)
                .padding(0) // make margins disappear
        }
    }

    
    
    private func getMarkdown(text: String) -> AttributedString {
        var attributedString: AttributedString = {
            do {
                var text = try AttributedString(markdown: "\(text)"
                                                , options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
         
                if let range = text.range(of: "Apple") {
                    text[range].backgroundColor = .yellow
                }
         
                if let range = text.range(of: "iPadOS") {
                    text[range].backgroundColor = .purple
                    text[range].foregroundColor = .white
                }
                return text
         
            } catch {
                return ""
            }
        }()
        return attributedString
    }
    
    
}



//struct SongView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongView()
//    }
//}
