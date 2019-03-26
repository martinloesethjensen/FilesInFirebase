import Foundation
import Firebase
import FirebaseStorage

class FirebaseService {
    
    // database
    let notesCollection = Firestore.firestore().collection("notes")
    
    // Storage
    let storage = Storage.storage() // service
    var storageRef:StorageReference?
    
    var notes = [Note]()
    
    
    func uploadImage(image:UIImage, note:Note, document:DocumentReference) {
        print("uploadImage called")
        let data = image.jpegData(compressionQuality: 1.0)
        let imageRef = storageRef?.child(note.imageName) // adds a child to current location in Storage
        imageRef?.putData(data!, metadata: nil, completion: { (metadata, error) in
            // this runs AFTER Firebase is done saving, or whatever it does
            if error != nil {
                print("failed to upload \(error.debugDescription)")
            }else {
                print("success in uploading image")
                self.writeTextToDB(note: note, document: document)
                
            }
        })
    }
    
    func writeTextToDB(note:Note, document:DocumentReference)  {
        document.setData(["text": note.text, "imageName":note.imageName]){ error in
            if error != nil {
                print("error writing text to DB")
            }else {
                print("Success in writing text to DB")
            }
        }
    }
    
    func downloadImage(fileName:String, note:Note) {
        let imageRef = storage.reference(withPath:fileName)
        imageRef.getData(maxSize: 5000000, completion: { (data, error) in
            if error != nil {
                print("failed to download \(error.debugDescription)")
            }else {
                print("success in downloading image")
                let image = UIImage(data: data!)
                note.image = image
                print("success in downloading image \(image?.debugDescription)")
            }
        })
    }
    
    func startNoteListener(){
        notesCollection.addSnapshotListener { (snapshot, error) in
            print("received new snapshot")
            self.notes.removeAll()
            for document in snapshot!.documents {
                if let text = document.data()["text"] as? String,
                    let imageName = document.data()["imageName"] as? String{
                    let note = Note(text: text, imageName: imageName)
                    self.notes.append(note) // incomplete, missing the image
                    print("received \(text)")
                }
            }
            // now ask Storage for the image files for each Note
            DispatchQueue.main.async {
                for note in self.notes {
                    self.downloadImage(fileName: note.imageName, note: note)
                }
            }
            
        }
    }
    
    
    
    
}
