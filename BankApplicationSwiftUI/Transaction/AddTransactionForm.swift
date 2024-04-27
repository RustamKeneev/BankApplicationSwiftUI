//
//  AddTransactionForm.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 26/4/24.
//

import SwiftUI
import CoreData

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var ammount = ""
    @State private var date = Date()
    @State private var photoData: Data?
    @State private var shouldPresentPhotoPicker = false
    
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Information")){
                    TextField("Name", text: $name)
                    TextField("Ammount", text: $ammount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    NavigationLink {
                        Text("New category page")
                            .navigationTitle("New Title")
                    } label: {
                        Text("Many to many")
                    }

                }//: SECTION ONE
                Section(header: Text("Photo/Receipt")){
                    Button(action: {
                        shouldPresentPhotoPicker.toggle()
                    }, label: {
                        Text("Select Photo")
                    })
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker){
                        PhotoPickerView(photoData: $photoData)
                    }
                    if let data = self.photoData, let image = UIImage.init(data: data){
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }//: SECTION TWO
            }//: FORM
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }//: NAVIGATIONVIEW
    }
        
    struct PhotoPickerView: UIViewControllerRepresentable{
        
        @Binding var photoData: Data?
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
                
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
            
            private let parent: PhotoPickerView
            init(parent: PhotoPickerView){
                self.parent = parent
            }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                let image = info[.originalImage] as? UIImage
                let imageData = image?.jpegData(compressionQuality: 1)
                self.parent.photoData = imageData
                picker.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
    
    private var saveButton: some View{
        Button(action: {
            let context = PersistenceController.shared.container.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = self.name
            transaction.timestamp = self.date
            transaction.ammount = Float(self.ammount) ?? 0
            transaction.photoData = self.photoData
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            }catch{
                print("Error transaction save \(error)")
            }
        }, label: {
            Text("Save")
        })
    }//CANCEL BUTTON
    
    private var cancelButton: some View{
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }//CANCEL BUTTON
}

#Preview {
    AddTransactionForm()
}
