import Foundation

class JobService {
    static let shared = JobService()

    func fetchJobs(searchTerm: String? = nil, completion: @escaping (Result<[Job], Error>) -> Void) {
        var components = URLComponents(string: "API Link")!
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            components.queryItems = [URLQueryItem(name: "search", value: searchTerm)]
        }

        guard let url = components.url else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let jobResponse = try decoder.decode(JobResponse.self, from: data)
                completion(.success(jobResponse.jobs))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
