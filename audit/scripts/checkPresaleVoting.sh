#!/bin/sh

geth attach << EOF | grep "RESULT: " | sed "s/RESULT: //"

var psAddress = "0x4Fd997Ed7c10DbD04e95d3730cd77D79513076F2";
var psAbi = [{"constant":true,"inputs":[],"name":"MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"OWNER","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"withdrawFunds","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"balances","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"abort","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"refund","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MIN_ACCEPTED_AMOUNT_FINNEY","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"WITHDRAWAL_END","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"total_received_amount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"state","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PRESALE_START","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PRESALE_END","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"isAborted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"VERSION","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"}];
var pvAddress = "0x283a97Af867165169AECe0b2E963b9f0FC7E5b8c";
var pvAbi = [{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"rawVotes","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"setOwner","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"stakeWaived_Eth","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"stakeVoted_Eth","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"stakeRemainingToVote_Eth","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"voter","type":"address"}],"name":"votedPerCent","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"startBlockNr","type":"uint256"},{"name":"durationHrs","type":"uint256"}],"name":"startVoting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"VOTING_END_TIME","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"stakeConfirmed_Eth","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"state","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"votingEndsInHHMM","outputs":[{"name":"","type":"uint8"},{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"VOTING_START_BLOCKNR","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"votersLen","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"voters","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOTAL_BONUS_SUPPLY_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"VERSION","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"}];

var ps = eth.contract(psAbi).at(psAddress);
var pv = eth.contract(pvAbi).at(pvAddress);

var PRESALE_ADDRESSES = [ \
  "0xF55DFd2B02Cf3282680C94BD01E9Da044044E6A2", \
  "0x0D40B53828948b340673674Ae65Ee7f5D8488e33", \
  "0x0ea690d466d6bbd18F124E204EA486a4Bf934cbA", \
  "0x6d25B9f40b92CcF158250625A152574603465192", \
  "0x481Da0F1e89c206712BCeA4f7D6E60d7b42f6C6C", \
  "0x416EDa5D6Ed29CAc3e6D97C102d61BC578C5dB87", \
  "0xD78Ac6FFc90E084F5fD563563Cc9fD33eE303f18", \
  "0xe6714ab523acEcf9b85d880492A2AcDBe4184892", \
  "0x285A9cA5fE9ee854457016a7a5d3A3BB95538093", \
  "0x600ca6372f312B081205B2C3dA72517a603a15Cc", \
  "0x2b8d5C9209fBD500Fd817D960830AC6718b88112", \
  "0x4B15Dd23E5f9062e4FB3a9B7DECF653C0215e560", \
  "0xD67449e6AB23c1f46dea77d3f5E5D47Ff33Dc9a9", \
  "0xd0ADaD7ed81AfDa039969566Ceb8423E0ab14d90", \
  "0x245f27796a44d7E3D30654eD62850ff09EE85656", \
  "0x639D6eC2cef4d6f7130b40132B3B6F5b667e5105", \
  "0x5e9a69B8656914965d69d8da49c3709F0bF2B5Ef", \
  "0x0832c3B801319b62aB1D3535615d1fe9aFc3397A", \
  "0xf6Dd631279377205818C3a6725EeEFB9D0F6b9F3", \
  "0x47696054e71e4c3f899119601a255a7065C3087B", \
  "0xf107bE6c6833f61A24c64D63c8A7fcD784Abff06", \
  "0x056f072Bd2240315b708DBCbDDE80d400f0394a1", \
  "0x9e5BaeC244D8cCD49477037E28ed70584EeAD956", \
  "0x40A0b2c1B4E30F27e21DF94e734671856b485966", \
  "0x84f0620A547a4D14A7987770c4F5C25d488d6335", \
  "0x036Ac11c161C09d94cA39F7B24C1bC82046c332B", \
  "0x2912A18C902dE6f95321D6d6305D7B80Eec4C055", \
  "0xE1Ad30971b83c17E2A24c0334CB45f808AbEBc87", \
  "0x07f35b7FE735c49FD5051D5a0C2e74c9177fEa6d", \
  "0x11669Cce6AF3ce1Ef3777721fCC0eef0eE57Eaba", \
  "0xBDbaF6434d40D6355B1e80e40Cc4AB9C68D96116", \
  "0x17125b59ac51cEe029E4bD78D7f5947D1eA49BB2", \
  "0xA382A3A65c3F8ee2b726A2535B3c34A89D9094D4", \
  "0xAB78c8781fB64Bed37B274C5EE759eE33465f1f3", \
  "0xE74F2062612E3cAE8a93E24b2f0D3a2133373884", \
  "0x505120957A9806827F8F111A123561E82C40bC78", \
  "0x00A46922B1C54Ae6b5818C49B97E03EB4BB352e1", \
  "0xE76fE52a251C8F3a5dcD657E47A6C8D16Fdf4bFA" \
];

console.log(PRESALE_ADDRESSES.length);
console.log("RESULT: #\tPresaleAddresss\tPresale Balances\tPresale Balances Subtotal\tRaw Votes");
var total = new BigNumber(0);
for (var i=0; i<PRESALE_ADDRESSES.length; i++) {
  total = total.add(ps.balances(PRESALE_ADDRESSES[i]));
  console.log("RESULT: " + i + "\t" + PRESALE_ADDRESSES[i] + "\t" + web3.fromWei(ps.balances(PRESALE_ADDRESSES[i]), "ether") + "\t" + web3.fromWei(total, "ether") + "\t" + pv.rawVotes(PRESALE_ADDRESSES[i]));
}

EOF
