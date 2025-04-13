// import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
// import { ZeroAddress, parseEther } from "ethers";

// import deployProxyModuleBuilder from "../../../reusables/deployProxy.reusable";

// const moduleName = "DeployAutoreflectiveDistributionERC20";
// export default buildModule(moduleName, (m) => {
//   const internalBalanceERC20 = m.getParameter("internalBalanceERC20", ZeroAddress);
//   const tradingPaymentChannel = m.getParameter("tradingPaymentChannel", ZeroAddress);
//   const nftCollection = m.getParameter("nftCollection", ZeroAddress);
//   const owner = m.getParameter("owner", m.getAccount(0));
//   const underlyingToken = m.getParameter("underlyingToken", ZeroAddress);
//   const cap = m.getParameter("cap", parseEther("100000"));
//   const exitDuration = m.getParameter("exitDuration", 0)
//   const { implementation, proxy, proxyAdmin } = m.useModule(
//     deployProxyModuleBuilder(
//       "AutoreflectiveDistributionERC20",
//       moduleName,
//       [internalBalanceERC20, tradingPaymentChannel, nftCollection, owner, underlyingToken, cap, exitDuration]
//     )
//   );
//   return {
//     autoreflectiveDistributionERC20Impl: implementation,
//     autoreflectiveDistributionERC20: proxy,
//     autoreflectiveDistributionERC20ProxyAdmin: proxyAdmin
//   };
// });
