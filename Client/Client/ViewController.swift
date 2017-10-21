//
//  ViewController.swift
//  Client
//
//  Created by liuRuiLong on 2017/10/21.
//  Copyright © 2017年 baidu. All rights reserved.
//

import UIKit
import Alamofire

let serverIp = "http://192.168.1.28:8181/"

struct MovePath: Codable {
    var path: String?
    var movies: [String]
    init() {
        movies = []
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var moviePath: MovePath = MovePath.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviePath.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier") ?? UITableViewCell.init()
        cell.textLabel?.text = moviePath.movies[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        deleteFile(file: moviePath.movies[indexPath.row])
        moviePath.movies.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openFile(file: moviePath.movies[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: request
    func deleteFile(file: String) {
        let parameter = ["file" : file]
        request(serverIp + "delete", method: .post, parameters: parameter).response {(response) in
            if let data = response.data{
                let str = String.init(data: data, encoding: .utf8) ?? "unknown"
                print(str)
            }
        }
    }
    
    func openFile(file: String) {
        let parameter = ["file" : file]
        request(serverIp + "open", method: .post, parameters: parameter).response {(response) in
            if let data = response.data{
                let str = String.init(data: data, encoding: .utf8) ?? "unknown"
                print(str)
            }
        }
    }
    
    func requestData() {
        request(serverIp + "all", method: .post).response { [weak self] (response) in
            if let data = response.data{
                let str = String.init(data: data, encoding: .utf8)
                print(str!)
                do{
                    let model = try JSONDecoder.init().decode(MovePath.self, from: data)
                    self?.moviePath = model
                    self?.tableView.reloadData()
                }catch{
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

