sanAbi=[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newBeneficiary","type":"address"}],"name":"setBeneficiary","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"owner","type":"address"},{"name":"amount","type":"uint256"}],"name":"_mintFromDeposit","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"},{"name":"subId","type":"uint256"},{"name":"msg_sender","type":"address"}],"name":"_fulfillPayment","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"SUBSCRIPTION_MODULE","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"beneficiary","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"isStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"},{"name":"msg_sender","type":"address"}],"name":"_fulfillPreapprovedPayment","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalInCirculation","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"getRate","outputs":[{"name":"","type":"uint32"},{"name":"","type":"uint32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"max","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subModule","type":"address"}],"name":"attachSubscriptionModule","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"acceptOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"min","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"account","type":"address"}],"name":"mint","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalOnDeposit","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"owner","type":"address"},{"name":"amount","type":"uint256"}],"name":"_burnForDeposit","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"start","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"newOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PLATFORM_FEE_PER_10000","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"getCode","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newFee","type":"uint256"}],"name":"setPlatformFeePer10000","outputs":[],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_from","type":"address"},{"indexed":false,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"},{"indexed":false,"name":"_fee","type":"uint256"},{"indexed":false,"name":"caller","type":"address"},{"indexed":false,"name":"status","type":"uint8"},{"indexed":false,"name":"subId","type":"uint256"}],"name":"Payment","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]
bsAbi=[{"constant":false,"inputs":[{"name":"account","type":"address"}],"name":"balances","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"}]
alAbi=[{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"contains","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"}]
mmwlAbi=[{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"allowed","outputs":[{"name":"","type":"uint24"},{"name":"","type":"uint24"}],"payable":false,"type":"function"}]
pbvAbi=[{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"rawVotes","outputs":[{"name":"rawVote","type":"uint256"}],"payable":false,"type":"function"}]
sanAddress=0x90d8927407c79c4a28ee879b821c76fc9bcc2688
bsAddress=0x0e946b999033257976aa5cbe0e3530618ca1582d
alAddress=0xdf9f36fd5654d92e0844c78d2d2dd562404cd1ff
mmwlAddress=0xe6ada9beed6e24be4c0259383db61b52bfca85f3
pbvAddress=0xf4441f10804b35b13bad1e664e32237773276253
lastBlockNumber=2;
COMMUNITY_SALE_START=17;
PRIORITY_SALE_START=22;
PUBLIC_SALE_START=27;
PUBLIC_SALE_END=32;
WITHDRAWAL_END=37;
