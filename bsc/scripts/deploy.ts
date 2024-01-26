import { ethers } from "hardhat";

async function main() {
  const token = '0x55d398326f99059fF775485246999027B3197955';
  const recipient = '0x112e739cbf9CaD1b6b0DA7EbA9555370a67B6bd4';

  const Pool = await ethers.getContractFactory("Pool");
  const contract = await Pool.deploy();
  console.log("Pool deployed to:", contract.address);
  await contract.setInfo(token, recipient);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


