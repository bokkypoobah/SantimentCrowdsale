#!/bin/sh

geth attach << EOF | grep "RESULT: " | sed "s/RESULT: //"

var address = "0xda2cf810c5718135247628689d84f94c61b41d6a";
var startBlock = 3973420;
var endBlock = eth.blockNumber;
var step = 1;

console.log("RESULT: Block\tBalance");
for (var i = startBlock; i <= endBlock; i = parseInt(i) + step) {
    console.log("RESULT: " + i + "\t" + web3.fromWei(eth.getBalance(address, i), "ether"));
}

EOF