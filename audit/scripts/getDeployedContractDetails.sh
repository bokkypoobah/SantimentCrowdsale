#!/bin/sh

geth attach << EOF | grep "RESULT: " | sed "s/RESULT: //"

loadScript("abi.js");

var cmAddress = "0xda2cf810c5718135247628689d84f94c61b41d6a";

var cm = eth.contract(cmAbi).at(cmAddress);
var tokenAddress = cm.TOKEN();
console.log("RESULT: cm.TOKEN=" + tokenAddress);
var token = eth.contract(tokenAbi).at(tokenAddress);
var smAddress = token.SUBSCRIPTION_MODULE();
var sm = eth.contract(smAbi).at(smAddress);

console.log("RESULT: eth.blockNumber=" + eth.blockNumber);
console.log("RESULT: cm.owner=" + cm.owner());
console.log("RESULT: cm.newOwner=" + cm.newOwner());
console.log("RESULT: cm.VERSION=" + cm.VERSION());
console.log("RESULT: cm.COMMUNITY_SALE_START=" + cm.COMMUNITY_SALE_START());
console.log("RESULT: cm.PRIORITY_SALE_START=" + cm.PRIORITY_SALE_START());
console.log("RESULT: cm.PUBLIC_SALE_START=" + cm.PUBLIC_SALE_START());
console.log("RESULT: cm.PUBLIC_SALE_END=" + cm.PUBLIC_SALE_END());
console.log("RESULT: cm.WITHDRAWAL_END=" + cm.WITHDRAWAL_END());
console.log("RESULT: cm.TEAM_GROUP_WALLET=" + cm.TEAM_GROUP_WALLET());
console.log("RESULT: cm.ADVISERS_AND_FRIENDS_WALLET=" + cm.ADVISERS_AND_FRIENDS_WALLET());
console.log("RESULT: cm.TEAM_BONUS_PER_CENT=" + cm.TEAM_BONUS_PER_CENT());
console.log("RESULT: cm.ADVISORS_AND_PARTNERS_PER_CENT=" + cm.ADVISORS_AND_PARTNERS_PER_CENT());
console.log("RESULT: cm.TOKEN=" + cm.TOKEN());
console.log("RESULT: cm.PRIORITY_ADDRESS_LIST=" + cm.PRIORITY_ADDRESS_LIST());
console.log("RESULT: cm.COMMUNITY_ALLOWANCE_LIST=" + cm.COMMUNITY_ALLOWANCE_LIST());
console.log("RESULT: cm.PRESALE_BALANCES=" + cm.PRESALE_BALANCES());
console.log("RESULT: cm.PRESALE_BONUS_VOTING=" + cm.PRESALE_BONUS_VOTING());
console.log("RESULT: cm.COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH=" + cm.COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH());
console.log("RESULT: cm.MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH=" + cm.MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH());
console.log("RESULT: cm.MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH=" + cm.MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH());
console.log("RESULT: cm.MIN_ACCEPTED_AMOUNT_FINNEY=" + cm.MIN_ACCEPTED_AMOUNT_FINNEY());
console.log("RESULT: cm.TOKEN_PER_ETH=" + cm.TOKEN_PER_ETH());
console.log("RESULT: cm.PRE_SALE_BONUS_PER_CENT=" + cm.PRE_SALE_BONUS_PER_CENT());
console.log("RESULT: cm.isAborted=" + cm.isAborted());
console.log("RESULT: cm.TOKEN_STARTED=" + cm.TOKEN_STARTED());
console.log("RESULT: cm.total_received_amount=" + cm.total_received_amount().shift(-18));
console.log("RESULT: cm.investorsCount=" + cm.investorsCount());
console.log("RESULT: cm.TOTAL_RECEIVED_ETH=" + cm.TOTAL_RECEIVED_ETH());
console.log("RESULT: cm.state=" + cm.state());

console.log("RESULT: token.owner=" + token.owner());
console.log("RESULT: token.newOwner=" + token.newOwner());
console.log("RESULT: token.symbol=" + token.symbol());
console.log("RESULT: token.name=" + token.name());
console.log("RESULT: token.decimals=" + token.decimals());

console.log("RESULT: sm.owner=" + sm.owner());
console.log("RESULT: sm.newOwner=" + sm.newOwner());

EOF
