// MapView.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/advanced-mkmapview-with-swiftui

// MARK: - LIBRRAIES -

import SwiftUI
import MapKit



struct MapView: UIViewRepresentable {
   
   // MARK: - NESTED TYPES
   
   class Coordinator: NSObject,
                      MKMapViewDelegate {
      
      // MARK: - PROPERTIES
      
      var parent: MapView
      
      
      
      // MARK: INITIALIZER METHODS
      
      init(_ parent: MapView) {
         
         self.parent = parent
      }
      
      
      
      // MARK: METHODS
      
      func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
         /// Updates the `centerCoordinate` property in `ContentView`as the map moves around .
          parent.centerCoordinate = mapView.centerCoordinate
      }
   }
                      
   
   
   // MARK: - PROPERTY WRAPPERS
   
   @Binding var centerCoordinate: CLLocationCoordinate2D
   
   
   
   // MARK: - PROPERTIES
   
   var annotations: [MKPointAnnotation]
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
//   var body: some View {
//
//      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//   }
   
   
   
   // MARK: METHODS
   
   func makeUIView(context: Context)
   -> MKMapView {
      
      let mapView = MKMapView()
      mapView.delegate = context.coordinator
      
      return mapView
   }
   
   
   func updateUIView(_ uiView: UIViewType,
                     context: Context) {
      
      print("Updating the UIView")
      
      if annotations.count != uiView.annotations.count {
         uiView.removeAnnotations(uiView.annotations)
         uiView.addAnnotations(annotations)
      }
   }
   
   
   func makeCoordinator()
   -> Coordinator {
      
      return Coordinator(self)
   }
}





// MARK: - EXTENSIONS -

extension MKPointAnnotation {
   
    static var example: MKPointAnnotation {
      
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5,
                                                       longitude: -0.13)
        return annotation
    }
}





// MARK: - PREVIEWS -

struct MapView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate),
              annotations: [MKPointAnnotation.example])
   }
}
