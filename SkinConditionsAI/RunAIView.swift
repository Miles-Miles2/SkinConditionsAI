//
//  ContentView.swift
//  Animal Friends
//
//  Created by Keiser on 8/15/22.
//

import SwiftUI
import SwiftyJSON
import Alamofire



struct RunAIView: View {
    @State var animalName = " "
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = UIImage(named: "startImage")
    
    var body: some View {
        ZStack {
            Color(red: 0.141, green: 0.3, blue: 0.45)
                .ignoresSafeArea()
            HStack {
                VStack (alignment: .center,
                        spacing: 20){
                    Text("Skin Conditions")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(animalName)
                    Image(uiImage: inputImage!).resizable()
                        .aspectRatio(contentMode: .fit)
                    //Text(animalName)
                    Button {
                        self.buttonPressed()
                    } label: {
                        Text("What do I have?")
                            .fontWeight(.bold)
                    }
                    .padding(.all, 14.0)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(20)
                }
                        .font(.title)
            }.sheet(isPresented: $showingImagePicker, onDismiss: processImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    func processImage(){
        self.showingImagePicker = false
        
        guard let inputImage = inputImage else {return}
        self.animalName="Checking..."
        print("Processing image due to Button press")
        let imageJPG=inputImage.jpegData(compressionQuality: 0.0034)!
        let imageB64 = Data(imageJPG).base64EncodedData()
        let uploadURL="https://askai.aiclub.world/b2ebd196-902e-4107-ac76-d6aae70afd0c"
        
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            
            debugPrint(response)
            switch response.result {
            case .success(let responseJsonStr):
                print("\n\n Success value and JSON: \(responseJsonStr)")
                let myJson = JSON(responseJsonStr)
                let predictedValue = myJson["predicted_label"].string
                print("Saw predicted value \(String(describing: predictedValue))")
                
                
                let predictionMessage = predictedValue!
                self.animalName=predictionMessage
            case .failure(let error):
                print("\n\n Request failed with error: \(error)")
            }
        }
    }
    
    func buttonPressed(){
        print("button pressed")
        self.showingImagePicker = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RunAIView()
    }
    
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        //picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
