import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ErrorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ErrorMsg.text = ""
        
        Username.delegate = self
        Password.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMessage (userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action:UIAlertAction!) in
                // COde in this block will will trigger when the OK button is pressed
                print("OK button pressed")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion:  nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

    
    
    @IBAction func goToRegister(_ sender: Any) {
        let vc = Register(nibName: "Register", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LogIn(_ sender: Any) {
        let userName = Username.text
        let password = Password.text
        
        // Check if all fields are filled out
        if ((userName?.isEmpty)! || (password?.isEmpty)!) {
            // Display error message
            ErrorMsg.text = ("Username \(String(describing: userName)) or password \(String(describing: password)) is empty")
            return
        }
        
/*
        //Create activit indicator
        let AI = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle
            .gray)
        
        // Position Activity Indicator in the center of the main view
        AI.center = view.center
        
        //If neede, youcan prevent Activity Indicator from hiding when stopAnimating() is called
        AI.hidesWhenStopped = false
        
        // // Start Activity Indicator
        AI.startAnimating()
        
        view.addSubview(AI)
*/
        SVProgressHUD.show(withStatus: "Logging In")
        
        
        let myURL = "http://upark.com.ph/API/v1/login"
        
        if ((Username.text?.isEmpty)! || (Password.text?.isEmpty)!) {
            ErrorMsg.text = "Please enter an email/password"
            displayMessage(userMessage: "Please enter an email/password")
            return
        }
        
        Alamofire.request(myURL, method: .post, parameters: ["email": Username.text!, "password": Password.text!], encoding: URLEncoding.httpBody).responseJSON {response in
            let data = JSON(response.result.value!)
            SVProgressHUD.dismiss()
            
            let user_info = data["user"]
            let userID = user_info[0]["user_id"].stringValue
            UserDefaults.standard.set(userID, forKey: "current_user_id")
            print(userID)
            
            if (data["error"] == true) {
                self.displayMessage(userMessage: "Log In failed. Incorrect credentials")
                return
            } else {
                let hp = HomePage(nibName: "HomePage", bundle: nil)
                self.navigationController?.pushViewController(hp, animated: true)
            }
        }
        
        
        
/*
        // Send HTTP Requtes to peerform Sign in
        let Url = URL(string: "link")
        var request = URLRequest(url: Url!)
        
        request.httpMethod = "POST"// compose a query string
        
        let postString = ["Username": userName!, "Password": password!] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: AI)
            
            if (error != nil) {
                self.displayMessage(userMessage: "Failed to perform request. Try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            // convert response sent form a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // access value of Username by its key
                    let accessToken = parseJSON["token"] as? String  // depends on what the http site returns so can be changed later
                    let userID = parseJSON["id"] as? String         // Same for ID
                    print("Acces token: \(String(describing: accessToken!))")
                    
                    if (accessToken?.isEmpty)! {
                        // error msg
                        self.displayMessage(userMessage: "Failed to perform request. Try again later")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let hp = HomePage(nibName: "HomePage", bundle: nil)
                        self.navigationController?.pushViewController(hp, animated: true)
                        
                    }
                    
                } else {
                    
                    self.displayMessage(userMessage: "Failed to perform request. Try again later")
                }
                
            } catch {
                self.removeActivityIndicator(activityIndicator: AI)
                
                self.displayMessage(userMessage: "Failed to perform request. Try again later")
                print(error)
            }
            
            
        }
*/
        
//        task.resume()
        
    }


}
