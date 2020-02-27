struct Elections: Codable {
    let all: [Election]

    enum CodingKeys: String, CodingKey {
      case all = "results"
    }
}
