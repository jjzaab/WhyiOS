//
//  PostController.swift
//  WhyiOS
//
//  Created by XMS_JZhan on 2/6/19.
//  Copyright © 2019 XMS_JZhan. All rights reserved.
//

import Foundation

class PostContoller {
    
    // MARK: - Singleton
    static let shared = PostContoller()
    
    let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    // MARK: - http GET method
    func getPost(completion: @escaping (([Post]?) -> Void)) {
        guard let baseURL = baseURL else { return }
        let finalURL = baseURL.appendingPathExtension("json")
        print(finalURL)
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error")
                completion(nil)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let posts = try jsonDecoder.decode([String:Post].self, from: data)
                completion(posts.compactMap { $1 as Post })
                
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
    // MARK: - http POST method
    func addPost(cohort: String, name: String, reason: String, completion: @escaping ((Bool) -> Void)) {
        guard let baseURL = baseURL else { return }
        let finalURL = baseURL.appendingPathExtension("json")
        
        let newPost = Post.init(cohort: cohort, name: name, reason: reason)
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(newPost)
            var urlRequest = URLRequest(url: finalURL)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = data
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard data != nil else {
                    print("Error")
                    completion(false)
                    return
                }
                completion(true)
            }
            dataTask.resume()
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
}
