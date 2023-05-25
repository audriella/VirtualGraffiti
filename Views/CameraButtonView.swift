import SwiftUI

struct CameraButtonView: View {
    @State var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(.infinity)
            } else {
                Circle()
                    .fill(.gray)
                    .frame(width: 100, height: 100)
            }
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .padding(10)
            
        }
    }
    
}

struct cameraButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CameraButtonView(selectedImage: UIImage(systemName: "photo"))
    }
}
