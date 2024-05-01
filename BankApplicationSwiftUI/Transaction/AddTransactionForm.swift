//
//  AddTransactionForm.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 26/4/24.
//

import SwiftUI
import CoreData

struct AddTransactionForm: View {
    
    let card: Card
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var ammount = ""
    @State private var date = Date()
    @State private var photoData: Data?
    @State private var shouldPresentPhotoPicker = false
    @State var selectedCategory = Set<TransactionCategory>()

    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Information")){
                    TextField("Name", text: $name)
                    TextField("Ammount", text: $ammount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }//: SECTION ONE
                
                Section(header: Text("Categories")){
                    NavigationLink {
                        CategoriesListView(selectedCategories: $selectedCategory)
                            .navigationTitle("Categories")
                            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    } label: {
                        Text("Select categories")
                    }
                    let sortedByTimestampCategories = Array(selectedCategory).sorted(by: {$0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending })
                    ForEach(sortedByTimestampCategories){ category in
                        HStack(spacing: 12){
                            if let data = category.colorData, let uiColor = UIColor.color(data: data){
                                let color = Color(uiColor)
                                Spacer()
                                    .frame(width: 30, height: 10)
                                    .background(color)
                            }
                            Text(category.name ?? "")
                        }//: HSTACK
                    }
                }//: SECTION TWO
                
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
                }//: SECTION THREE
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
                let resizeImage = image?.resized(to: .init(width: 500, height: 500))
                let imageData = resizeImage?.jpegData(compressionQuality: 0.5)
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
            transaction.card = self.card
            transaction.categories = self.selectedCategory as NSSet
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
    if let sampleCard = Card.fetchSampleCard() {
        AddTransactionForm(card: sampleCard)
    } else {
        Text("No card available for preview")
    }
}
