import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NewPost: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var PostTitle: UITextField!
    @IBOutlet weak var PostDesc: UITextField!
    
    var UserID = UserDefaults.standard.string(forKey: "current_user_id")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PostTitle.delegate = self
        PostDesc.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        print(UserID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func displayMessage (userMessage: String) -> Void{
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action:UIAlertAction!) in
                // Code in this block will will trigger when the OK button is pressed
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion:  nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func Create(_ sender: Any) {
        
        if ((PostTitle.text?.isEmpty)! || (PostDesc.text?.isEmpty)!) {
            displayMessage(userMessage: "Please fill out all the boxes")
            return
        }
        
        SVProgressHUD.show(withStatus: "Posting")
        
        let myURL = "http://upark.com.ph/API/v1/createPost"
        
        Alamofire.request(myURL, method: .post, parameters: ["post_title": PostTitle.text!, "post_desc": PostDesc.text!, "user_id": UserID], encoding: URLEncoding.httpBody).responseJSON { response in
            let data = JSON(response.result.value!)
            print(data)
            
            SVProgressHUD.dismiss()
            
            if (data["error"].boolValue == true) {
                self.displayMessage(userMessage: "Failed to create Post")
                return
            } else{
                self.displayMessage(userMessage: "Successfully created Post")
                
                let goBack = HomePage(nibName: "HomePage", bundle: nil)
                self.navigationController?.pushViewController(goBack, animated: true)
            }
            
        }
        
    }
    
    @IBAction func CancelCreate(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
