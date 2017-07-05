#!/bin/sh

geth attach << EOF | grep "RESULT: " | sed "s/RESULT: //"
// geth attach << EOF

loadScript("abi.js");

var cmAddress = "0xda2cf810c5718135247628689d84f94c61b41d6a";
var cm = eth.contract(cmAbi).at(cmAddress);
var tokenAddress = cm.TOKEN();
// console.log("RESULT: cm.TOKEN=" + tokenAddress);
var token = eth.contract(tokenAbi).at(tokenAddress);


var TEAM_GROUP_WALLET           = "0xA0D8F33Ef9B44DaAE522531DD5E7252962b09207";
var ADVISERS_AND_FRIENDS_WALLET = "0x44f145f6Bc36e51eED9b661e99C8b9CCF987c043";

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

var addresses = {};

var investorsCount = cm.investorsCount();
// console.log("investorsCount: " + investorsCount);
for (var i = 0; i < investorsCount; i++) {
  var investor = cm.investors(i);
  addresses[investor] = 1;
  // console.log(investor);
}

addresses[TEAM_GROUP_WALLET.toLowerCase()] = 1;
addresses[ADVISERS_AND_FRIENDS_WALLET.toLowerCase()] = 1;

for (var i = 0; i < PRESALE_ADDRESSES.length; i++) {
  addresses[PRESALE_ADDRESSES[i].toLowerCase()] = 1;
}

var addressArray = Object.keys(addresses);

var tokenTotal = new BigNumber(0);
console.log("RESULT: No\tInvestor\tTokens\tTokenSubtotal");
for (var i = 0; i < addressArray.length; i++) {
  var investor = addressArray[i];
  var tokens = token.balanceOf(investor);
  if (tokens > 0) {
    tokenTotal = tokenTotal.add(tokens);
    console.log("RESULT: " + i + "\t" + investor + "\t" + tokens.shift(-18) + "\t" + tokenTotal.shift(-18));
  }
}

EOF