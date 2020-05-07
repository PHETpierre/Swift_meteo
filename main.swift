import Foundation

func jsonParsingVille() -> Void {
  if let path = Bundle.main.path(forResource: "data/city.list", ofType: "json") {
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:[]) as? [Any] else{ return }

      var cpt = 0
      for dataDic in jsonResult{
        if cpt==0{
          print(dataDic)
          cpt+=1
        }else{
          return
        }
      }
      
      /*if let jsonResult = jsonResult as? Dictionary<String, AnyObject>,
      let ville = jsonResult["name"] as? [Any] {
        print(ville)
      }*/

    }catch{
      print("err")
      return
    }
  }
}

let objUi = ControlUi()
objUi.menu()

RunLoop.main.run()