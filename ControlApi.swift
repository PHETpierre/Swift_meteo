//Controller des appel a l'api
import Foundation

//extension
extension URL {
  func withQueries(_ queries: [String: String]) -> URL? {
    var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
      components?.queryItems = queries.map {
        URLQueryItem(name: $0.0, value: $0.1)
      }
      return components?.url
  }
}

class ControlApi{
  let apiKey = "920e6a15902f3e6a37bfa05a9022f228"

  func currentMeteo(city: String) -> Void {
    let query: [String: String] = [
    "q": city,
    "APPID": apiKey
    ]
    let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    let url:URL = baseUrl.withQueries(query)!

    let task = URLSession.shared.dataTask(with: url){
      (data, response, error) in
        guard let data = data else{return}

        do{
          guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else{ return }

          if(jsonResult["weather"] != nil){
            print("\n")
            print(city)

            let dataArray = jsonResult["weather"] as! [[String: Any]]
            print("meteo:", dataArray[0]["description"] ?? "no weather data")

            let dataMain = jsonResult["main"] as! [String: Any]

            let temperature = dataMain["temp"] as! Double
            print("temperature:", temperature, "kelvin")
            print("temperature:", round(temperature - 273.15), "°C")
          }else{
            print("Entrez une valeur correcte\n")
          }
        }catch{
          print("err")
          return
        }
    }
    task.resume()
}

func fiveDayPrevision(city: String, fav: Bool) -> Void {
  let query: [String: String] = [
    "q": city,
    "APPID": apiKey
    ]
    let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast")!
    let url:URL = baseUrl.withQueries(query)!

    let task = URLSession.shared.dataTask(with: url){
      (data, response, error) in
        guard let data = data else{return}

        do{
          guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else{ return }

          if(jsonResult["list"] != nil){
            let dataDay = jsonResult["list"] as! [[String: Any]]
            var cpt = 0
            while(cpt < 5){
              cpt+=1
              print("\nJour", cpt)
              //weather
              let dataArray = dataDay[cpt]["weather"] as! [[String: Any]]
              print("meteo:", dataArray[0]["description"] ?? "no weather data")
              //temperature
              let dataMain = dataDay[cpt]["main"] as! [String: Any]

              let temperature = dataMain["temp"] as! Double
              print("temperature:", temperature, "kelvin")
              print("temperature:", round(temperature - 273.15), "°C\n")
              //print("temperature:", dataMain["temp"]!, "kelvin\n")
            }
            print("-----------------------------------")
            if(fav){
              print("[2]Ajouter aux favoris\n")              
            }
          }
        }catch{
          print("err")
          return
        }
    }
    task.resume()
  }
}