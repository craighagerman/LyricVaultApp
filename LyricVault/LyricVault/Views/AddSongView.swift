//
//  AddSongView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-29.
//

import SwiftyDropbox
import SwiftUI
import CoreData


// ------------------------------------------------------------------------------------------------
// Purpose
//  - Create and add Song to Core Data
// ------------------------------------------------------------------------------------------------
struct AddSongView: View {
    @State var title: String = ""
    @State var artist: String = ""
    @State var key: String = ""
    @State var genre: String = ""
    @State var lyrics: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Song.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)])
    private var songs: FetchedResults<Song>
    
    var body: some View {
        // NavigationView has been deprecated in favor of NavigationStack
        NavigationStack {
            VStack {
                // Input fields
                Text("Add Song")
                TextField("Song Title", text: $title).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Song Artist", text: $artist).textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    TextField("Key", text: $key).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Genre", text: $genre).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                TextEditor(text: $lyrics)
                    .frame(minHeight: 30, alignment: .leading)
                    .border(Color(uiColor: .opaqueSeparator), width: 0.5)
                    .cornerRadius(6.0)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                HStack {
                    Spacer()
                    Button("Add") {
                        addSong()
                        reset()
                    }.disabled(title.isEmpty || artist.isEmpty || lyrics.isEmpty)
                    Spacer()
                    NavigationLink(destination: ResultsView(title: title,
                                                            viewContext: viewContext)) {
                        Text("Find")
                    }
                    Spacer()
                    Button("Clear") {
                        title = ""
                        artist = ""
                        lyrics = ""
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                // List of all songs
                List {
                    ForEach(songs) { song in
                        HStack {
                            Text(song.title ?? "Not found")
                            Spacer()
                            Text(song.artist ?? "Not found")
                        }
                    }
                    .onDelete(perform: deleteSong)
                }
                .navigationTitle("Song Database")
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    
    
    private func addSong() {
        let hashStrs: Set<String> = Set(songs.map{ $0.hashStr! })
        let st = SongTunes()
        let hashStr = st.computeHash(artist: artist, title: title)
        if hashStrs.contains(hashStr) {
            print("LOG: hashStr exists for artist: \(artist) title: \(title)")
        }
        // only add song if it doesn't already exist in the library
        if !hashStrs.contains(hashStr) {
            withAnimation {
                let song = Song(context: viewContext)
                song.songid = UUID()
                song.hashStr = st.computeHash(artist: artist, title: title)
                song.artist = artist.capitalized
                song.title = title.capitalized
                song.key = key.capitalized
                song.genre = genre.capitalized
                //            song.tags = tags
                //            song.chords = chords
                song.lyrics = lyrics
                st.printSongData(song:song) // deleteme
                saveContext()
            }
        }
    }
    
    private func reset() {
        title = ""
        artist = ""
        lyrics = ""
        genre = ""
        key = ""
    }
    
    // TODO : refactor - copy/pasted many times
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured while calling saveContext: \(error)")
        }
    }
    
    private func deleteSong(offsets: IndexSet) {
        withAnimation {
            offsets.map { songs[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
}

struct AddSongView_Previews: PreviewProvider {
    static var previews: some View {
        AddSongView()
    }
}
