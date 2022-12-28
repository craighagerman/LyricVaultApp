//
//  DBView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-21.
//

import SwiftyDropbox
import SwiftUI
import CoreData



// ------------------------------------------------------------------------------------------------
// Purpose
//  - load file from Dropbox (but doesn't display in the view because it is asyncronous)
//  - load example lyrics from a file and display with Markdown
// ------------------------------------------------------------------------------------------------
struct ContentViewDB: View {
    let markdownText: LocalizedStringKey = "* This is **bold** text, this is *italic* text, and this is ***bold, italic*** text."
    
    let clientDB = DropboxClientsManager.authorizedClient
    
    func getText() -> String {
        var result: String? = "-None-"
        let adelePath = "/Adele - Don\'t you remember.txt"
        clientDB?.files.download(path: adelePath).response{ response, error in
            if response != nil{
                print("Got a response")
                result = "TEXT"
                //print (response)
            } else if let error = error{
                print("No Response")
                result = "ERROR"
            }
        }
        return result!
    }
    
    
    func getAdele() -> String {
        var result: String? = "-None-"
        let adelePath = "/Adele - Don\'t you remember.txt"
        clientDB?.files.download(path: adelePath).response { response, error in
            if let (metadata, data) = response {
                print("Dowloaded file name: \(metadata.name)")
                if let fileContents = String(data: data, encoding: .utf8) {
                    print("Downloaded file data: \(fileContents)")
                    result = fileContents
                }
            } else {
                print(error!)
                result = "ERROR"
            }
        }
        return result!
    }
    
    
    var body: some View {
        Text("John Legend - All of Me").foregroundColor(Color.black).font(.title)
        
        //        let content = getText()
        //        let AdeleText = getAdele()
        //        Text(markdownText).padding(5)
        ScrollView {
            Text(example_lyrics) // .padding(2)
        }
        
    }
}

struct ContentViewDB_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewDB()
    }
}



// ------------------------------------------------------------------------------------------------
// Purpose
//  - demonstrate how to connect to Dropbox and list directory contents
// ------------------------------------------------------------------------------------------------
struct DBFilesView: View {
    
    @State var isShown = false
    
    var body: some View {
        VStack {
            
            Button(action: {
                self.isShown.toggle()
            }) {
                Text("Login to Dropbox")
            }
            
            DropboxView(isShown: $isShown)
            
            Button {
                if let client = DropboxClientsManager.authorizedClient {
                    print("Successful Login")
                    let result = client.files.listFolder(path: "")
                    print("-1-")
                    result.response(completionHandler: { response, error in
                        if let response = response {
                            print("-2-")
                            let fileMetadata = response.entries
                            print("first fileMetadata path: ")
                            let firstpath = fileMetadata[0].pathDisplay
                            print("-3-")
                            print("firstpath: \(firstpath)")
                            
                            if response.hasMore {
                                // Store results found so far
                                // If there are more entries, you can use `listFolderContinue` to retrieve the rest.
                            } else {
                                // You have all information. You can use it to download files.
                            }
                        } else if let error = error {
                            print("-4-")
                            print(error.description)
                            // Handle errors
                        }
                    })
                    
                    
                    let adelePath = "/Adele - Don\'t you remember.txt"
                    client.files.download(path: adelePath).response { response, error in
                        if let (metadata, data) = response {
                            print("Dowloaded file name: \(metadata.name)")
                            if let fileContents = String(data: data, encoding: .utf8) {
                                print("Downloaded file data: \(fileContents)")
                            }
                        } else {
                            print(error!)
                        }
                    }
                }
                else {
                    print("Error")
                }
                
            } label: {
                Text("Test authorizedClient")
            }
            .onOpenURL { url in
                let oauthCompletion: DropboxOAuthCompletion = {
                    if let authResult = $0 {
                        switch authResult {
                        case .success:
                            print("Success! User is logged into DropboxClientsManager.")
                        case .cancel:
                            print("Authorization flow was manually canceled by user!")
                        case .error(_, let description):
                            print("Error: \(String(describing: description))")
                        }
                    }
                }
                DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
            }
        }
    }
}


struct DropboxView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    @Binding var isShown : Bool
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShown {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: uiViewController,
                                                          openURL: { (url: URL) -> Void in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
        }
    }
    
    func makeUIViewController(context _: Self.Context) -> UIViewController {
        return UIViewController()
    }
}
