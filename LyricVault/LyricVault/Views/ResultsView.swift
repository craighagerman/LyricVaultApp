//
//  ResultsView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2023-01-05.
//

import SwiftyDropbox
import SwiftUI
import CoreData


// ------------------------------------------------------------------------------------------------
// search results
// ------------------------------------------------------------------------------------------------
struct ResultsView: View {
    
    var title: String
    var viewContext: NSManagedObjectContext
    @State var matches: [Song]?
    
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
            let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
            fetchRequest.entity = Song.entity()
            fetchRequest.predicate = NSPredicate(
                format: "title CONTAINS %@", title
            )
            matches = try? viewContext.fetch(fetchRequest)
        }
    }
    
}


//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
