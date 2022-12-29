//
//  SetlistView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-28.
//

import SwiftUI

struct SetlistView: View {
    
    var setlistId: UUID
    
    let persistenceController = PersistenceController.shared
    @State var title: String = ""
    @State var artist: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    // @Environment(\.managedObjectContext) var moc
    
    @State private var items:[Setlists]?
    
    @FetchRequest(entity: Setlists.entity(), sortDescriptors: [NSSortDescriptor(key: "setlistId", ascending: true)])
    private var setlists: FetchedResults<Setlists>
    
//    @FetchRequest(entity: Songs.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)])
//    private var songs: FetchedResults<Songs>
    
//    let fetchRequest: NSFetchRequest<SetlistNames>
//    fetchRequest = Entity.fetchRequest()
    
    
    
    func fetchSetlists() {
        // fetch data from Core Data
        do {
            let request = Setlists.fetchRequest()
            // set filtering and sorting on the request
            let pred = NSPredicate(format: "%K == %@", #keyPath(SetlistNames.setlistId), setlistId as NSUUID)
            request.predicate = pred
            self.items = try viewContext.fetch(request)
//            tableView.reloadData()
        }
        catch {
            
        }
    }
    
    
    
    func getSetlistName(setlistId: UUID) -> String {
        let predicate = NSPredicate(format: "%K == %@",
                                    #keyPath(SetlistNames.setlistId), setlistId as NSUUID)
        @FetchRequest(entity: SetlistNames.entity(),
                      sortDescriptors: [NSSortDescriptor(key: "setlistId", ascending: true)],
                      predicate: predicate
        )
        var setlistNames: FetchedResults<SetlistNames>
        let name = setlistNames.first?.name ?? "Not Found"
        return name
    }
    
    
    var body: some View {
        // List songs in a given setlist
        let name = getSetlistName(setlistId: setlistId)
        List {
            Section("setlist: \(name)") {
                ForEach(setlists) { setlist in
                    HStack {
                        Text("\(setlist.songId!)")
                        Spacer()
                        Text("\(setlist.setlistId!)")
                    }
                }
                //            .onDelete(perform: deleteSong)
            }
        }
    }
    
    
    
    
}





//struct SetlistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetlistView()
//    }
//}
