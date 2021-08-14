// ContentView.swift

// MARK: - LIBRARIES -

import SwiftUI
import MapKit



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
   @State private var locations = [MKPointAnnotation]()
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      ZStack {
         MapView(centerCoordinate: $centerCoordinate,
                 annotations: locations)
            .edgesIgnoringSafeArea(.all)
         Circle()
            .fill(Color.blue)
            .opacity(0.35)
            . frame(width: 32)
         VStack {
            HStack {
               Spacer()
               Button(action: {
                  let newLocation = MKPointAnnotation()
                  newLocation.coordinate = self.centerCoordinate
                  self.locations.append(newLocation)
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
         }
      }
   }
}






// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}
