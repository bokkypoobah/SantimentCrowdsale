#!/bin/sh

geth attach << EOF | grep "RESULT: " | sed "s/RESULT: //"

loadScript("abi.js");

var cmAddress = "0xda2cf810c5718135247628689d84f94c61b41d6a";
var cm = eth.contract(cmAbi).at(cmAddress);
var tokenAddress = cm.TOKEN();
// console.log("RESULT: cm.TOKEN=" + tokenAddress);
var token = eth.contract(tokenAbi).at(tokenAddress);

// var investors = cm.investors();
var investorsCount = cm.investorsCount();

var tokenTotal = new BigNumber(0);
console.log("RESULT: No\tInvestor\tTokens\tTokenSubtotal");
for (var i = 0; i < investorsCount; i++) {
  var investor = cm.investors(i);
  var tokens = token.balanceOf(investor);
  tokenTotal = tokenTotal.add(tokens);
  console.log("RESULT: " + i + "\t" + investor + "\t" + tokens.shift(-18) + "\t" + tokenTotal.shift(-18));
}


exit;

var address = "0xda2cf810c5718135247628689d84f94c61b41d6a";
var startBlock = 3973420;
var endBlock = eth.blockNumber;
var step = 1;

console.log("RESULT: Block\tBalance");
for (var i = startBlock; i <= endBlock; i = parseInt(i) + step) {
    console.log("RESULT: " + i + "\t" + web3.fromWei(eth.getBalance(address, i), "ether"));
}

EOF