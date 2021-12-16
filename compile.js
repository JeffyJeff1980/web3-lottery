const path = require("path");
const solc = require("solc");
const fs = require("fs-extra");

const buildPath = path.resolve(__dirname, "contracts");
const lotteryPath = path.resolve(buildPath, "Ballot.sol");
const source = fs.readFileSync(lotteryPath, "utf8");

var input = {
  language: "Solidity",
  sources: {
    "Ballot.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));

const interface = output.contracts["Ballot.sol"].Lottery.abi;
const bytecode = output.contracts["Ballot.sol"].Lottery.evm.bytecode.object;

fs.outputJSONSync(path.resolve(buildPath, "BallotABI.json"), output.contracts["Ballot.sol"].Lottery.abi);

console.log("\nBytecode: ", bytecode, "\nABI: ", interface);

module.exports = {
  interface,
  bytecode,
};
