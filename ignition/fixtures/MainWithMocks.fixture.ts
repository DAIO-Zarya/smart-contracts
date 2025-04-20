import DeployMockERC20 from '../modules/deploy/mocks/DeployMockERC20.ignition';

export default (hre: any) =>
  async function mainFixture() {
    const [owner, proxyAdminSigner, pauser, minter] = await hre.ethers.getSigners();

    const { mockERC20 } = await hre.ignition.deploy(DeployMockERC20);

    return { proxyAdminSigner, mockERC20 };
  };
