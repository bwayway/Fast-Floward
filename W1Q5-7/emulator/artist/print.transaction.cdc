import Artist from "./contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: Int, height: Int, pixels: String) {

    let collectionRef: &Artist.Collection

    prepare(account: AuthAccount){

        

        let printerRef = getAccount(f8d6e0586b0a20c7).getCapability(/public/ArtistPicturePrinter)
        .borrow<&Artist.Printer>()
        ?? panic("Could no borrow printer reference")

        //Get the collection reference from the account
        self.collectionRef = account.getCapability(/public/ArtistPictureCollection)
        .borrow<&Artist.Collection>()
        ?? panic("Couldn't borrow collection reference")

        let picture <- printerRef.print(width: width,
            height: height,
            pixels: pixels)

    }

    execute{
        if self.picture == nil{
            log("Picture couldn't be printed")
            destroy self.picture
        }
        else{
            self.collectionRef.deposit(picture <- self.picture!)
        }
        
    }
}