import SwiftUI

struct AddButtonView: View {
    var arViewModel: ARViewModel
    @Binding var selectedImage: UIImage?
    @Binding var imageUrl: URL?
    @State private var showImagePickerGallery = false
    @State private var showImagePickerCamera = false
    @State private var showActionSheet = false
    var body: some View {
        VStack{
            Button(action: {
                showActionSheet = true
            }) {
                ZStack{
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                    
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.cyan)
                    //                    .padding(10)
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Choose your source of image"),
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
            
            Text("add")
                .foregroundColor(.white)
        }.onAppear{
        }
    }
    
}
