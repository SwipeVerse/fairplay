import IPFS from "./ipfs";
import dotenv from "dotenv";
import { Profile, ProfileImages } from "./type"
import fs from "fs"

dotenv.config()

async function main() {
    // prepare IPFS communication
    const ipfs = new IPFS();
    const IMAGES_COUNT = 2;
    const images = [];
    const CIDs = {
        images: '',
        profile: ''
    };

    console.log('====================== Initiating upload!! ======================');
    const imagesExists = fs.existsSync(`${__dirname}/ipfs/images.json`);
    if (imagesExists) {
        console.log('Skipping images upload, file exists');
    } else {
        // upload images
        for (let i = 1; i <= IMAGES_COUNT; i++) {
            const imageFile = fs.readFileSync(`${__dirname}/ipfs/swipeverse-profile-${i}.jpg`);
            const image = new File([imageFile], `image-${i}.jpg`, { type: "image/jpeg" });
            const imageCID = await ipfs.upload(image);
            console.log('Image uploaded to IPFS with cid : ', imageCID);
            images.push(imageCID?.IpfsHash);
        }
        const imagesJSON = new File([JSON.stringify({ images })], "images.json", { type: "application/json" });
        const imagesCID = await ipfs.upload(imagesJSON);
        console.log('Images uploaded to IPFS with cid :', imagesCID);
        // write files to path
        const imagesFetched = await ipfs.get(imagesCID?.IpfsHash as string);
        console.log('images data : ', imagesFetched?.data);
        fs.writeFileSync(`${__dirname}/ipfs/images.json`, JSON.stringify(imagesFetched?.data));
        CIDs.images = <string>imagesCID?.IpfsHash;
    }

    const profileExists = fs.existsSync(`${__dirname}/ipfs/profile.json`);
    if (profileExists) {
        console.log('Skipping profile upload, file exists');
    } else {
        // deploy basic details json
        const profileTempJSON: Profile = {
            name: 'John Doe',
            description: 'Likes to party!!!',
            profileImage: images[0] as string,
        }
        const profileJSON = new File([JSON.stringify(profileTempJSON)], "profile.json", { type: "application/json" });
        const profileCID = await ipfs.upload(profileJSON);
        console.log('Profile uploaded to IPFS with cid : ', profileCID);
        const profileFetched = await ipfs.get(profileCID?.IpfsHash as string);
        console.log('profile data : ', profileFetched?.data);
        fs.writeFileSync(`${__dirname}/ipfs/profile.json`, JSON.stringify(profileFetched?.data));
        CIDs.profile = <string>profileCID?.IpfsHash;
    }
    fs.writeFileSync(`${__dirname}/ipfs/CIDs.json`, JSON.stringify(CIDs));
    console.log('====================== All files uploaded!! ======================');

    // // iterage over fetched data
    // const temp = await ipfs.get(<string>profileCID?.IpfsHash)
    // console.log('fetched file', temp)
    // console.log('file type ', typeof(temp), typeof(temp?.data) )
    // console.log('file type ', temp?.data)
    // console.log('file type ', <Profile>(temp?.data)?.name)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
