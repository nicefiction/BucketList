// ContentView.swift
// SOURCE:
// https://www.hackingwithswift.com/books/ios-swiftui/making-someone-elses-class-conform-to-codable

// MARK: - LIBRARIES -

import SwiftUI
import MapKit



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
   // @State private var locations = [MKPointAnnotation]()
   @State private var locations = [CodableMKPointAnnotation]()
   @State private var selectedPlace: MKPointAnnotation?
   @State private var isShowingPlaceDetails: Bool = false
   @State private var isShowingEditSheet: Bool = false
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      ZStack {
         map
         mapFocusPoint
         addPinLocation
            .alert(isPresented: $isShowingPlaceDetails) {
               Alert(title: Text(selectedPlace?.title ?? "N/A"),
                     message: Text(selectedPlace?.subtitle ?? "Missing place information."),
                     primaryButton: .default(Text("OK")),
                     secondaryButton: .default(Text("Edit")) {
                        isShowingEditSheet.toggle()
                     })
            }
            .sheet(isPresented: $isShowingEditSheet,
                   onDismiss: saveData) {
               if selectedPlace != nil {
                  EditView(placemark: selectedPlace!)
               }
            }
      }
      .onAppear(perform: loadData)
   }
   
   
   var map: some View {
      
      return MapView(centerCoordinate: $centerCoordinate,
                     selectedPlace: $selectedPlace,
                     isShowingPlaceDetails: $isShowingPlaceDetails,
                     annotations: locations)
         .edgesIgnoringSafeArea(.all)
   }
   
   
   var mapFocusPoint: some View {
      
      return Circle()
         .fill(Color.blue)
         .opacity(0.35)
         .frame(width: 32)
   }
   
   
   var addPinLocation: some View {
      
      return VStack {
         HStack {
            Spacer()
            Button(action: {
               // let newLocation = MKPointAnnotation()
               let newLocation = CodableMKPointAnnotation()
               newLocation.title = "Example location"
               newLocation.coordinate = self.centerCoordinate
               self.locations.append(newLocation)
               selectedPlace = newLocation
               isShowingEditSheet.toggle()
            }, label: {
               Image(systemName: "plus")
            })
            .padding()
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Circle())
            .padding(.trailing)
         }
         Spacer()
      }
   }
   
   
   
   // MARK: - METHODS
   
   /// Find our app’s documents directory :
   func getDocumentsDirectory()
   -> URL {
      
      let paths = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask)
      return paths[0]
   }
   
   
   func loadData() {
      
      /// Create new URLs that point to a specific file in the documents directory :
      let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
      
      /// Load our data :
      do {
         let data = try Data(contentsOf: filename)
         locations = try JSONDecoder().decode([CodableMKPointAnnotation].self,
                                              from: data)
      } catch {
         print("Unable to load saved data.")
      }
      
      /// Using this approach
      /// we can write any amount of data in any number of files
      /// – it’s much more flexible than UserDefaults ,
      /// and if we need it
      /// also allows us to load and save data as needed
      /// rather than immediately when the app launches as with UserDefaults .
   }
   
   
   func saveData() {
      
      do {
         let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
         let data = try JSONEncoder().encode(self.locations)
         try data.write(to: filename,
                        options: [.atomicWrite, .completeFileProtection])
         /// `NOTE`:
         /// All it takes to ensure that the file is stored with strong encryption is
         /// to add `.completeFileProtection` to the `data` writing options.
      } catch {
         print("Unable to save data.")
      }
   }
}






// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}
