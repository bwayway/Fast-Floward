import Artist from 0x03

pub fun main(){


  //Get each account and store it into an array...
  let accounts = [
    getAccount(0x01),
    getAccount(0x02),
    getAccount(0x03),
    getAccount(0x04),
    getAccount(0x05)
  ]

  //Get the collection from each account...
  for account in accounts{
    let collectionRef = 
      account.getCapability(/public/ArtistPictureCollection)
      .borrow<&Artist.Collection>()

  if collectionRef != nil
  {
    log(collectionRef!.getCanvases())
    for canvas in collectionRef!.getCanvases() 
    {
      var index = 0

      log(account.address.toString().concat(" picture #").concat((index + 1).toString()))

      while index < Int(canvas.height) {
        var line = canvas.pixels.slice(from: index * Int(canvas.width), upTo: (index +1) * Int(canvas.width))
        log(line)
        index = index + 1
      log(canvas.pixels)
      }
    }
  }
  else
  {
    log("Account ".concat(account.address.toString()).concat(" does not have a picture collection!"))

  }
  }
}
