//
//  Screen2.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

import Foundation
import SwiftUI


struct LibraryView: View {
    let persistenceController = PersistenceController.shared
    @State var title: String = ""
    @State var artist: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Song.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)])
    private var songs: FetchedResults<Song>
    
    var body: some View {
        // List of all songs
        NavigationStack {
            List {
                ForEach(songs) { song in
                    NavigationLink(destination: SongView(song: song).environment(\.managedObjectContext, persistenceController.container.viewContext) ) {
                        Text("\(song.artist!) - \(song.title!)")
                    }
                }
                .onDelete(perform: deleteSong)
            }
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



struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
