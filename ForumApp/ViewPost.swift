import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewPost: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var PostTitle: UILabel!
    @IBOutlet weak var PostDesc: UILabel!
    @IBOutlet weak var Creator: UILabel!
    @IBOutlet weak var PostID: UILabel!
    @IBOutlet weak var PostPic: UIImageView!
    
    @IBOutlet weak var ViewComments: UITableView!
    
    var post_id: String = ""
    var getComments = [Comments]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getComments.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCellType") as! CommentsCellType

        cell.User.text = getComments[indexPath.item].Author
        cell.Comment.text = getComments[indexPath.item].Comment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, layout tableViewLayout: UITableViewCell, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 288, height: 50)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the
        ViewComments.delegate = self
        ViewComments.dataSource = self
        
        ViewComments.register(UINib(nibName: "CommentsCellType", bundle: nil), forCellReuseIdentifier: "CommentsCellType")
        
        // Send the http request to get all the comments for this post before starting to load them to begin with
        let myURL = "http://upark.com.ph/API/v1/getAllPostComments/\(post_id)"
        
        Alamofire.request(myURL, method: .get, encoding: URLEncoding.httpBody).responseJSON { response in
            let results = JSON(response.result.value!)
            let data = results["data"]
            
            for i in 0..<data.count {
                let caption = data[i]["comment_description"].stringValue
                let poster = data[i]["Fname"].stringValue
                
                self.getComments.append(Comments(Comment: caption, Author: poster))
            }
            
            self.ViewComments.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Refresh(_ sender: Any) {
        ViewComments.reloadData()
    }
    
    
    class Comments {
        
        var Comment: String
        var Author: String
        
        init(Comment: String, Author: String) {
            
            self.Comment = Comment
            self.Author = Author
        }
    }
    
    
}
