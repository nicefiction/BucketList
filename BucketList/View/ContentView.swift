// ContentView.swift
// SOURCE:
// https://www.hackingwithswift.com/books/ios-swiftui/making-someone-elses-class-conform-to-codable
// https://www.hackingwithswift.com/books/ios-swiftui/locking-our-ui-behind-face-id

// MARK: - LIBRARIES -

import SwiftUI
import MapKit
import LocalAuthentication



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
   // @State private var locations = [MKPointAnnotation]()
   @State private var locations = [CodableMKPointAnnotation]()
   @State private var selectedPlace: MKPointAnnotation?
   @State private var isShowingPlaceDetails: Bool = false
   @State private var isShowingEditSheet: Bool = false
   @State private var isUnlocked: Bool = false
   @State private var isShowingAuthenticateFailureAlert: Bool = false
   @State private var authenticateFailureAlertMessage: String = ""
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      ZStack {
         if isUnlocked {
            mapView
               .alert(isPresented: $isShowingPlaceDetails) {
                  Alert(title: Text(selectedPlace?.title ?? "N/A"),
                        message: Text(selectedPlace?.subtitle ?? "Missing place information."),
                        primaryButton: .default(Text("OK")),
                        secondaryButton: .default(Text("Edit")) {
                           isShowingEditSheet.toggle()
                        })
               }
            mapFocusPoint
            addPinButton
         } else {
            authenticateButton
               .alert(isPresented: $isShowingAuthenticateFailureAlert) {
                  Alert(title: Text("Failed Authentication"),
                        message: Text(authenticateFailureAlertMessage),
                        dismissButton: .default(Text("OK")))
               }
         }
      }
      .onAppear(perform: loadData)
      .sheet(isPresented: $isShowingEditSheet,
             onDismiss: saveData) {
         if selectedPlace != nil {
            EditView(placemark: selectedPlace!)
         }
      }
   }
   
   
   var mapView: some View {
      
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
   
   
   var addPinButton: some View {
      
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
                  .padding()
                  .background(Color.black.opacity(0.75))
                  .foregroundColor(.white)
                  .clipShape(Circle())
                  .padding(.trailing)
            })
         }
         Spacer()
      }
   }
   
   
   var authenticateButton: some View {
      
      return Button("Unlock Places") {
         authenticate()
      }
      .padding()
      .padding(.horizontal)
      .background(Color.blue)
      .foregroundColor(.white)
      .clipShape(Capsule())
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
   
   
   func authenticate() {
      
      /// `1` Creating an `LAContext` so we have something that can check and perform biometric authentication :
      let context = LAContext()
      var error: NSError?
      
      /// `2` Ask it whether the current device is capable of biometric authentication :
      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   error: &error) {
         let reason = "Please authenticate yourself to unlock your places."
         
         /// `3`If it is , start the request and provide a closure to run when it completes :
         context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                localizedReason: reason) { success, authenticationError in
            
            /// `4`When the request finishes ,
            /// push our work back to the main thread
            /// and check the result :
            DispatchQueue.main.async {
               if success {
                  /// `5`If it was successful ,
                  ///  we’ll set isUnlocked to true
                  ///  so we can run our app as normal :.
                  self.isUnlocked = true
               } else {
                  // error
                  print("Trigger alert.")
                  self.isShowingAuthenticateFailureAlert = true
                  authenticateFailureAlertMessage = "\(authenticationError?.localizedDescription ?? "Unknown Error")"
                  
               }
            }
         }
      } else {
         // no biometrics
      }
   }
   /// Remember , the string in our code is used for Touch ID ,
   /// whereas the string in Info.plist is used for Face ID .
}






// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}
