import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Binding var imageUrl: URL?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.parent.selectedImage = selectedImage
                }
                
            }
            if picker.sourceType == UIImagePickerController.SourceType.camera {
                let imgName = "\(UUID().uuidString).png"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                
                let data = (parent.selectedImage?.pngData())! as NSData
                data.write(toFile: localPath, atomically: true)
                DispatchQueue.main.async {
                    self.parent.imageUrl = URL.init(fileURLWithPath: localPath)
                }
            } else if let selectedImageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                DispatchQueue.main.async {
                    self.parent.imageUrl = selectedImageUrl
                }
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
