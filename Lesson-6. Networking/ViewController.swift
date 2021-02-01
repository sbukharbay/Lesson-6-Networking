//
//  ViewController.swift
//  Lesson-6. Networking
//
//  Created by Sultangazy Bukharbay on 2/1/21.
//

import UIKit
import Alamofire
import Moya

class ViewController: UIViewController {

    @IBOutlet weak var randomImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPressed(_ sender: Any) {
        moyaRequest()
    }
    
    func moyaRequest() {
        let provider = MoyaProvider<API>()
        provider.request(.random) { (result) in
            switch result {
                case .success(let response):
                    if let jsonPetitions = try? JSONDecoder().decode(RandomImage.self, from: response.data) {
                        let petitions: RandomImage = jsonPetitions
                        self.getImage(url: petitions.message)
                    }
                case .failure(let error):
                    print("Error", error)
            }
        }
    }
    
    func alamofireRequest() {
        let alamofire = AF.request("https://dog.ceo/api/breeds/image/random")
        alamofire.responseJSON { (json) in
            print(json.description)
        }
        
        alamofire.responseDecodable(of: RandomImage.self) { (response) in
            guard let data = response.value else {return}
            self.getImage(url: data.message)
        }
    }
    
    func postRequest() {
        let session = URLSession.shared
        let url = URL(string: "https://example.com/post")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json = [
            "username": "sula",
            "message": "Wow, thanks!"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("respPost 1", dataString)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("respPost 2", httpResponse.statusCode)
            }
        }

        task.resume()
    }
    
    func getRequest() {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let rowData = data {
                do {
                    let json = try JSONDecoder().decode(RandomImage.self, from: rowData)
                    self.getImage(url: json.message)
                } catch {
                    print("Error parsing to dictionary")
                }
            }
        }
        task.resume()
    }
    
    func getImage(url: String) {
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            if let rowData = data {
                DispatchQueue.main.async {
                    self.randomImageView.image = UIImage(data: rowData)
                }
            }
        }
        task.resume()
    }
}

struct RandomImage: Codable {
    var message: String
    var status: String
}
