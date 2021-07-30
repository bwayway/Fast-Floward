pub contract Artist {

  pub event PicturePrintSuccess(pixels: String)
  pub event PicturePrintFailure(pixels: String)

  // A structure that will store a two dimensional canvas made up of ASCII
  // characters (usually one character to indicate an on pixel, and one for off).
  pub struct Canvas {

    pub let width: Int
    pub let height: Int
    pub let pixels: String

    init(width: Int, height: Int, pixels: String) {
      self.width = width
      self.height = height
      // The following canvas
      // 123
      // 456
      // 789
      // should be serialized as
      // 123456789
      self.pixels = pixels
    }
    
  }

  // A resource that will store a single canvas
  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Collection {
    pub let pictures: @[Picture]

    pub fun deposit(picture: @Picture) {
      let pixels = picture.canvas.pixels
      self.pictures.append(<- picture)
    }

    pub fun getCanvases(): [Canvas] {
      var canvases: [Canvas] = []
      var index = 0
      while index < self.pictures.length {
        canvases.append(
          self.pictures[index].canvas
        )
        index = index + 1
      }

      return canvases;
    }

    init() {
      self.pictures <- []
    }
    destroy() {
      destroy self.pictures
    }
  }

  pub fun createCollection(): @Collection {
    return <- create Collection()
  }

  // Printer ensures that only one picture can be printed for each canvas.
  // It also ensures each canvas is correctly formatted (dimensions and pixels).
  pub resource Printer {
    pub let prints: {String: Canvas}

    init() {
      self.prints = {}
    }

    // possible synonyms for the word "canvas"
    pub fun print(width: Int, height: Int, pixels: String): @Picture? {
      // Canvas can only use visible ASCII characters.
      for symbol in pixels.utf8 {
        if symbol < 32 || symbol > 126 {
          return nil
        }
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(pixels) == false {
        let canvas = Canvas(
          width: width,
          height: height,
          pixels: pixels
        )
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas

        emit PicturePrintSuccess(pixels: pixels)

        return <- picture
      } else {
        emit PicturePrintFailure(pixels: pixels)
        return nil
      }
    }
  }

  init() {
    self.account.save(
      <- create Printer(),
      to: /storage/ArtistPicturePrinter
    )
    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter
    )

    self.account.save(
      <- self.createCollection(),
      to: /storage/ArtistPictureCollection
    )
    self.account.link<&Collection>(
      /public/ArtistPictureCollection,
      target: /storage/ArtistPictureCollection
    )
  }
}