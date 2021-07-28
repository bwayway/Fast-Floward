pub contract Artist {

  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      // The following pixels
      // 123
      // 456
      // 789
      // should be serialized as
      // 123456789
      self.pixels = pixels
    }
  }


  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }



  pub resource Printer {

    pub let prints: {String: Canvas}

    init() {
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {


      //Check whether or not the canvas is unique
      //We want the printer to only print UNIQUE canvases

      //If the collection (prints) field doesn't contain the canvas pixels, create a picture resource of the canvas and add it to the collection
      if self.prints.containsKey(canvas.pixels) == false{
        let picture <- create Picture(canvas: canvas)
        //Add a new entry for the canvas pixel (key) with the value of the canvas
        self.prints[canvas.pixels] = canvas

        return <- picture
      }
      else{
        return nil
      }
    }
  }

  pub resource Collection {


    pub let collectionArray: @[Picture]

    init()
    {
      self.collectionArray <- []
    }

     destroy() {
      destroy self.collectionArray
    }

    pub fun deposit(picture: @Picture){
      self.collectionArray.append(<-picture)

    }
  }

  pub fun createCollection(): @Collection {
    let collection <- create Collection()
    return <- collection
    }

  init() {

  

  //Printer capabilities
    self.account.save( <- create Printer(),
    to: /storage/ArtistPicturePrinter
    )

    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter)
    }
}
