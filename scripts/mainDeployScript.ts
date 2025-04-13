import hardhatRuntimeEnvironment from 'hardhat';
import { parseEther } from 'ethers';

import mainStage from '../stages/Main.stage';

async function main(hre: any) {
  const [owner, proxyAdminOwner] = await hre.ethers.getSigners();
  const ownerAddr = await owner.getAddress();
  const proxyAdminOwnerAddr = await proxyAdminOwner.getAddress();
  // const { dogeGoGo, poolsBasedPresale, lockedBalance } = await mainStage(hre, ownerAddr, ownerAddr, ownerAddr)();

  console.log(`ProxyAdmin owner address: ${proxyAdminOwnerAddr}`);
}

main(hardhatRuntimeEnvironment).catch(console.error);
