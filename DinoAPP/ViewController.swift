//
//  ViewController.swift
//  DinoAPP
//
//  Created by Fabio Silvestri on 27/09/21.
//

import UIKit
import DinoData
import DinoComponents
import CustomTableView

class ViewController: UIViewController {

    @IBOutlet weak var profileImage: ProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let logger = Logger()
        logger.log(message: "viewDidLoad called", type: LoggingType.info)
        
        profileImage.image = UIImage(named: "dinoClearLogo")
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }
    }

    @IBAction func didTapOnButton(_ sender: Any) {
        let data = DinoData()
        let jsonUrl = "https://vps.rup.com.br/DinoAPP/Resources/Dinosaurs_quotes.json"
        data.readDinoJSON(of: QuotesJsonModel.self, url: jsonUrl) { result in
            switch result {
            case let .failure(error):
                if error is DataError {
                    print("err is: \(error.localizedDescription)")
                } else {
                    print("err is \(error.localizedDescription)")
                }
                print(error.localizedDescription)
            case let .success(dinos):
                if let randomDino = dinos.randomElement() {
                    guard let imageUrl = URL(string: "https://vps.rup.com.br/DinoAPP/Resources/\(randomDino.getImage())") else { return }
                    DispatchQueue.main.async() {
                        let alertView = RFAlertView(frame: self.view.bounds)
                        self.downloadImage(from: imageUrl) { image in
                            alertView.set(image: image)
                        }
                        alertView.set(headline: randomDino.getAuthor())
                        self.view.addSubview(alertView)
                    }
                }
            }
        }
    }
    
    func populateData(completion: @escaping ([QuotesModel]) -> Void) {
        let data = DinoData()
        let jsonUrl = "https://vps.rup.com.br/DinoAPP/Resources/Dinosaurs_quotes.json"
        data.readDinoJSON(of: QuotesJsonModel.self, url: jsonUrl) { result in
            switch result {
            case let .failure(error):
                if error is DataError {
                    print("err is: \(error.localizedDescription)")
                } else {
                    print("err is \(error.localizedDescription)")
                }
                completion([])
            case let .success(dinos):
                var tableData = [QuotesModel]()
                for dino in dinos {
                    guard let imageUrl = URL(string: "https://vps.rup.com.br/DinoAPP/Resources/\(dino.getImage())") else { return }
                    self.downloadImage(from: imageUrl) { image in
                        tableData.append(QuotesModel(quote: dino.getQuote(), author: dino.getAuthor(), image: image))
                        completion(tableData)
                    }
                }
            }
        }
    }
    
    @IBAction func didPressOpenTableView(_ sender: Any) {
        let selfBundle = Bundle(for: CustomTableViewController.self)
        let storyboard = UIStoryboard(name: "CustomTableViewController", bundle: selfBundle)
        let customVC = storyboard.instantiateViewController(identifier: "CustomTableViewController") as CustomTableViewController
        self.present(customVC, animated: true, completion: nil)
        populateData() { array in
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                customVC.data = array
                customVC.tableView.reloadData()
            }
        }
    }

    @IBAction func didPressOpenView(_ sender: Any) {
        let data = DinoData()
        let jsonUrl = "https://vps.rup.com.br/DinoAPP/Resources/LoremIpsum.json"
        data.readLoremIpsum(url: jsonUrl) { result in
            DispatchQueue.main.async() {
                let customVC = CustomViewController()
                customVC.setData(data: result)
                self.present(customVC, animated: true, completion: nil)
            }
        }
    }
    
}

