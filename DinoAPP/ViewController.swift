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
import CollectionTableView

class ViewController: UIViewController {

    @IBOutlet weak var profileImage: ProfileView!
    
    let configProvider = ConfigProvider(localConfigLoader: LocalConfigLoader(), remoteConfigLoader: RemoteConfigLoader())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let logger = Logger()
        logger.log(message: "viewDidLoad called", type: LoggingType.info)
        
        guard let backgroundUrl = URL(string: EnvironmentUtil.remoteURL + "DinoAPP/dinoBack.jpg") else { return }
        DispatchQueue.main.async() {
            self.downloadImage(from: backgroundUrl) { image in
                let backgroundImageView = UIImageView(image: image)
                backgroundImageView.frame = self.view.frame
                backgroundImageView.contentMode = .scaleToFill
                self.view.addSubview(backgroundImageView)
                self.view.sendSubviewToBack(backgroundImageView)
            }
        }
        
        guard let imageUrl = URL(string: EnvironmentUtil.remoteURL + "DinoAPP/dinoLogo.png") else { return }
        DispatchQueue.main.async() {
            self.downloadImage(from: imageUrl) { image in
                self.profileImage.image = image
            }
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let sessionConfig = URLSessionConfiguration.ephemeral
        let sessionDelegate = CertificatePinning()
        let backgroundSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        backgroundSession.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }
    }

    @IBAction func didTapOnButton(_ sender: Any) {
        let data = DinoData()
        let jsonUrl = EnvironmentUtil.remoteURL + "getQuotes"
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
                    guard let imageUrl = URL(string: EnvironmentUtil.remoteURL + "/DinoAPP/Resources/\(randomDino.getImage())") else { return }
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
        let jsonUrl = EnvironmentUtil.remoteURL + "getQuotes"
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
                    guard let imageUrl = URL(string: EnvironmentUtil.remoteURL + "DinoAPP/Resources/\(dino.getImage())") else { return }
                    self.downloadImage(from: imageUrl) { image in
                        tableData.append(QuotesModel(quote: dino.getQuote(), author: dino.getAuthor(), image: image))
                        completion(tableData)
                    }
                }
            }
        }
    }
    
    @IBAction func didPressOpenCollectionView(_ sender: Any) {
        let selfBundle = Bundle(for: CollectionTableView.self)
        let storyboard = UIStoryboard(name: "CollectionTableView", bundle: selfBundle)
        let customVC = storyboard.instantiateViewController(identifier: "CollectionTableView") as CollectionTableView
        self.present(customVC, animated: true, completion: nil)
        populateData() { array in
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                //customVC.data = array
                customVC.tableView.reloadData()
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
            DispatchQueue.main.async() {
                customVC.data = array
                customVC.tableView.reloadData()
            }
        }
    }

    @IBAction func didPressOpenView(_ sender: Any) {
        let data = DinoData()
        let jsonUrl = EnvironmentUtil.remoteURL + "getLoremIpsum"
        data.readLoremIpsum(url: jsonUrl) { result in
            DispatchQueue.main.async() {
                let customVC = CustomViewController()
                customVC.setData(data: result)
                self.present(customVC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configProvider.updateConfig()
    }
}

