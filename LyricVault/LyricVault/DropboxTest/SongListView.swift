//
//  SongListView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-26.
//


import SwiftyDropbox
import SwiftUI
import CoreData



// ------------------------------------------------------------------------------------------------
// Purpose
//  - sync with Core Data to add/get data and display DB contents in a list
// ------------------------------------------------------------------------------------------------
struct SongListView: View {
    
    @State var title: String = ""
    @State var artist: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Songs.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)])
    private var songs: FetchedResults<Songs>
    
    var body: some View {
        // NavigationView has been deprecated in favor of NavigationStack
        NavigationView {
            VStack {
                // Input fields
                Text("Songs")
                TextField("Song Title", text: $title)
                TextField("Song Artist", text: $artist)

                HStack {
                    Spacer()
                    Button("Add") {
                        addSong()
                        title = ""
                        artist = ""
                    }
                    Spacer()
                    NavigationLink(destination: ResultsView(title: title,
                                                            viewContext: viewContext)) {
                        Text("Find")
                    }
                    Spacer()
                    Button("Clear") {
                        title = ""
                        artist = ""
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
//        .onAppear {
//            print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
//        }
    }

    
    
    private func addSong() {
        
        withAnimation {
            let song = Songs(context: viewContext)
            song.id = UUID()
            song.title = title.capitalized
            song.artist = artist.capitalized
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured: \(error)")
        }
    }
    
    private func deleteSong(offsets: IndexSet) {
        withAnimation {
            offsets.map { songs[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
}


struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}


// ------------------------------------------------------------------------------------------------
// search results
// ------------------------------------------------------------------------------------------------
struct ResultsView: View {
    
    var title: String
    var viewContext: NSManagedObjectContext
    @State var matches: [Songs]?
    
    var body: some View {
        
        return VStack {
            List {
                ForEach(matches ?? []) { match in
                    HStack {
                        Text(match.title ?? "Not found")
                        Spacer()
                        Text(match.artist ?? "Not found")
                    }
                }
            }
            .navigationTitle("Results")
        }
        .task {
            let fetchRequest: NSFetchRequest<Songs> = Songs.fetchRequest()
            
            fetchRequest.entity = Songs.entity()
            fetchRequest.predicate = NSPredicate(
                format: "title CONTAINS %@", title
            )
            matches = try? viewContext.fetch(fetchRequest)
        }
    }
    
}
