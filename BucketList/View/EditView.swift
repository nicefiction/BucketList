// EditView.swift
// MARK: SOURCE Wikipedia link
// https://gist.github.com/twostraws/aa18008c3dd3997e133aa92bde2ad8c7

// MARK: - LIBRARIES -

import SwiftUI
import MapKit



struct EditView: View {
   
   // MARK: - NESTED TYPES
   
   enum LoadingState {
      
      case loading, loaded, failed
   }
   
   
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.presentationMode) var presentationMode
   @ObservedObject var placemark: MKPointAnnotation
   @State private var loadingState: LoadingState = LoadingState.loading
   @State private var pages = Array<Page>()
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      NavigationView {
         Form {
            locationInput
            Section(header: Text("Results")) {
//               switch loadingState {
//               case LoadingState.loading: Text("Loading...")
//               case loadingState.loaded: Text("success")
//               case loadingState.failed: Text("Try again later.")
//               } // OLIVIER : This creates a bug in Xcode.
               if loadingState == LoadingState.loaded {
                  loadedWikiData
               } else if loadingState == LoadingState.loading {
                  Text("Loading...")
               } else {
                  Text("Try again later.")
               }
            }
         }
         .onAppear(perform: fetchNearbyPlaces)
         .navigationBarTitle(Text("Edit Location"),
                             displayMode: .inline)
         .navigationBarItems(trailing: Button("Done") {
            self.presentationMode.wrappedValue.dismiss()
         })
      }
   }
   
   
   var locationInput: some View {
      
      return Group {
         Section(header: Text("Title")) {
            TextField("Title",
                      text: $placemark.computedTitle)
         }
         Section(header: Text("Subtitle")) {
            TextField("Subtitle",
                      text: $placemark.computedSubtitle)
         }
      }
   }
   
   
   var loadedWikiData: some View {
      
      List {
         ForEach(pages,
                 id: \.pageid) { (page: Page) in
            Text(page.title).font(.headline)
               + Text(": ")
               + Text("Page description here.")
               .italic()
         }
      }
   }
   
   
   
   // MARK: - METHODS
   
   func fetchNearbyPlaces() {
      
      let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
      
      
      guard let _url = URL(string: urlString)
      else {
         print("Bad URL: \(urlString)")
         return
      }
      
      
      URLSession.shared.dataTask(with: _url) { data, response, error in
         if let _data = data {
            // we got some data back!
            let decoder = JSONDecoder()
            
            if let _items = try? decoder.decode(Result.self,
                                                from: _data) {
               // success – convert the array values to our pages array
               print("The items are decoded successfully.")
               self.pages = Array(_items.query.pages.values)
               print("We have queried the pages of the items.")
               self.loadingState = .loaded
               print("The pages and items have been loaded.")
               return
            }
         }
         
         // if we're still here it means the request failed somehow
         self.loadingState = .failed
      }.resume()
   }
}




// MARK: - PREVIEWS -

struct EditView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      EditView(placemark: MKPointAnnotation.example)
   }
}
