import SwiftUI

struct GetImageView : View {
    
    @Binding var selectedImage: UIImage?
    @Binding var imageUrl: URL?
    @State private var showImagePickerGallery = false
    @State private var showImagePickerCamera = false
    @State private var showActionSheet = false
    
    var body: some View {
        
        Button(action: {
            showActionSheet = true
        }) {
            Text("Show Action Sheet")
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Choose an action"),
                message: Text("What do you want to do?"),
                buttons: [
                    .default(Text("Gallery"), action: {
                        // Perform action 1
                        showImagePickerGallery = true
                    }),
                    .default(Text("Camera"), action: {
                        // Perform action 2
                        showImagePickerCamera = true
                    }),
                    .cancel(),
                ]
            )
        }
        .sheet(isPresented: $showImagePickerGallery) {
            ImagePickerView(sourceType: .photoLibrary, selectedImage: $selectedImage, imageUrl: $imageUrl)
        }
        .sheet(isPresented: $showImagePickerCamera) {
            ImagePickerView(sourceType: .camera, selectedImage: $selectedImage, imageUrl: $imageUrl)
        }
        
    }
}
