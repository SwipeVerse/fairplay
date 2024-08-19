import { ethers } from "hardhat";

type Location = {
    lat: number;
    lng: number;
}

const Noida = { lat: 28.535517, lng: 77.391029 }
const Delhi = { lat: 28.704060, lng: 77.102493 }
const NewYork = { lat: 40.712776, lng: -74.005974 }
const Argentina = { lat: -47.067197, lng: -69.408051 }
const Jaipur = { lat: 26.912434, lng: 75.787270 }

function compressCoordinates(location: Location): number {
    const WEI = 100000000; // 10^8
    console.log(Math.floor(((location.lat + 90) * 180 + location.lng) * WEI));
    return Math.floor(((location.lat + 90) * 180 + location.lng) * WEI);
}

function web3StringToBytes32(text: string): string {
    let result = ethers.hexlify(ethers.toUtf8Bytes(text));
    while (result.length < 66) { result += '0'; }
    if (result.length !== 66) { throw new Error("invalid web3 implicit bytes32"); }
    console.log('result', result);
    return result;
}

async function main(): Promise<void> {
    const Fairplay = await ethers.getContractFactory("Fairplay");
    const SwipeVerseCaptain = await ethers.getContractFactory("SwipeVerseCaptain");

    const [SwipeVXWallet, Mike, Ram, Jai, Bhaan] = await ethers.getSigners();

    const MikeNFT = await Fairplay.connect(Mike).deploy(web3StringToBytes32('Mike'), new Date('01/03/1991').getTime(), 0, compressCoordinates(NewYork));
    const JaiNFT = await Fairplay.connect(Jai).deploy(web3StringToBytes32('Jai'), new Date('09/21/1997').getTime(), 0, compressCoordinates(Delhi));

    const swipeVXCapt = await SwipeVerseCaptain.connect(SwipeVXWallet).deploy(1, 10, SwipeVXWallet);
    await swipeVXCapt.disburse(Mike);
    await swipeVXCapt.disburse(Jai);
    const balOwner = await swipeVXCapt.connect(SwipeVXWallet).getBalance()
    let balMike = await swipeVXCapt.connect(Mike).getBalance()
    let balJai = await swipeVXCapt.connect(Jai).getBalance()

    console.log('Owner Balance ', balOwner,' address ',SwipeVXWallet.address)
    console.log('Mike Balance ', balMike,' address ',Mike.address)
    console.log('Jai Balance ', balJai,' address ',Jai.address)

    swipeVXCapt.connect(Mike).swipeRight(MikeNFT.getAddress(), Jai);
    console.log("===== After swipe right =====")
    balMike = await swipeVXCapt.connect(Mike).getBalance()
    console.log('Mike Balance ', balMike,' address ',Mike.address)
    swipeVXCapt.connect(Jai).swipeRight(JaiNFT.getAddress(), Mike);

    balMike = await swipeVXCapt.connect(Mike).getBalance()
    balJai = await swipeVXCapt.connect(Jai).getBalance()

    console.log('===== After match =====')
    console.log('Mike Balance ', balMike,' address ',Mike.address)
    console.log('Jai Balance ', balJai,' address ',Jai.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
