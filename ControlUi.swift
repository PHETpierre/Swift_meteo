//controller affichage ui
extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}

//structures
struct ActionMenu {
    var name: String
    var description: String
}

class ControlUi{
  let objApi = ControlApi()
  var favoris = [String]()

  //action du menu
  let actionsMenu = [
      ActionMenu(name: "1", description: "Meteo par ville"),
      ActionMenu(name: "2", description: "Meteo pour plusieurs villes"),
      ActionMenu(name: "3", description: "Favoris")
  ]

  func ajoutFavoris(city: String){
    favoris.append(city)
    print("Ville ajoutee aux favoris\n")
  }

  func menu() -> Void {
    print("--------------Meteo-------------")
    print("[1] Meteo par ville")
    print("[2] Meteo pour plusieurs villes")
    print("[3] Favoris")
    print("Veuillez selectionner une option: ")

    var userInput: ActionMenu?
    repeat {
      let actionName = readLine()
      userInput = actionsMenu.first { 
        $0.name == actionName
      }
    } while userInput == nil

    if let number = userInput?.name{
      if(number == "1"){
        meteoUi()
      }
      if(number == "2"){
        multipleUi()
      }
      if(number == "3"){
        favorisUi()
      }
    }
  }

  //action du menu meteo
  func meteoUi() -> Void {
    print("---------Meteo par ville---------")
    print("[1] Retour\n")
    print("Entrer le nom d'une ville:\n")

    var actionName = ""
    var tempCity = ""
    while actionName != "1"{
      actionName = readLine() ?? ""
      if(actionName == "2"){
        ajoutFavoris(city: tempCity)
      }else if(actionName != "" && actionName != "1"){
        tempCity = actionName
        objApi.currentMeteo(city: actionName)
        objApi.fiveDayPrevision(city: actionName, fav: true)
      }
    }
    menu()
  }

  //action du menu meteo
  func multipleUi() -> Void {
    print("-----Meteo pour plusieurs villes-----")
    print("[1] Retour\n")
    print("Entrer le nom de villes (Ville1, Ville2...):\n")

    var actionName = ""
    while actionName != "1"{
      actionName = readLine() ?? ""

      if(actionName != "" && actionName != "1"){
        let actionArr = actionName.components(separatedBy: ",")
        for action in actionArr{
          objApi.currentMeteo(city: action)
        }
      }
    }
    menu()
  }


  //action du menu favoris
  func favorisUi() -> Void {
    print("-------------Favoris-------------")
    print("[1] Retour")
    var cpt = 2
    for fav in favoris{
      print("[", cpt, "]", fav)
      cpt+=1
    }

    var actionName = ""
    while actionName != "1"{
      actionName = readLine() ?? "2"
      if(actionName != "" && actionName != "1"){
        let chiffre = Int(actionName) ?? 2
        if(favoris[safe: chiffre-2] != nil){
          objApi.currentMeteo(city: favoris[chiffre-2])
          objApi.fiveDayPrevision(city: favoris[chiffre-2], fav: false)
        }else{
          print("Entrez une valeur correcte\n")
        }
      }
    }
    menu()
  }
}