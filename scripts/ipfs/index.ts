import { PinataSDK } from "pinata";

class IPFS {

    private gateway = 'peach-absent-spoonbill-704.mypinata.cloud';
    private pinata: PinataSDK;

    constructor() {
        // initialse auth
        this.pinata = new PinataSDK({
            pinataJwt: process.env.PINATA_JWT!,
            pinataGateway: this.gateway,
        });
    }

    public async upload(file: File) {
        try {
            // const file = new File(["hello"], "Testing.txt", { type: "text/plain" });
            const upload = await this.pinata.upload.file(file);
            return upload;
        } catch (error) {
            console.log(error);
        }
    }

    public async get(cid: string) {
        try {
            const data = await this.pinata.gateways.get(cid);
            // console.log(data)
            return data;
        } catch (error) {
            console.log(error);
        }
    }
}

export default IPFS;