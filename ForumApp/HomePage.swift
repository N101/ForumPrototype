import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class HomePage: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ForumTable: UITableView!
    
    var getPosts = [Posts]()
    
    let list = ["Test", "Hello", "Dog", "Nathalie"]
    let list2 = ["testing", "hi", "doggie", "damn I really miss her"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return(list.count)
        return getPosts.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellType") as! CellType
//            UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.Header.text = getPosts[indexPath.item].Title
        cell.Subtext.text = getPosts[indexPath.item].Desc
        cell.user_name.text = "‣ " + getPosts[indexPath.item].poster
        cell.post_id.text = "post id: " + getPosts[indexPath.item].postID
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, layout tableViewLayout: UITableViewCell, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 135)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let OpenPost = ViewPost(nibName: "ViewPost", bundle: nil)
        OpenPost.post_id = getPosts[indexPath.item].postID
        navigationController?.pushViewController(OpenPost, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ForumTable.delegate = self
        ForumTable.dataSource = self
        
        ForumTable.register(UINib(nibName: "CellType", bundle: nil), forCellReuseIdentifier: "CellType")
        
        
        // Send the http request to get all the current posts before starting so that to load them at the beginning
        let myURL = "http://upark.com.ph/API/v1/getAllPost"
        
        Alamofire.request(myURL, method: .get, encoding: URLEncoding.httpBody).responseJSON { response in
            let data = JSON(response.result.value!)
            let param = ["post_title", "post_desc", "Fname", "post_id"]
            let inside = data["data"]
            
            for i in 0..<inside.count {
                let title = inside[i]["post_title"].stringValue
                let description = inside[i][param[1]].stringValue
                let owner = inside[i][param[2]].stringValue
                let postN = inside[i][param[3]].stringValue
                                
                self.getPosts.append(Posts(Title: title, Desc: description, /*Pic: nil,*/ poster: owner, postID: postN))
            }
            
            self.ForumTable.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func SignOut(_ sender: Any) {
        let SignOut = LoginViewController(nibName: "LoginViewController", bundle: nil)
        navigationController?.pushViewController(SignOut, animated: true)
    }
    
    @IBAction func CreateNew(_ sender: Any) {
        let np = NewPost(nibName: "NewPost", bundle: nil)
        navigationController?.pushViewController(np, animated: true)
    }
    
    @IBAction func Refresh(_ sender: Any) {
        ForumTable.reloadData()
    }
    
    
    class Posts {
     
        var Title: String
        var Desc: String
//        var Pic: UIImage
        var poster: String
        var postID: String
        
        init(Title: String, Desc: String, /*Pic: UIImage,*/ poster: String, postID: String) {
        
            self.Title = Title
            self.Desc = Desc
//            self.Pic = Pic
            self.poster = poster
            self.postID = postID
            
        }
        
    }
    
   

}
