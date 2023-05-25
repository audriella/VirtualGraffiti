import SwiftUI

struct SaveButtonView: View {
    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .fill(.gray)
                    .frame(width: 80, height: 80)
                
                Button(action: saveImage) {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                        .foregroundColor(.white)
                }
            }
            Text("save")
                .foregroundColor(.white)
        }
    }
    func saveImage() {
        print("Save")
    }
}

struct saveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SaveButtonView()
    }
}
