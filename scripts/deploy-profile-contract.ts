import { ethers } from "hardhat";
import fs from "fs";

async function main() {
    // check if IPDS upload was successful
    const CIDExists = fs.existsSync(`${__dirname}/ipfs/CIDs.json`);
    if(!CIDExists) {
        throw new Error(`${__dirname}/ipfs/CIDs.json does not exist. Please run npm run deploy-profile-ipfs first`)
    }

    const CIDsRead = fs.readFileSync(`${__dirname}/ipfs/CIDs.json`, 'utf-8');
    console.log('CIDs data : ',CIDsRead);
    const CID = JSON.parse(CIDsRead);

    // change the profile owner from wallet owner to SwipeVerseCaptain contract address
    // and make delegate calls from 
    const [ProfileOwner] = await ethers.getSigners();
    const userProfile = await ethers.deployContract("FairplayUser", [ProfileOwner.address]);
    await userProfile.waitForDeployment();
    console.log(
        `Profile deployed with admin/owner ${ProfileOwner.address} with ${userProfile.target}`
    );

    // perform self safeMint
    await userProfile.safeMint(ProfileOwner.address, 1, CID.profile)
    
    // update image URI
    await userProfile.updateImageURI(CID.images)

    // update profile URI; IPFS upload step is missing
    // await userProfile.updateTokenURI(1, CID.profile);

    // get profile details
    const imagesURI = await userProfile.getImagesURI()
    console.log('Images URI in contract : ', imagesURI)
    const profileURI = await userProfile.tokenURI(1)
    console.log('Profile URI in contract : ', profileURI)
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  