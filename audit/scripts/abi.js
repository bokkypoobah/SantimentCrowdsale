var cmAbi=[{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"san_whitelist","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"cfi_whitelist","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"tokenAddr","type":"address"}],"name":"attachToToken","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"balances","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PRESALE_BALANCES","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"investorsCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"abort","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"mintAllBonuses","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"COMMUNITY_ALLOWANCE_LIST","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"investors","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOTAL_RECEIVED_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PUBLIC_SALE_END","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"refund","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ADVISERS_AND_FRIENDS_WALLET","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PRIORITY_SALE_START","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"withdrawFundsAndStartToken","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"max","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_STARTED","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"acceptOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"min","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOKEN","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MIN_ACCEPTED_AMOUNT_FINNEY","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"presaleTokenAmount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"COMMUNITY_SALE_START","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"WITHDRAWAL_END","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PUBLIC_SALE_START","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PRESALE_BONUS_VOTING","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PRE_SALE_BONUS_PER_CENT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOKEN_PER_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"total_received_amount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"state","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PRIORITY_ADDRESS_LIST","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"newOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TEAM_BONUS_PER_CENT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TEAM_GROUP_WALLET","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ADVISORS_AND_PARTNERS_PER_CENT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"isAborted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"VERSION","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenAddr","type":"address"}],"name":"TokenStarted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"}],"name":"OwnershipTransferred","type":"event"}];
var tokenAbi=[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newBeneficiary","type":"address"}],"name":"setBeneficiary","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"owner","type":"address"},{"name":"amount","type":"uint256"}],"name":"_mintFromDeposit","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"},{"name":"subId","type":"uint256"},{"name":"msg_sender","type":"address"}],"name":"_fulfillPayment","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"SUBSCRIPTION_MODULE","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"beneficiary","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"isStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"},{"name":"msg_sender","type":"address"}],"name":"_fulfillPreapprovedPayment","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalInCirculation","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"getRate","outputs":[{"name":"","type":"uint32"},{"name":"","type":"uint32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"max","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subModule","type":"address"}],"name":"attachSubscriptionModule","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"acceptOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"min","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"account","type":"address"}],"name":"mint","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalOnDeposit","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"owner","type":"address"},{"name":"amount","type":"uint256"}],"name":"_burnForDeposit","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"start","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"newOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"PLATFORM_FEE_PER_10000","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"getCode","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newFee","type":"uint256"}],"name":"setPlatformFeePer10000","outputs":[],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_from","type":"address"},{"indexed":false,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"},{"indexed":false,"name":"_fee","type":"uint256"},{"indexed":false,"name":"caller","type":"address"},{"indexed":false,"name":"status","type":"uint8"},{"indexed":false,"name":"subId","type":"uint256"}],"name":"Payment","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"}],"name":"OwnershipTransferred","type":"event"}];
var smAbi=[{"constant":false,"inputs":[{"name":"addr","type":"address"},{"name":"moreInfo","type":"bytes"}],"name":"disableServiceProvider","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"}],"name":"returnSubscriptionDesposit","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"}],"name":"cancelSubscription","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"subscriptions","outputs":[{"name":"transferFrom","type":"address"},{"name":"transferTo","type":"address"},{"name":"pricePerHour","type":"uint256"},{"name":"initialXrate_n","type":"uint32"},{"name":"initialXrate_d","type":"uint32"},{"name":"xrateProviderId","type":"uint16"},{"name":"paidUntil","type":"uint256"},{"name":"chargePeriod","type":"uint256"},{"name":"depositAmount","type":"uint256"},{"name":"startOn","type":"uint256"},{"name":"expireOn","type":"uint256"},{"name":"execCounter","type":"uint256"},{"name":"descriptor","type":"bytes"},{"name":"onHoldSince","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"subId","type":"uint256"}],"name":"subscriptionDetails","outputs":[{"name":"transferFrom","type":"address"},{"name":"transferTo","type":"address"},{"name":"pricePerHour","type":"uint256"},{"name":"initialXrate_n","type":"uint32"},{"name":"initialXrate_d","type":"uint32"},{"name":"xrateProviderId","type":"uint16"},{"name":"chargePeriod","type":"uint256"},{"name":"startOn","type":"uint256"},{"name":"descriptor","type":"bytes"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"},{"name":"_paymentData","type":"bytes"},{"name":"_from","type":"address"},{"name":"_to","type":"address"}],"name":"paymentFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"subOrOfferId","type":"uint256"}],"name":"state","outputs":[{"name":"state","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"token","type":"address"}],"name":"attachToken","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"subId","type":"uint256"}],"name":"subscriptionStatus","outputs":[{"name":"depositAmount","type":"uint256"},{"name":"expireOn","type":"uint256"},{"name":"execCounter","type":"uint256"},{"name":"paidUntil","type":"uint256"},{"name":"onHoldSince","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"registerXRateProvider","outputs":[{"name":"xrateProviderId","type":"uint16"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_pricePerHour","type":"uint256"},{"name":"_xrateProviderId","type":"uint16"},{"name":"_chargePeriod","type":"uint256"},{"name":"_expireOn","type":"uint256"},{"name":"_offerLimit","type":"uint256"},{"name":"_depositAmount","type":"uint256"},{"name":"_startOn","type":"uint256"},{"name":"_descriptor","type":"bytes"}],"name":"createSubscriptionOffer","outputs":[{"name":"subId","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_depositId","type":"uint256"}],"name":"claimDeposit","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"},{"name":"moreInfo","type":"bytes"}],"name":"enableServiceProvider","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"},{"name":"newDueDate","type":"uint256"}],"name":"postponeDueDate","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"max","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"offerId","type":"uint256"}],"name":"unholdSubscriptionOffer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"acceptOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"a","type":"uint256"},{"name":"b","type":"uint256"}],"name":"min","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"}],"name":"holdSubscription","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"subscriptionCounter","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"offerId","type":"uint256"}],"name":"holdSubscriptionOffer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_offerId","type":"uint256"},{"name":"_offerLimit","type":"uint256"}],"name":"updateSubscriptionOffer","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"offerId","type":"uint256"}],"name":"cancelSubscriptionOffer","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"deposits","outputs":[{"name":"value","type":"uint256"},{"name":"owner","type":"address"},{"name":"descriptor","type":"bytes"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_offerId","type":"uint256"},{"name":"_expireOn","type":"uint256"},{"name":"_startOn","type":"uint256"}],"name":"createSubscription","outputs":[{"name":"newSubId","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"}],"name":"claimSubscriptionDeposit","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"},{"name":"_paymentData","type":"bytes"},{"name":"_to","type":"address"}],"name":"paymentTo","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"subOrOfferId","type":"uint256"}],"name":"stateCode","outputs":[{"name":"stateCode","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"providerRegistry","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"san","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"newOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"},{"name":"gasReserve","type":"uint256"}],"name":"cancelSubscription","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"}],"name":"unholdSubscription","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"subId","type":"uint256"}],"name":"executeSubscription","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"xrateProviders","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"depositCounter","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"},{"name":"_descriptor","type":"bytes"}],"name":"createDeposit","outputs":[{"name":"depositId","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"VERSION","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getXRateProviderLength","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_from","type":"address"},{"indexed":false,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"},{"indexed":false,"name":"_fee","type":"uint256"},{"indexed":false,"name":"sender","type":"address"},{"indexed":false,"name":"status","type":"uint8"},{"indexed":false,"name":"subId","type":"uint256"}],"name":"Payment","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"moreInfo","type":"bytes"}],"name":"ServiceProviderEnabled","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"moreInfo","type":"bytes"}],"name":"ServiceProviderDisabled","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"customer","type":"address"},{"indexed":false,"name":"service","type":"address"},{"indexed":false,"name":"offerId","type":"uint256"},{"indexed":false,"name":"subId","type":"uint256"}],"name":"NewSubscription","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"depositId","type":"uint256"},{"indexed":false,"name":"value","type":"uint256"},{"indexed":false,"name":"sender","type":"address"}],"name":"NewDeposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"addr","type":"address"},{"indexed":false,"name":"xRateProviderId","type":"uint16"},{"indexed":false,"name":"sender","type":"address"}],"name":"NewXRateProvider","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"depositId","type":"uint256"},{"indexed":false,"name":"returnedTo","type":"address"}],"name":"DepositReturned","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"subId","type":"uint256"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"returnedTo","type":"address"},{"indexed":false,"name":"sender","type":"address"}],"name":"SubscriptionDepositReturned","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"offerId","type":"uint256"},{"indexed":false,"name":"onHold","type":"bool"},{"indexed":false,"name":"sender","type":"address"}],"name":"OfferOnHold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"offerId","type":"uint256"},{"indexed":false,"name":"sender","type":"address"}],"name":"OfferCanceled","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"offerId","type":"uint256"},{"indexed":false,"name":"onHold","type":"bool"},{"indexed":false,"name":"sender","type":"address"}],"name":"SubOnHold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"subId","type":"uint256"},{"indexed":false,"name":"sender","type":"address"}],"name":"SubCanceled","type":"event"}];