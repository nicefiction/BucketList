// ContentView.swift

// MARK: - LIBRARIES -

import SwiftUI
import MapKit



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
   @State private var locations = [MKPointAnnotation]()
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
            .sheet(isPresented: $isShowingEditSheet) {
               if selectedPlace != nil {
                  EditView(placemark: selectedPlace!)
               }
            }
      }
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
               let newLocation = MKPointAnnotation()
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
}






// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}
