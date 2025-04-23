//
//  QuoteService.swift
//  CareerMentor
//
//  Created by user275188 on 4/5/25.
//


import Foundation

class QuoteService {
    static let shared = QuoteService()
    private init() {}

    func fetchMotivationalQuote(completion: @escaping (Quote?) -> Void) {
        let url = URL(string: "URL for API")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let quote = try JSONDecoder().decode([Quote].self, from: data)
                    completion(quote.first)
                } catch {
                    print("Decoding error:", error)
                    completion(nil)
                }
            } else {
                print("Network error:", error ?? "Unknown error")
                completion(nil)
            }
        }.resume()
    }
}
