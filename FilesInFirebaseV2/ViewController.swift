import UIKit
import FirebaseStorage

class ViewController: UIViewController {

    var storage : Storage?
    var storageRef : StorageReference?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        storage = Storage.storage() //This is the storage service
        storageRef = storage!.reference() //This is the root for all the files
        if let dogImage = UIImage(named: "doggo.jpg"){
            uploadImage(image: dogImage, filename: "doggo.jpg")
        }else {
            print("no dog found")
        }
    }


    @IBAction func savePressed(_ sender: Any) {

    }

    func uploadImage(image:UIImage, filename:String) {
        let data = image.jpegData(compressionQuality: 1.0)
        let imageRef = storageRef?.child(filename)
        imageRef?.putData(data!, metadata: nil, completion: { (metadata, error) in
            //This runs AFTER Firebase is done saving, or whatever it does
            if error != nil {
                print("failed to upload \(error.debugDescription)")
            }else {
                print("Success in uploading image")
            }
        })
    }

    @IBAction func downloadImagePressed(_ sender: Any) {
        let imageRef = storage?.reference(withPath: "doggo.jpg")
        imageRef?.getData(maxSize: 5000000, completion: { (data, error) in
            if error != nil {
                print("failed to download \(error.debugDescription)")
            }else {
                print("success in downloading image")
                let image = UIImage(data:data!)
                self.imageView.image = image
            }
        })
    }

}

