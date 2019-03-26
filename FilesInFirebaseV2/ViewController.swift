import UIKit
import Firebase
import FirebaseStorage

let fS = FirebaseService()
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fS.storageRef = fS.storage.reference()  // this is the root for all the files
        fS.startNoteListener()
        if let dogImage = UIImage(named: "doggo.jpg"){
            imageView.image = dogImage
        }else {
            print("no dog found")
        }
    }
    @IBAction func savePressed(_ sender: Any) {
        let document = fS.notesCollection.document()  // get a unique ID
        let note = Note(text: textView.text, imageName: "\(document.documentID).jpg")
        if let image = imageView.image {
            fS.uploadImage(image: image, note:note, document:document)
        }
        
        
    }
    
    
    
    //    func uploadImage(image:UIImage, filename:String) {
    //        let data = image.jpegData(compressionQuality: 1.0)
    //        let imageRef = storageRef?.child(filename)
    //        imageRef?.putData(data!, metadata: nil, completion: { (metadata, error) in
    //            // this runs AFTER Firebase is done saving, or whatever it does
    //            if error != nil {
    //                print("failed to upload \(error.debugDescription)")
    //            }else {
    //                print("success in uploading image")
    //            }
    //        })
    //    }
    
    
    @IBAction func downloadImagePressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        } else {
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
