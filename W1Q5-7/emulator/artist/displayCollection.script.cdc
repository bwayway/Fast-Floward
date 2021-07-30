import Artist from "./contract.cdc"

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {

    //Get account
    let account = getAccount(address)

    //Create a collection reference of the account from the capability
    let collectionRef = account.getCapability(/publi/ArtistPictureCollection)
    .borrow<&Artist.Collection>()
    ?? panic ("Couldn't borrow account's collection capability")

    var canvases: [String] = []
    //Iterate over the collection and print out
    for canvas in collectionRef.getCanvases(){
        canvases.append(canvas.pixels)
    }

    if canvases.length <1 {
        return nil
    }
    else{
        return canvases
    }

}