// EditView.swift

// MARK: - LIBRARIES -

import SwiftUI
import MapKit



struct EditView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.presentationMode) var presentationMode
   @ObservedObject var placeMark: MKPointAnnotation
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      NavigationView {
         Form {
            Section(header: Text("Title")) {
               TextField("Title",
                         text: $placeMark.computedTitle)
            }
            Section(header: Text("Subtitle")) {
               TextField("Subtitle",
                         text: $placeMark.computedSubtitle)
            }
         }
         .navigationBarTitle(Text("Edit Location"),
                             displayMode: .inline)
         .navigationBarItems(trailing: Button("Done") {
            self.presentationMode.wrappedValue.dismiss()
         })
      }
   }
}





// MARK: - PREVIEWS -

struct EditView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      EditView(placeMark: MKPointAnnotation.example)
   }
}
