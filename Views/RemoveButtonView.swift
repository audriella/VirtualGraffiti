import SwiftUI
import ARKit
import RealityKit

struct RemoveButtonView: View {
    @State private var images: [ARImageAnchor] = []
    let removeButtonDidPressed: (() -> Void)?
    
    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .fill(.pink)
                    .frame(width: 60, height: 60)
                Button {
                    removeButtonDidPressed?()
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                }
            }
            Text("remove")
                .foregroundColor(.white)
        }
    }
}

struct removeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RemoveButtonView(removeButtonDidPressed: {
            
        })
        
    }
}
