import Foundation

class MCQService {
    static let shared = MCQService()
    
    func fetchProgrammingQuestions(difficulty: String?, completion: @escaping ([MCQQuestion]?) -> Void) {
        var urlString = "URL for API" // Category 18 for programming
        
        // Append difficulty parameter if provided
        if let difficulty = difficulty {
            urlString += "&difficulty=\(difficulty)"
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching questions: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Decode the response into MCQResponse
                let decodedResponse = try decoder.decode(MCQResponse.self, from: data)
                
                // Pass the questions array to the completion handler
                completion(decodedResponse.results)
                
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
