
const hre = require("hardhat");

async function main() {
  

  const degenToken = await hre.ethers.deployContract("DegenToken");

  await degenToken.waitForDeployment();

  console.log(
    `DegenToken deployed to ${degenToken.target}`
  );
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
