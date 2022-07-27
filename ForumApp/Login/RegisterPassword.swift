import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class RegisterPassword: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var CPassword: UITextField!
    @IBOutlet weak var UserType: UITextField!
    @IBOutlet weak var UserTypeChoices: UIPickerView!
    
    var userTypes = ["---Choose a user Type---", "Admin", "User"]
    
    var Fname = ""      // These are all the info that are imported from the previous registration page
    var Lname = ""
    var Mname = ""
    var email = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserType.text = userTypes[row]
        if (UserType.text != "---Choose a user Type---") {
            UserTypeChoices.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.UserType) {
            self.UserTypeChoices.isHidden = false
            
            textField.endEditing(true)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        Password.delegate = self
        CPassword.delegate = self
        
        
        UserType.delegate = self
        UserTypeChoices.delegate = self
        UserTypeChoices.dataSource = self
                
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
    
    func displayMessage (userMessage: String) -> Void{
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
    
    
    @IBAction func Register(_ sender: Any) {
        // Check if all info is present
        if ((Password.text?.isEmpty)! || (CPassword.text?.isEmpty)! || (UserType.text?.isEmpty)!) {
            // Error message
            displayMessage(userMessage: "Please fill out all boxes")
            return
        }
        if (Password.text?.elementsEqual(CPassword.text!) != true) {
            displayMessage(userMessage: "Passwords do not match \nPlease enter matching passwords")
            return
        }
        
//        //Create activit indicator
//        let AI = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//
//        // Position Activity Indicator in the center of the main view
//        AI.center = view.center
//
//        //If need, you can prevent Activity Indicator from hiding when stopAnimating() is called
//        AI.hidesWhenStopped = false
//
//        // Start Activity Indicator
//        AI.startAnimating()
//
//        view.addSubview(AI)
        
        SVProgressHUD.show(withStatus: "Registering...")
        
 
        
        // Start post request to api
        let myURL = "http://upark.com.ph/API/v1/register"
        
        let param = ["Lname": Lname, "Fname": Fname, "Mname": Mname, "email": email, "user_type": UserType.text!, "password": Password.text!]
        Alamofire.request(myURL, method: .post, parameters: param , encoding: URLEncoding.httpBody).responseJSON { response in
            let data = JSON(response.result.value!)
            
//            self.removeActivityIndicator(activityIndicator: AI)
            SVProgressHUD.dismiss()
            
            let finalResult = data["error"].stringValue
            print(data)
            print(finalResult)
            
            if (data["error"] == true) {
                self.displayMessage(userMessage: "Failed to perform request. Try again later")
            } else{
                self.displayMessage(userMessage: "Registration successful. New account has been created. You can now sign in")
            }
            
            
            
/*
        // Send HTTP Request to REgister user
        let Url = URL(string: "link")
        var request = URLRequest(url: Url!)
        request.httpMethod = "POST" // Compsoe a query string
        
        let postString = [/*"userName": Username.text!, "email": Email.text!,*/ "Password": Password.text!] as [String: String]


        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: AI)
            
            if error != nil {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            // Conert response sent from a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    let userID = parseJSON["userID"] as? String
                    print("User ID: \(String(describing: userID))")
                    
                    if (userID?.isEmpty)! {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Failed to perform request. Try again later")
                        return
                    } else {
                        self.displayMessage(userMessage: "Registration successful. New account has been created. You can now sign in")
                    }
                    
                } else {
                    // Display an Alert dialog with an error message
                    self.displayMessage(userMessage: "Could not perform request. Try again later")
                }
                
            } catch {
                self.removeActivityIndicator(activityIndicator: AI)
                
            }
        }
*/
            
//        task.resume()
       
        
        }
        
    
        
        
        let back = LoginViewController(nibName: "LoginViewController", bundle: nil)
        navigationController?.pushViewController(back, animated: true)
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
