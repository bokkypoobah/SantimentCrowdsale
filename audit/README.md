# Santiment's Crowdsale Contract Audit

Preliminary work has been done on Santiment's crowdsale contracts during the development phase - see [README-old.md](README-old.md).

This is the audit of the contract deployed for live use. The primary aim of this audit is to reduce the risk of the loss of funds.

Contract addresses:

* CrowdsaleMinter - [0xda2cf810c5718135247628689d84f94c61b41d6a](https://etherscan.io/address/0xda2cf810c5718135247628689d84f94c61b41d6a)
* SAN Token - [0x7221816f73e710eb952ce08bcaf54a31600fae6c](https://etherscan.io/address/0x7221816f73e710eb952ce08bcaf54a31600fae6c)
* Subscription Module - [0x29f0b7c3d8ee8f6471922f089f459cab53029113](https://etherscan.io/address/0x29f0b7c3d8ee8f6471922f089f459cab53029113)

<br />

<hr />

## Table Of Contents
* [Summary](#summary)
* [Source Code Overview](#source-code-overview)
* [CrowdsaleMinter](#crowdsaleminter)
* [SAN Token Contract](#san-token-contract)
* [Subscription Module](#subscription-module)
* [SantimentWhiteList](#santimentwhitelist)

<br />

<hr />

## Summary

No severe security issues have been found that will enable an attacker to drain ethers from this contract.

<br />

<hr />

## Source Code Overview

This review is primarily aimed to reduce the risk of the loss of the funds. Some corrected bugs and minor issues have already been covered in [README-old.md](README-old.md).

Issues:

* \#1 Note that `CrowdsaleMinter.()` calls `var (min_finney, max_finney) = COMMUNITY_ALLOWANCE_LIST.allowed(msg.sender);` and there is a slight possibility of a type mismatch, but testing seems to have confirmed the correct workings.

  The interface for MinMaxWhiteList has the return signature of `function allowed(address addr) public constant returns (uint /*finney*/, uint /*finney*/ );` while
  the deployed SantimentWhiteList has the allowed structure consisting of `struct LimitWithAddr { address addr; uint24 min; /* finney */ uint24 max; /* finney */ }` (comments converted).

<br />

<hr />

## CrowdsaleMinter

The CrowdsaleMinter contract is deployed at [0xda2cf810c5718135247628689d84f94c61b41d6a](https://etherscan.io/address/0xda2cf810c5718135247628689d84f94c61b41d6a#code).

The deployed contract has the following parameters

    cm.TOKEN=0x7221816f73e710eb952ce08bcaf54a31600fae6c
    eth.blockNumber=3972796
    cm.owner=0x6dd5a9f47cfbc44c04a0a4452f0ba792ebfbcc9a
    cm.newOwner=0x6dd5a9f47cfbc44c04a0a4452f0ba792ebfbcc9a
    cm.VERSION=0.2.1
    cm.COMMUNITY_SALE_START=3973420
    cm.PRIORITY_SALE_START=3978496
    cm.PUBLIC_SALE_START=3983578
    cm.PUBLIC_SALE_END=4130967
    cm.WITHDRAWAL_END=4288520
    cm.TEAM_GROUP_WALLET=0xa0d8f33ef9b44daae522531dd5e7252962b09207
    cm.ADVISERS_AND_FRIENDS_WALLET=0x44f145f6bc36e51eed9b661e99c8b9ccf987c043
    cm.TEAM_BONUS_PER_CENT=18
    cm.ADVISORS_AND_PARTNERS_PER_CENT=10
    cm.TOKEN=0x7221816f73e710eb952ce08bcaf54a31600fae6c
    cm.PRIORITY_ADDRESS_LIST=0x9411cf70f97c2ed09325e58629d48401aed50f89
    cm.COMMUNITY_ALLOWANCE_LIST=0xd2675d3ea478692ad34f09fa1f8bda67a9696bf7
    cm.PRESALE_BALANCES=0x4fd997ed7c10dbd04e95d3730cd77d79513076f2
    cm.PRESALE_BONUS_VOTING=0x283a97af867165169aece0b2e963b9f0fc7e5b8c
    cm.COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH=45000
    cm.MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH=15000
    cm.MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH=45000
    cm.MIN_ACCEPTED_AMOUNT_FINNEY=200
    cm.TOKEN_PER_ETH=1000
    cm.PRE_SALE_BONUS_PER_CENT=54
    cm.isAborted=false
    cm.TOKEN_STARTED=false
    cm.total_received_amount=0
    cm.investorsCount=0
    cm.TOTAL_RECEIVED_ETH=0
    cm.state=BEFORE_START
    token.owner=0x008cdc9b89ad677cef7f2c055efc97d3606a50bd
    token.newOwner=0x0000000000000000000000000000000000000000
    token.symbol=SAN
    token.name=SANtiment network token
    token.decimals=18
    sm.owner=0x008cdc9b89ad677cef7f2c055efc97d3606a50bd
    sm.newOwner=0x0000000000000000000000000000000000000000

<br />

The deployed contract has the following code, with v0.4.11+commit.68ef5810 and optimised:

```javascript
// BK Ok
pragma solidity ^0.4.11;

// ==== DISCLAIMER ====
//
// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
//
// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ====
//

/// @author ethernian for Santiment LLC
/// @title  CrowdsaleMinter

// BK Ok
contract Base {

    // BK Ok - Could be internal marked constant
    function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
    // BK Ok - Could be marked internal constant
    function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }

    // BK Ok - Throw if calling account is not the specified one 
    modifier only(address allowed) {
        if (msg.sender != allowed) throw;
        _;
    }

    ///@return True if `_addr` is a contract
    // BK Ok
    function isContract(address _addr) constant internal returns (bool) {
        if (_addr == 0) return false;
        uint size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    // *************************************************
    // *          reentrancy handling                  *
    // *************************************************

    //@dev predefined locks (up to uint bit length, i.e. 256 possible)
    // BK Next 6 Ok
    uint constant internal L00 = 2 ** 0;
    uint constant internal L01 = 2 ** 1;
    uint constant internal L02 = 2 ** 2;
    uint constant internal L03 = 2 ** 3;
    uint constant internal L04 = 2 ** 4;
    uint constant internal L05 = 2 ** 5;

    //prevents reentrancy attacs: specific locks
    // BK Ok
    uint private bitlocks = 0;
    // BK Ok
    modifier noReentrancy(uint m) {
        var _locks = bitlocks;
        if (_locks & m > 0) throw;
        bitlocks |= m;
        _;
        bitlocks = _locks;
    }

    // BK Ok
    modifier noAnyReentrancy {
        var _locks = bitlocks;
        if (_locks > 0) throw;
        bitlocks = uint(-1);
        _;
        bitlocks = _locks;
    }

    ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
    ///     developer should make the caller function reentrant-safe if it use a reentrant function.
    // BK Ok
    modifier reentrant { _; }

}

// BK Ok
contract MintableToken {
    //target token contract is responsible to accept only authorized mint calls.
    function mint(uint amount, address account);

    //start the token on minting finished,
    // BK Ok - This is called to start the tokens. If this call fails, the funds from CrowdsaleMinter will be released anyway and
    //         a new token contract can be redeployed
    function start();
}

// BK Ok
contract Owned is Base {

    // BK Next 2 Ok
    address public owner;
    address public newOwner;

    // BK Ok
    function Owned() {
        owner = msg.sender;
    }

    // BK Ok
    function transferOwnership(address _newOwner) only(owner) {
        newOwner = _newOwner;
    }

    // BK Ok - Only newOwner
    function acceptOwnership() only(newOwner) {
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // BK Ok
    event OwnershipTransferred(address indexed _from, address indexed _to);

}

// BK Ok - Matches PreSale at https://etherscan.io/address/0x4Fd997Ed7c10DbD04e95d3730cd77D79513076F2#code
contract BalanceStorage {
    function balances(address account) public constant returns(uint balance);
}

// BK Ok - Matches https://etherscan.io/address/0x9411Cf70F97C2ED09325e58629D48401aEd50F89#code
contract AddressList {
    function contains(address addr) public constant returns (bool);
}

// BK NOTE - See #1 above re mismatch in type - uint24 -> uint
contract MinMaxWhiteList {
    function allowed(address addr) public constant returns (uint /*finney*/, uint /*finney*/ );
}

// BK Ok - Matches https://etherscan.io/address/0x283a97Af867165169AECe0b2E963b9f0FC7E5b8c#code
contract PresaleBonusVoting {
    function rawVotes(address addr) public constant returns (uint rawVote);
}

contract CrowdsaleMinter is Owned {

    // BK Ok
    string public constant VERSION = "0.2.1";

    /* ====== configuration START ====== */
    // BK Next 5 Ok
    uint public constant COMMUNITY_SALE_START = 3973420; /* approx. 04.07.2017 16:00 GMT+1 */
    uint public constant PRIORITY_SALE_START  = 3978496; /* approx. 05.07.2017 16:00 GMT+1 */
    uint public constant PUBLIC_SALE_START    = 3983578; /* approx. 06.07.2017 16:00 GMT+1 */
    uint public constant PUBLIC_SALE_END      = 4130967; /* approx. 04.08.2017 16:00 GMT+1 */
    uint public constant WITHDRAWAL_END       = 4288520; /* approx. 04.09.2017 16:00 GMT+1 */
    
    // BK Next 2 Ok
    address public TEAM_GROUP_WALLET           = 0xA0D8F33Ef9B44DaAE522531DD5E7252962b09207;
    address public ADVISERS_AND_FRIENDS_WALLET = 0x44f145f6Bc36e51eED9b661e99C8b9CCF987c043;

    // BK Next 2 Ok
    uint public constant TEAM_BONUS_PER_CENT            = 18;
    uint public constant ADVISORS_AND_PARTNERS_PER_CENT = 10;

    // BK Ok
    MintableToken      public TOKEN                    = MintableToken(0x00000000000000000000000000);

    // BK Next 4 Ok
    AddressList        public PRIORITY_ADDRESS_LIST    = AddressList(0x9411Cf70F97C2ED09325e58629D48401aEd50F89);
    MinMaxWhiteList    public COMMUNITY_ALLOWANCE_LIST = MinMaxWhiteList(0xd2675d3ea478692ad34f09fa1f8bda67a9696bf7);
    BalanceStorage     public PRESALE_BALANCES         = BalanceStorage(0x4Fd997Ed7c10DbD04e95d3730cd77D79513076F2);
    PresaleBonusVoting public PRESALE_BONUS_VOTING     = PresaleBonusVoting(0x283a97Af867165169AECe0b2E963b9f0FC7E5b8c);

    // BK Next 6 Ok
    uint public constant COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH = 45000;
    uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 15000;
    uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 45000;
    uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 200;
    uint public constant TOKEN_PER_ETH = 1000;
    uint public constant PRE_SALE_BONUS_PER_CENT = 54;

    //constructor
    // BK Ok
    function CrowdsaleMinter() {
        //check configuration if something in setup is looking weird
        if (
            TOKEN_PER_ETH == 0
            || TEAM_BONUS_PER_CENT + ADVISORS_AND_PARTNERS_PER_CENT >=100
            || MIN_ACCEPTED_AMOUNT_FINNEY < 1
            || owner == 0x0
            || address(COMMUNITY_ALLOWANCE_LIST) == 0x0
            || address(PRIORITY_ADDRESS_LIST) == 0x0
            || address(PRESALE_BONUS_VOTING) == 0x0
            || address(PRESALE_BALANCES) == 0x0
            || COMMUNITY_SALE_START == 0
            || PRIORITY_SALE_START == 0
            || PUBLIC_SALE_START == 0
            || PUBLIC_SALE_END == 0
            || WITHDRAWAL_END == 0
            || MIN_TOTAL_AMOUNT_TO_RECEIVE == 0
            || MAX_TOTAL_AMOUNT_TO_RECEIVE == 0
            || COMMUNITY_PLUS_PRIORITY_SALE_CAP == 0
            || COMMUNITY_SALE_START <= block.number
            || COMMUNITY_SALE_START >= PRIORITY_SALE_START
            || PRIORITY_SALE_START >= PUBLIC_SALE_START
            || PUBLIC_SALE_START >= PUBLIC_SALE_END
            || PUBLIC_SALE_END >= WITHDRAWAL_END
            || COMMUNITY_PLUS_PRIORITY_SALE_CAP > MAX_TOTAL_AMOUNT_TO_RECEIVE
            || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
        throw;
    }

    /* ====== configuration END ====== */

    /* ====== public states START====== */

    // BK Next 5 Ok
    bool public isAborted = false;
    mapping (address => uint) public balances;
    bool public TOKEN_STARTED = false;
    uint public total_received_amount;
    address[] public investors;

    //displays number of uniq investors
    // BK Ok
    function investorsCount() constant external returns(uint) { return investors.length; }

    //displays received amount in eth upto now
    // BK Ok
    function TOTAL_RECEIVED_ETH() constant external returns (uint) { return total_received_amount / 1 ether; }

    //displays current contract state in human readable form
    // BK Ok
    function state() constant external returns (string) { return stateNames[ uint(currentState()) ]; }

    // BK Next 2 Ok
    function san_whitelist(address addr) public constant returns(uint, uint) { return COMMUNITY_ALLOWANCE_LIST.allowed(addr); }
    function cfi_whitelist(address addr) public constant returns(bool) { return PRIORITY_ADDRESS_LIST.contains(addr); }

    /* ====== public states END ====== */

    // BK Next 2 Ok
    string[] private stateNames = ["BEFORE_START", "COMMUNITY_SALE", "PRIORITY_SALE", "PRIORITY_SALE_FINISHED", "PUBLIC_SALE", "BONUS_MINTING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
    enum State { BEFORE_START, COMMUNITY_SALE, PRIORITY_SALE, PRIORITY_SALE_FINISHED, PUBLIC_SALE, BONUS_MINTING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }

    // BK Next 5 Ok
    uint private constant COMMUNITY_PLUS_PRIORITY_SALE_CAP = COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH * 1 ether;
    uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
    uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
    uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
    bool private allBonusesAreMinted = false;

    //
    // ======= interface methods =======
    //

    //accept payments here
    function ()
    // BK Ok - Accept funds
    payable
    // BK Ok
    noAnyReentrancy
    {
        // BK Ok
        State state = currentState();
        uint amount_allowed;
        if (state == State.COMMUNITY_SALE) {
            // BK Ok - see #1 re type conversion
            var (min_finney, max_finney) = COMMUNITY_ALLOWANCE_LIST.allowed(msg.sender);
            // BK Ok
            var (min, max) = (min_finney * 1 finney, max_finney * 1 finney);
            // BK Ok - Current balance
            var sender_balance = balances[msg.sender];
            // BK Ok - Check below max
            assert (sender_balance <= max); //sanity check: should be always true;
            // BK Ok - Check above min
            assert (msg.value >= min);      //reject payments less than minimum
            // BK Ok - Check amount remaining that can be contributed
            amount_allowed = max - sender_balance;
            // BK Ok - Receive funds and mint tokens
            _receiveFundsUpTo(amount_allowed);
        } else if (state == State.PRIORITY_SALE) {
            assert (PRIORITY_ADDRESS_LIST.contains(msg.sender));
            amount_allowed = COMMUNITY_PLUS_PRIORITY_SALE_CAP - total_received_amount;
            _receiveFundsUpTo(amount_allowed);
        } else if (state == State.PUBLIC_SALE) {
            amount_allowed = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
            _receiveFundsUpTo(amount_allowed);
        } else if (state == State.REFUND_RUNNING) {
            // any entring call in Refund Phase will cause full refund
            // BK NOTE - Anyone can call this
            //         - _sendRefund() will restrict to accounts with non-zero balances only
            _sendRefund();
        } else {
            throw;
        }
    }


    function refund() external
    inState(State.REFUND_RUNNING)
    noAnyReentrancy
    // BK NOTE - Anyone can call this
    //         - _sendRefund() will restrict to accounts with non-zero balances only
    {
        _sendRefund();
    }


    function withdrawFundsAndStartToken() external
    inState(State.WITHDRAWAL_RUNNING)
    // BK Ok - This function can only be called after anyone calls mintAllBonuses()
    noAnyReentrancy
    // BK Ok - Only the owner can execute this
    only(owner)
    // BK Ok - In the worst case, the funds will be transferred. The TOKEN.call(...) may fail and there may be no way to detect the
    //         issue, but a new token contract can be redeployed with the correct details
    //       - There was an issue in the testing where the ownership of the SAN token contract is not set to this CrowdsaleMinter
    //         contract. Funds were transferred, but the SAN token contract was not `start()`-ed . In this case, the owner was
    //         an account that could manually start the token contract operations
    {
        // transfer funds to owner
        if (!owner.send(this.balance)) throw;

        //notify token contract to start
        if (TOKEN.call(bytes4(sha3("start()")))) {
            TOKEN_STARTED = true;
            TokenStarted(TOKEN);
        }
    }

    event TokenStarted(address tokenAddr);

    //there are around 40 addresses in PRESALE_ADDRESSES list. Everything fits into single Tx.
    function mintAllBonuses() external
    inState(State.BONUS_MINTING)
    noAnyReentrancy
    // BK NOTE - Anyone can call this
    {
        assert(!allBonusesAreMinted);
        allBonusesAreMinted = true;

        uint TEAM_AND_PARTNERS_PER_CENT = TEAM_BONUS_PER_CENT + ADVISORS_AND_PARTNERS_PER_CENT;

        uint total_presale_amount_with_bonus = mintPresaleBonuses();
        uint total_collected_amount = total_received_amount + total_presale_amount_with_bonus;
        uint extra_amount = total_collected_amount * TEAM_AND_PARTNERS_PER_CENT / (100 - TEAM_AND_PARTNERS_PER_CENT);
        uint extra_team_amount = extra_amount * TEAM_BONUS_PER_CENT / TEAM_AND_PARTNERS_PER_CENT;
        uint extra_partners_amount = extra_amount * ADVISORS_AND_PARTNERS_PER_CENT / TEAM_AND_PARTNERS_PER_CENT;
 
        //beautify total supply: round down to full eth.
        uint total_to_mint = total_collected_amount + extra_amount;
        uint round_remainder = total_to_mint - (total_to_mint / 1 ether * 1 ether);
        extra_team_amount -= round_remainder; //this will reduce total_supply to rounded value

        //mint group bonuses
        _mint(extra_team_amount , TEAM_GROUP_WALLET);
        _mint(extra_partners_amount, ADVISERS_AND_FRIENDS_WALLET);

    }

    // BK NOTE - Anyone can call this via mintAllBonuses()
    function mintPresaleBonuses() internal returns(uint amount) {
        uint total_presale_amount_with_bonus = 0;
        //mint presale bonuses
        for(uint i=0; i < PRESALE_ADDRESSES.length; ++i) {
            address addr = PRESALE_ADDRESSES[i];
            var amount_with_bonus = presaleTokenAmount(addr);
            if (amount_with_bonus>0) {
                _mint(amount_with_bonus, addr);
                total_presale_amount_with_bonus += amount_with_bonus;
            }
        }//for
        return total_presale_amount_with_bonus;
    }

    // BK NOTE - Anyone can call this via mintPresaleBonuses() which is called by mintAllBonuses()
    //         - Anyone can call this directly as well
    //         - Constant function anyway
    function presaleTokenAmount(address addr) public constant returns(uint){
        uint presale_balance = PRESALE_BALANCES.balances(addr);
        if (presale_balance > 0) {
            // this calculation is about waived pre-sale bonus.
            // rawVote contains a value [0..1 ether].
            //     0 ether    - means "default value" or "no vote" : 100% bonus saved
            //     1 ether    - means "vote 100%" : 100% bonus saved
            //    <=10 finney - special value "vote 0%" : no bonus at all (100% bonus waived).
            //  other value - "PRE_SALE_BONUS_PER_CENT * rawVote / 1 ether" is an effective bonus per cent for particular presale member.
            //
            var rawVote = PRESALE_BONUS_VOTING.rawVotes(addr);
            if (rawVote == 0)              rawVote = 1 ether; //special case "no vote" (default value) ==> (1 ether is 100%)
            else if (rawVote <= 10 finney) rawVote = 0;       //special case "0%" (no bonus)           ==> (0 ether is   0%)
            else if (rawVote > 1 ether)    rawVote = 1 ether; //max bonus is 100% (should not occur)
            var presale_bonus = presale_balance * PRE_SALE_BONUS_PER_CENT * rawVote / 1 ether / 100;
            return presale_balance + presale_bonus;
        } else {
            return 0;
        }
    }

    function attachToToken(MintableToken tokenAddr) external
    inState(State.BEFORE_START)
    only(owner)
    // BK NOTE - Only owner can attach token to this contract, BEFORE_START
    {
        TOKEN = tokenAddr;
    }

    function abort() external
    inStateBefore(State.REFUND_RUNNING)
    only(owner)
    // BK NOTE - Only owner can abort
    //         - Can only be called before the state is CLOSED
    {
        isAborted = true;
    }

    //
    // ======= implementation methods =======
    //

    function _sendRefund() private
    // BK NOTE - This function can be called from the default function () (has a payable modifier)
    //         - This function can also be called from refund() (does not have a payable modifier)
    //         - Only accounts with non-zero balances can call this 
    tokenHoldersOnly
    {
        // load balance to refund plus amount currently sent
        // BK Ok - Also returning amounts accidentally sent, but no payable modifier anyway
        var amount_to_refund = balances[msg.sender] + msg.value;
        // reset balance
        // BK Ok
        balances[msg.sender] = 0;
        // send refund back to sender
        // BK NOTE - Last statement so logic cannot be hijacked with consequence
        //         - Low gas passed via send() so any potential contract account cannot execute many operations
        //         - balances for sender is zeroed previously, so recursion attack not possible
        if (!msg.sender.send(amount_to_refund)) throw;
    }

    function _receiveFundsUpTo(uint amount) private
    // BK Ok - Check for minimum contribution amount 
    notTooSmallAmountOnly
    // BK Ok
    {
        // BK Ok - Must be > 0 
        require (amount > 0);
        if (msg.value > amount) {
            // accept amount only and return change
            // BK Ok - Cannot underflow to create a big value to refund
            var change_to_return = msg.value - amount;
            // BK NOTE - Not the last statement - logic can be hijacked 
            //         - But only low gas passed via send() so any potential contract account cannot execute many operations
            //         - And the value returned will be smaller than the amount sent
            if (!msg.sender.send(change_to_return)) throw;
        } else {
            // accept full amount
            // BK Ok - Below full amount
            amount = msg.value;
        }
        // BK Ok - Keeping track of investors
        if (balances[msg.sender] == 0) investors.push(msg.sender);
        // BK Ok - Keeping track of investors balance
        //       - Cannot overflow as this amount is restricted by the value of ETH sent
        balances[msg.sender] += amount;
        // BK Ok - Keep track of total received amount
        //       - Cannot overflow as this amount is restricted by the value of ETH sent
        total_received_amount += amount;
        // BK Ok - Mint the tokens
        _mint(amount,msg.sender);
    }

    // BK Ok
    function _mint(uint amount, address account) private {
        MintableToken(TOKEN).mint(amount * TOKEN_PER_ETH, account);
    }

    function currentState() private constant
    returns (State)
    {
        if (isAborted) {
            return this.balance > 0
                   ? State.REFUND_RUNNING
                   : State.CLOSED;
        } else if (block.number < COMMUNITY_SALE_START || address(TOKEN) == 0x0) {
             return State.BEFORE_START;
        } else if (block.number < PRIORITY_SALE_START) {
            return State.COMMUNITY_SALE;
        } else if (block.number < PUBLIC_SALE_START) {
            return total_received_amount < COMMUNITY_PLUS_PRIORITY_SALE_CAP
                ? State.PRIORITY_SALE
                : State.PRIORITY_SALE_FINISHED;
        } else if (block.number <= PUBLIC_SALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
            return State.PUBLIC_SALE;
        } else if (this.balance == 0) {
            return State.CLOSED;
        } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
            return allBonusesAreMinted
                ? State.WITHDRAWAL_RUNNING
                : State.BONUS_MINTING;
        } else {
            return State.REFUND_RUNNING;
        }
    }

    //
    // ============ modifiers ============
    //

    //fails if state dosn't match
    // BK Ok
    modifier inState(State state) {
        if (state != currentState()) throw;
        _;
    }

    //fails if the current state is not before than the given one.
    // BK Ok. Note >=
    modifier inStateBefore(State state) {
        if (currentState() >= state) throw;
        _;
    }

    //accepts calls from token holders only
    // BK Ok
    modifier tokenHoldersOnly(){
        if (balances[msg.sender] == 0) throw;
        _;
    }


    // don`t accept transactions with value less than allowed minimum
    // BK Ok
    modifier notTooSmallAmountOnly(){
        if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
        _;
    }

    //
    // ============ DATA ============
    //

    address[] PRESALE_ADDRESSES = [
        0xF55DFd2B02Cf3282680C94BD01E9Da044044E6A2,
        0x0D40B53828948b340673674Ae65Ee7f5D8488e33,
        0x0ea690d466d6bbd18F124E204EA486a4Bf934cbA,
        0x6d25B9f40b92CcF158250625A152574603465192,
        0x481Da0F1e89c206712BCeA4f7D6E60d7b42f6C6C,
        0x416EDa5D6Ed29CAc3e6D97C102d61BC578C5dB87,
        0xD78Ac6FFc90E084F5fD563563Cc9fD33eE303f18,
        0xe6714ab523acEcf9b85d880492A2AcDBe4184892,
        0x285A9cA5fE9ee854457016a7a5d3A3BB95538093,
        0x600ca6372f312B081205B2C3dA72517a603a15Cc,
        0x2b8d5C9209fBD500Fd817D960830AC6718b88112,
        0x4B15Dd23E5f9062e4FB3a9B7DECF653C0215e560,
        0xD67449e6AB23c1f46dea77d3f5E5D47Ff33Dc9a9,
        0xd0ADaD7ed81AfDa039969566Ceb8423E0ab14d90,
        0x245f27796a44d7E3D30654eD62850ff09EE85656,
        0x639D6eC2cef4d6f7130b40132B3B6F5b667e5105,
        0x5e9a69B8656914965d69d8da49c3709F0bF2B5Ef,
        0x0832c3B801319b62aB1D3535615d1fe9aFc3397A,
        0xf6Dd631279377205818C3a6725EeEFB9D0F6b9F3,
        0x47696054e71e4c3f899119601a255a7065C3087B,
        0xf107bE6c6833f61A24c64D63c8A7fcD784Abff06,
        0x056f072Bd2240315b708DBCbDDE80d400f0394a1,
        0x9e5BaeC244D8cCD49477037E28ed70584EeAD956,
        0x40A0b2c1B4E30F27e21DF94e734671856b485966,
        0x84f0620A547a4D14A7987770c4F5C25d488d6335,
        0x036Ac11c161C09d94cA39F7B24C1bC82046c332B,
        0x2912A18C902dE6f95321D6d6305D7B80Eec4C055,
        0xE1Ad30971b83c17E2A24c0334CB45f808AbEBc87,
        0x07f35b7FE735c49FD5051D5a0C2e74c9177fEa6d,
        0x11669Cce6AF3ce1Ef3777721fCC0eef0eE57Eaba,
        0xBDbaF6434d40D6355B1e80e40Cc4AB9C68D96116,
        0x17125b59ac51cEe029E4bD78D7f5947D1eA49BB2,
        0xA382A3A65c3F8ee2b726A2535B3c34A89D9094D4,
        0xAB78c8781fB64Bed37B274C5EE759eE33465f1f3,
        0xE74F2062612E3cAE8a93E24b2f0D3a2133373884,
        0x505120957A9806827F8F111A123561E82C40bC78,
        0x00A46922B1C54Ae6b5818C49B97E03EB4BB352e1,
        0xE76fE52a251C8F3a5dcD657E47A6C8D16Fdf4bFA
    ];

}// CrowdsaleMinter
```

<br />

<hr />

## SAN Token Contract

From the `TOKEN` field of the CrowdsaleMinter contract, the SAN token contract is deployed at [0x7221816f73e710eb952ce08bcaf54a31600fae6c](https://etherscan.io/address/0x7221816f73e710eb952ce08bcaf54a31600fae6c#code) with the following code, with v0.4.11+commit.68ef5810 and optimised:

```javascript
pragma solidity ^0.4.11;

// ==== DISCLAIMER ====
//
// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
//
// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ====
//

/// @author Santiment LLC
/// @title  SAN - santiment token

// BK Ok - See CrowdsaleMinter::Base
contract Base {

    function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
    function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }

    modifier only(address allowed) {
        if (msg.sender != allowed) throw;
        _;
    }


    ///@return True if `_addr` is a contract
    function isContract(address _addr) constant internal returns (bool) {
        if (_addr == 0) return false;
        uint size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    // *************************************************
    // *          reentrancy handling                  *
    // *************************************************

    //@dev predefined locks (up to uint bit length, i.e. 256 possible)
    uint constant internal L00 = 2 ** 0;
    uint constant internal L01 = 2 ** 1;
    uint constant internal L02 = 2 ** 2;
    uint constant internal L03 = 2 ** 3;
    uint constant internal L04 = 2 ** 4;
    uint constant internal L05 = 2 ** 5;

    //prevents reentrancy attacs: specific locks
    uint private bitlocks = 0;
    modifier noReentrancy(uint m) {
        var _locks = bitlocks;
        if (_locks & m > 0) throw;
        bitlocks |= m;
        _;
        bitlocks = _locks;
    }

    modifier noAnyReentrancy {
        var _locks = bitlocks;
        if (_locks > 0) throw;
        bitlocks = uint(-1);
        _;
        bitlocks = _locks;
    }

    ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
    ///     developer should make the caller function reentrant-safe if it use a reentrant function.
    modifier reentrant { _; }

}

// BK Ok - See CrowdsaleMinter::Owned
contract Owned is Base {

    address public owner;
    address public newOwner;

    function Owned() {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) only(owner) {
        newOwner = _newOwner;
    }

    function acceptOwnership() only(newOwner) {
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    event OwnershipTransferred(address indexed _from, address indexed _to);

}


contract ERC20 is Owned {

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {
        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    uint256 public totalSupply;
    bool    public isStarted = false;

    modifier onlyHolder(address holder) {
        if (balanceOf(holder) == 0) throw;
        _;
    }

    modifier isStartedOnly() {
        if (!isStarted) throw;
        _;
    }

}


contract SubscriptionModule {
    function attachToken(address addr) public ;
}

contract SAN is Owned, ERC20 {

    string public constant name     = "SANtiment network token";
    string public constant symbol   = "SAN";
    uint8  public constant decimals = 18;

    address CROWDSALE_MINTER = 0xDa2Cf810c5718135247628689D84F94c61B41d6A;
    address public SUBSCRIPTION_MODULE = 0x00000000;
    address public beneficiary;

    uint public PLATFORM_FEE_PER_10000 = 1; //0.01%
    uint public totalOnDeposit;
    uint public totalInCirculation;

    ///@dev constructor
    function SAN() {
        beneficiary = owner = msg.sender;
    }

    // ------------------------------------------------------------------------
    // Don't accept ethers
    // ------------------------------------------------------------------------
    function () {
        throw;
    }

    //======== SECTION Configuration: Owner only ========
    //
    ///@notice set beneficiary - the account receiving platform fees.
    function setBeneficiary(address newBeneficiary)
    external
    only(owner) {
        beneficiary = newBeneficiary;
    }


    ///@notice attach module managing subscriptions. if subModule==0x0, then disables subscription functionality for this token.
    /// detached module can usually manage subscriptions, but all operations changing token balances are disabled.
    function attachSubscriptionModule(SubscriptionModule subModule)
    noAnyReentrancy
    external
    only(owner) {
        SUBSCRIPTION_MODULE = subModule;
        if (address(subModule) > 0) subModule.attachToken(this);
    }

    ///@notice set platform fee denominated in 1/10000 of SAN token. Thus "1" means 0.01% of SAN token.
    function setPlatformFeePer10000(uint newFee)
    external
    only(owner) {
        require (newFee <= 10000); //formally maximum fee is 100% (completely insane but technically possible)
        PLATFORM_FEE_PER_10000 = newFee;
    }


    //======== Interface XRateProvider: a trivial exchange rate provider. Rate is 1:1 and SAN symbol as the code
    //
    ///@dev used as a default XRateProvider (id==0) by subscription module.
    ///@notice returns always 1 because exchange rate of the token to itself is always 1.
    function getRate() returns(uint32 ,uint32) { return (1,1);  }
    function getCode() public returns(string)  { return symbol; }


    //==== Interface ERC20ModuleSupport: Subscription, Deposit and Payment Support =====
    ///
    ///@dev used by subscription module to operate on token balances.
    ///@param msg_sender should be an original msg.sender provided to subscription module.
    function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender)
    public
    onlyTrusted
    returns(bool success) {
        success = _from != msg_sender && allowed[_from][msg_sender] >= _value;
        if (!success) {
            Payment(_from, _to, _value, _fee(_value), msg_sender, PaymentStatus.APPROVAL_ERROR, 0);
        } else {
            success = _fulfillPayment(_from, _to, _value, 0, msg_sender);
            if (success) {
                allowed[_from][msg_sender] -= _value;
            }
        }
        return success;
    }

    ///@dev used by subscription module to operate on token balances.
    ///@param msg_sender should be an original msg.sender provided to subscription module.
    function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender)
    public
    onlyTrusted
    returns (bool success) {
        var fee = _fee(_value);
        assert (fee <= _value); //internal sanity check
        if (balances[_from] >= _value && balances[_to] + _value > balances[_to]) {
            balances[_from] -= _value;
            balances[_to] += _value - fee;
            balances[beneficiary] += fee;
            Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.OK, subId);
            return true;
        } else {
            Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.BALANCE_ERROR, subId);
            return false;
        }
    }

    function _fee(uint _value) internal constant returns (uint fee) {
        return _value * PLATFORM_FEE_PER_10000 / 10000;
    }

    ///@notice used by subscription module to re-create token from returning deposit.
    ///@dev a subscription module is responsible to correct deposit management.
    function _mintFromDeposit(address owner, uint amount)
    public
    onlyTrusted {
        balances[owner] += amount;
        totalOnDeposit -= amount;
        totalInCirculation += amount;
    }

    ///@notice used by subscription module to burn token while creating a new deposit.
    ///@dev a subscription module is responsible to create and maintain the deposit record.
    function _burnForDeposit(address owner, uint amount)
    public
    onlyTrusted
    returns (bool success) {
        if (balances[owner] >= amount) {
            balances[owner] -= amount;
            totalOnDeposit += amount;
            totalInCirculation -= amount;
            return true;
        } else { return false; }
    }

    //========= Crowdsale Only ===============
    ///@notice mint new token for given account in crowdsale stage
    ///@dev allowed only if token not started yet and only for registered minter.
    ///@dev tokens are become in circulation after token start.
    function mint(uint amount, address account)
    onlyCrowdsaleMinter
    isNotStartedOnly
    {
        totalSupply += amount;
        balances[account]+=amount;
    }

    ///@notice start normal operation of the token. No minting is possible after this point.
    function start()
    isNotStartedOnly
    only(owner) {
        totalInCirculation = totalSupply;
        isStarted = true;
    }

    //========= SECTION: Modifier ===============

    modifier onlyCrowdsaleMinter() {
        if (msg.sender != CROWDSALE_MINTER) throw;
        _;
    }

    modifier onlyTrusted() {
        if (msg.sender != SUBSCRIPTION_MODULE) throw;
        _;
    }

    ///@dev token not started means minting is possible, but usual token operations are not.
    modifier isNotStartedOnly() {
        if (isStarted) throw;
        _;
    }

    enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}
    ///@notice event issued on any fee based payment (made of failed).
    ///@param subId - related subscription Id if any, or zero otherwise.
    event Payment(address _from, address _to, uint _value, uint _fee, address caller, PaymentStatus status, uint subId);

}//contract SAN
```

<br />

<hr />

# Subscription Module

From the `SUBSCRIPTION_MODULE` field of the SAN token contract, the SubscriptionModule contract is deployed at [0x29f0b7c3d8ee8f6471922f089f459cab53029113](https://etherscan.io/address/0x29f0b7c3d8ee8f6471922f089f459cab53029113#code) with the following code, with v0.4.11+commit.68ef5810 and optimised:

```javascript
pragma solidity ^0.4.11;

// ==== DISCLAIMER ====
//
// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
//
// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ====
//

/// @author Santiment LLC
/// @title  Subscription Module for SAN - santiment token

// BK Ok - See CrowdsaleMinter::Base
contract Base {

    function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
    function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }

    modifier only(address allowed) {
        if (msg.sender != allowed) throw;
        _;
    }


    ///@return True if `_addr` is a contract
    function isContract(address _addr) constant internal returns (bool) {
        if (_addr == 0) return false;
        uint size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    // *************************************************
    // *          reentrancy handling                  *
    // *************************************************

    //@dev predefined locks (up to uint bit length, i.e. 256 possible)
    uint constant internal L00 = 2 ** 0;
    uint constant internal L01 = 2 ** 1;
    uint constant internal L02 = 2 ** 2;
    uint constant internal L03 = 2 ** 3;
    uint constant internal L04 = 2 ** 4;
    uint constant internal L05 = 2 ** 5;

    //prevents reentrancy attacs: specific locks
    uint private bitlocks = 0;
    modifier noReentrancy(uint m) {
        var _locks = bitlocks;
        if (_locks & m > 0) throw;
        bitlocks |= m;
        _;
        bitlocks = _locks;
    }

    modifier noAnyReentrancy {
        var _locks = bitlocks;
        if (_locks > 0) throw;
        bitlocks = uint(-1);
        _;
        bitlocks = _locks;
    }

    ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
    ///     developer should make the caller function reentrant-safe if it use a reentrant function.
    modifier reentrant { _; }

}

// BK Ok - See CrowdsaleMinter::Owned
contract Owned is Base {

    address public owner;
    address public newOwner;

    function Owned() {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) only(owner) {
        newOwner = _newOwner;
    }

    function acceptOwnership() only(newOwner) {
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    event OwnershipTransferred(address indexed _from, address indexed _to);

}


// BK Ok - But this is not referenced by SubscriptionModule
contract ERC20 is Owned {

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {
        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    uint256 public totalSupply;
    bool    public isStarted = false;

    modifier onlyHolder(address holder) {
        if (balanceOf(holder) == 0) throw;
        _;
    }

    modifier isStartedOnly() {
        if (!isStarted) throw;
        _;
    }

}

//Decision made.
// 1 - Provider is solely responsible to consider failed sub charge as an error and stop the service,
//    therefore there is no separate error state or counter for that in this Token Contract.
//
// 2 - A call originated from the user (isContract(msg.sender)==false) should throw an exception on error,
//     but it should return "false" on error if called from other contract (isContract(msg.sender)==true).
//     Reason: thrown exception are easier to see in wallets, returned boolean values are easier to evaluate in the code of the calling contract.
//
// 3 - Service providers are responsible for firing events in case of offer changes;
//     it is theirs decision to inform DApps about offer changes or not.
//


///@dev an base class to implement by Service Provider contract to be notified about subscription changes (in-Tx notification).
///     Additionally it contains standard events to be fired by service provider on offer changes.
///     see alse EVM events logged by subscription module.
//
contract ServiceProvider {

    ///@dev get human readable descriptor (or url) for this Service provider
    //
    function info() constant public returns(string);

    ///@dev called to post-approve/reject incoming single payment.
    ///@return `false` causes an exception and reverts the payment.
    //
    function onPayment(address _from, uint _value, bytes _paymentData) public returns (bool);

    ///@dev called to post-approve/reject subscription charge.
    ///@return `false` causes an exception and reverts the operation.
    //
    function onSubExecuted(uint subId) public returns (bool);

    ///@dev called to post-approve/reject a creation of the subscription.
    ///@return `false` causes an exception and reverts the operation.
    //
    function onSubNew(uint newSubId, uint offerId) public returns (bool);

    ///@dev called to notify service provider about subscription cancellation.
    ///     Provider is not able to prevent the cancellation.
    ///@return <<reserved for future implementation>>
    //
    function onSubCanceled(uint subId, address caller) public returns (bool);

    ///@dev called to notify service provider about subscription got hold/unhold.
    ///@return `false` causes an exception and reverts the operation.
    //
    function onSubUnHold(uint subId, address caller, bool isOnHold) public returns (bool);


    ///@dev following events should be used by ServiceProvider contract to notify DApps about offer changes.
    ///     SubscriptionModule do not this notification and expects it from Service Provider if desired.
    ///
    ///@dev to be fired by ServiceProvider on new Offer created in a platform.
    event OfferCreated(uint offerId,  bytes descriptor, address provider);

    ///@dev to be fired by ServiceProvider on Offer updated.
    event OfferUpdated(uint offerId,  bytes descriptor, uint oldExecCounter, address provider);

    ///@dev to be fired by ServiceProvider on Offer canceled.
    event OfferCanceled(uint offerId, bytes descriptor, address provider);

    ///@dev to be fired by ServiceProvider on Offer hold/unhold status changed.
    event OfferUnHold(uint offerId,   bytes descriptor, bool isOnHoldNow, address provider);
} //ServiceProvider

///@notice XRateProvider is an external service providing an exchange rate from external currency to SAN token.
/// it used for subscriptions priced in other currency than SAN (even calculated and paid formally in SAN).
/// if non-default XRateProvider is set for some subscription, then the amount in SAN for every periodic payment
/// will be recalculated using provided exchange rate.
///
/// Please note, that the exchange rate fraction is (uint32,uint32) number. It should be enough to express
/// any real exchange rate volatility. Nevertheless you are advised to avoid too big numbers in the fraction.
/// Possiibly you could implement the ratio of multiple token per SAN in order to keep the average ratio around 1:1.
///
/// The default XRateProvider (with id==0) defines exchange rate 1:1 and represents exchange rate of SAN token to itself.
/// this provider is set by defalult and thus the subscription becomes nominated in SAN.
//
contract XRateProvider {

    //@dev returns current exchange rate (in form of a simple fraction) from other currency to SAN (f.e. ETH:SAN).
    //@dev fraction numbers are restricted to uint16 to prevent overflow in calculations;
    function getRate() public returns (uint32 /*nominator*/, uint32 /*denominator*/);

    //@dev provides a code for another currency, f.e. "ETH" or "USD"
    function getCode() public returns (string);
}


//@dev data structure for SubscriptionModule
contract SubscriptionBase {

    enum SubState   {NOT_EXIST, BEFORE_START, PAID, CHARGEABLE, ON_HOLD, CANCELED, EXPIRED, FINALIZED}
    enum OfferState {NOT_EXIST, BEFORE_START, ACTIVE, SOLD_OUT, ON_HOLD, EXPIRED}

    string[] internal SUB_STATES   = ["NOT_EXIST", "BEFORE_START", "PAID", "CHARGEABLE", "ON_HOLD", "CANCELED", "EXPIRED", "FINALIZED" ];
    string[] internal OFFER_STATES = ["NOT_EXIST", "BEFORE_START", "ACTIVE", "SOLD_OUT", "ON_HOLD", "EXPIRED"];

    //@dev subscription and subscription offer use the same structure. Offer is technically a template for subscription.
    struct Subscription {
        address transferFrom;   // customer (unset in subscription offer)
        address transferTo;     // service provider
        uint pricePerHour;      // price in SAN per hour (possibly recalculated using exchange rate)
        uint32 initialXrate_n;  // nominator
        uint32 initialXrate_d;  // denominator
        uint16 xrateProviderId; // id of a registered exchange rate provider
        uint paidUntil;         // subscription is paid until time
        uint chargePeriod;      // subscription can't be charged more often than this period
        uint depositAmount;     // upfront deposit on creating subscription (possibly recalculated using exchange rate)

        uint startOn;           // for offer: can't be accepted before  <startOn> ; for subscription: can't be charged before <startOn>
        uint expireOn;          // for offer: can't be accepted after  <expireOn> ; for subscription: can't be charged after  <expireOn>
        uint execCounter;       // for offer: max num of subscriptions available  ; for subscription: num of charges made.
        bytes descriptor;       // subscription payload (subject): evaluated by service provider.
        uint onHoldSince;       // subscription: on-hold since time or 0 if not onHold. offer: unused: //ToDo: to be implemented
    }

    struct Deposit {
        uint value;         // value on deposit
        address owner;      // usually a customer
        bytes descriptor;   // service related descriptor to be evaluated by service provider
    }

    event NewSubscription(address customer, address service, uint offerId, uint subId);
    event NewDeposit(uint depositId, uint value, address sender);
    event NewXRateProvider(address addr, uint16 xRateProviderId, address sender);
    event DepositReturned(uint depositId, address returnedTo);
    event SubscriptionDepositReturned(uint subId, uint amount, address returnedTo, address sender);
    event OfferOnHold(uint offerId, bool onHold, address sender);
    event OfferCanceled(uint offerId, address sender);
    event SubOnHold(uint offerId, bool onHold, address sender);
    event SubCanceled(uint subId, address sender);

}

///@dev an Interface for SubscriptionModule.
///     extracted here for better overview.
///     see detailed documentation in implementation module.
contract SubscriptionModule is SubscriptionBase, Base {

    ///@dev ***** module configuration *****
    function attachToken(address token) public;

    ///@dev ***** single payment handling *****
    function paymentTo(uint _value, bytes _paymentData, ServiceProvider _to) public reentrant returns (bool success);
    function paymentFrom(uint _value, bytes _paymentData, address _from, ServiceProvider _to) public reentrant returns (bool success);

    ///@dev ***** subscription handling *****
    ///@dev some functions are marked as reentrant, even theirs implementation is marked with noReentrancy(LOCK).
    ///     This is intentionally because these noReentrancy(LOCK) restrictions can be lifted in the future.
    //      Functions would become reentrant.
    function createSubscription(uint _offerId, uint _expireOn, uint _startOn) public reentrant returns (uint newSubId);
    function cancelSubscription(uint subId) reentrant public;
    function cancelSubscription(uint subId, uint gasReserve) reentrant public;
    function holdSubscription(uint subId) public reentrant returns (bool success);
    function unholdSubscription(uint subId) public reentrant returns (bool success);
    function executeSubscription(uint subId) public reentrant returns (bool success);
    function postponeDueDate(uint subId, uint newDueDate) public returns (bool success);
    function returnSubscriptionDesposit(uint subId) public;
    function claimSubscriptionDeposit(uint subId) public;
    function state(uint subId) public constant returns(string state);
    function stateCode(uint subId) public constant returns(uint stateCode);

    ///@dev ***** subscription offer handling *****
    function createSubscriptionOffer(uint _price, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositValue, uint _startOn, bytes _descriptor) public reentrant returns (uint subId);
    function updateSubscriptionOffer(uint offerId, uint _offerLimit) public;
    function holdSubscriptionOffer(uint offerId) public returns (bool success);
    function unholdSubscriptionOffer(uint offerId) public returns (bool success);
    function cancelSubscriptionOffer(uint offerId) public returns (bool);

    ///@dev ***** simple deposit handling *****
    function createDeposit(uint _value, bytes _descriptor) public returns (uint subId);
    function claimDeposit(uint depositId) public;

    ///@dev ***** ExchangeRate provider *****
    function registerXRateProvider(XRateProvider addr) public returns (uint16 xrateProviderId);

    ///@dev ***** Service provider (payment receiver) *****
    function enableServiceProvider(ServiceProvider addr, bytes moreInfo) public;
    function disableServiceProvider(ServiceProvider addr, bytes moreInfo) public;


    ///@dev ***** convenience subscription getter *****
    function subscriptionDetails(uint subId) public constant returns(
        address transferFrom,
        address transferTo,
        uint pricePerHour,
        uint32 initialXrate_n, //nominator
        uint32 initialXrate_d, //denominator
        uint16 xrateProviderId,
        uint chargePeriod,
        uint startOn,
        bytes descriptor
    );

    function subscriptionStatus(uint subId) public constant returns(
        uint depositAmount,
        uint expireOn,
        uint execCounter,
        uint paidUntil,
        uint onHoldSince
    );

    enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}
    event Payment(address _from, address _to, uint _value, uint _fee, address sender, PaymentStatus status, uint subId);
    event ServiceProviderEnabled(address addr, bytes moreInfo);
    event ServiceProviderDisabled(address addr, bytes moreInfo);

} //SubscriptionModule

contract ERC20ModuleSupport {
    function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender) public returns(bool success);
    function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender) public returns (bool success);
    function _mintFromDeposit(address owner, uint amount) public;
    function _burnForDeposit(address owner, uint amount) public returns(bool success);
}

//@dev implementation
contract SubscriptionModuleImpl is SubscriptionModule, Owned  {

    string public constant VERSION = "0.1.0";

    // *************************************************
    // *              contract states                  *
    // *************************************************

    ///@dev list of all registered service provider contracts implemented as a map for better lookup.
    mapping (address=>bool) public providerRegistry;

    ///@dev all subscriptions and offers (incl. FINALIZED).
    mapping (uint => Subscription) public subscriptions;

    ///@dev all active simple deposits gived by depositId.
    mapping (uint => Deposit) public deposits;

    ///@dev addresses of registered exchange rate providers.
    XRateProvider[] public xrateProviders;

    ///@dev ongoing counter for subscription ids starting from 1.
    ///     Current value represents an id of last created subscription.
    uint public subscriptionCounter = 0;

    ///@dev ongoing counter for simple deposit ids starting from 1.
    ///     Current value represents an id of last created deposit.
    uint public depositCounter = 0;

    ///@dev Token contract with ERC20ModuleSupport addon.
    ///     Subscription Module operates on its balances via ERC20ModuleSupport interface as trusted module.
    ERC20ModuleSupport public san;



    // *************************************************
    // *     reject all ether sent to this contract    *
    // *************************************************
    function () {
        throw;
    }



    // *************************************************
    // *            setup and configuration            *
    // *************************************************

    ///@dev constructor
    function SubscriptionModuleImpl() {
        owner = msg.sender;
        xrateProviders.push(XRateProvider(this)); //this is a default SAN:SAN (1:1) provider with default id == 0
    }


    ///@dev attach SAN token to work with; can be done only once.
    function attachToken(address token) public {
        assert(address(san) == 0); //only in new deployed state
        san = ERC20ModuleSupport(token);
    }


    ///@dev register a new service provider to the platform.
    function enableServiceProvider(ServiceProvider addr, bytes moreInfo) public only(owner) {
        providerRegistry[addr] = true;
        ServiceProviderEnabled(addr, moreInfo);
    }


    ///@dev de-register the service provider with given `addr`.
    function disableServiceProvider(ServiceProvider addr, bytes moreInfo) public only(owner) {
        delete providerRegistry[addr];
        ServiceProviderDisabled(addr, moreInfo);
    }


    ///@dev register new exchange rate provider.
    ///     XRateProvider can't be de-registered, because they could be still in use by some subscription.
    function registerXRateProvider(XRateProvider addr) public only(owner) returns (uint16 xrateProviderId) {
        xrateProviderId = uint16(xrateProviders.length);
        xrateProviders.push(addr);
        NewXRateProvider(addr, xrateProviderId, msg.sender);
    }


    ///@dev xrateProviders length accessor.
    function getXRateProviderLength() public constant returns (uint) {
        return xrateProviders.length;
    }


    // *************************************************
    // *           single payment methods              *
    // *************************************************

    ///@notice makes single payment to service provider.
    ///@param _value - amount of SAN token to sent
    ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
    ///@param _to - service provider contract
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function paymentTo(uint _value, bytes _paymentData, ServiceProvider _to) public reentrant returns (bool success) {
        if (san._fulfillPayment(msg.sender, _to, _value, 0, msg.sender)) {
            // a ServiceProvider (a ServiceProvider) has here an opportunity verify and reject the payment
            assert (ServiceProvider(_to).onPayment(msg.sender, _value, _paymentData));                      // <=== possible reentrancy
            return true;
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }


    ///@notice makes single preapproved payment to service provider. An amount must be already preapproved by payment sender to recepient.
    ///@param _value - amount of SAN token to sent
    ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
    ///@param _from - sender of the payment (other than msg.sender)
    ///@param _to - service provider contract
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function paymentFrom(uint _value, bytes _paymentData, address _from, ServiceProvider _to) public reentrant returns (bool success) {
        if (san._fulfillPreapprovedPayment(_from, _to, _value, msg.sender)) {
            // a ServiceProvider (a ServiceProvider) has here an opportunity verify and reject the payment
            assert (ServiceProvider(_to).onPayment(_from, _value, _paymentData));                           // <=== possible reentrancy
            return true;
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }


    // *************************************************
    // *            subscription handling              *
    // *************************************************

    ///@dev convenience getter for some subscription fields
    function subscriptionDetails(uint subId) public constant returns (
        address transferFrom,
        address transferTo,
        uint pricePerHour,
        uint32 initialXrate_n, //nominator
        uint32 initialXrate_d, //denominator
        uint16 xrateProviderId,
        uint chargePeriod,
        uint startOn,
        bytes descriptor
    ) {
        Subscription sub = subscriptions[subId];
        return (sub.transferFrom, sub.transferTo, sub.pricePerHour, sub.initialXrate_n, sub.initialXrate_d, sub.xrateProviderId, sub.chargePeriod, sub.startOn, sub.descriptor);
    }


    ///@dev convenience getter for some subscription fields
    ///     a caller must know, that the subscription with given id exists, because all these fields can be 0 even the subscription with given id exists.
    function subscriptionStatus(uint subId) public constant returns(
        uint depositAmount,
        uint expireOn,
        uint execCounter,
        uint paidUntil,
        uint onHoldSince
    ) {
        Subscription sub = subscriptions[subId];
        return (sub.depositAmount, sub.expireOn, sub.execCounter, sub.paidUntil, sub.onHoldSince);
    }


    ///@notice execute periodic subscription payment.
    ///        Any of customer, service provider and platform owner can execute this function.
    ///        This ensures, that the subscription charge doesn't become delayed.
    ///        At least the platform owner has an incentive to get fee and thus can trigger the function.
    ///        An execution fails if subscription is not in status `CHARGEABLE`.
    ///@param subId - subscription to be charged.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function executeSubscription(uint subId) public noReentrancy(L00) returns (bool) {
        Subscription storage sub = subscriptions[subId];
        assert (msg.sender == sub.transferFrom || msg.sender == sub.transferTo || msg.sender == owner);
        if (_subscriptionState(sub)==SubState.CHARGEABLE) {
            var _from = sub.transferFrom;
            var _to = sub.transferTo;
            var _value = _amountToCharge(sub);
            if (san._fulfillPayment(_from, _to, _value, subId, msg.sender)) {
                sub.paidUntil  = max(sub.paidUntil, sub.startOn) + sub.chargePeriod;
                ++sub.execCounter;
                // a ServiceProvider (a ServiceProvider) has here an opportunity to verify and reject the payment
                assert (ServiceProvider(_to).onSubExecuted(subId));
                return true;
            }
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }


    ///@notice move `paidUntil` forward to given `newDueDate`. It waives payments for given time.
    ///        This function can be used by service provider to `give away` some service time for free.
    ///@param subId - id of subscription to be postponed.
    ///@param newDueDate - new `paidUntil` datetime; require `newDueDate > paidUntil`.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function postponeDueDate(uint subId, uint newDueDate) public returns (bool success){
        Subscription storage sub = subscriptions[subId];
        assert (_isSubscription(sub));
        assert (sub.transferTo == msg.sender); //only Service Provider is allowed to postpone the DueDate
        if (sub.paidUntil < newDueDate) {
            sub.paidUntil = newDueDate;
            return true;
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }


    ///@dev return current status as a name of a subscription (or an offer) with given id;
    function state(uint subOrOfferId) public constant returns(string state) {
        Subscription subOrOffer = subscriptions[subOrOfferId];
        return _isOffer(subOrOffer)
              ? OFFER_STATES[uint(_offerState(subOrOffer))]
              : SUB_STATES[uint(_subscriptionState(subOrOffer))];
    }


    ///@dev return current status as a code of a subscription (or an offer) with given id;
    function stateCode(uint subOrOfferId) public constant returns(uint stateCode) {
        Subscription subOrOffer = subscriptions[subOrOfferId];
        return _isOffer(subOrOffer)
              ? uint(_offerState(subOrOffer))
              : uint(_subscriptionState(subOrOffer));
    }


    function _offerState(Subscription storage sub) internal constant returns(OfferState status) {
        if (!_isOffer(sub)) {
            return OfferState.NOT_EXIST;
        } else if (sub.startOn > now) {
            return OfferState.BEFORE_START;
        } else if (sub.onHoldSince > 0) {
            return OfferState.ON_HOLD;
        } else if (now <= sub.expireOn) {
            return sub.execCounter > 0
                ? OfferState.ACTIVE
                : OfferState.SOLD_OUT;
        } else {
            return OfferState.EXPIRED;
        }
    }

    function _subscriptionState(Subscription storage sub) internal constant returns(SubState status) {
        if (!_isSubscription(sub)) {
            return SubState.NOT_EXIST;
        } else if (sub.startOn > now) {
            return SubState.BEFORE_START;
        } else if (sub.onHoldSince > 0) {
            return SubState.ON_HOLD;
        } else if (sub.paidUntil >= sub.expireOn) {
            return now < sub.expireOn
                ? SubState.CANCELED
                : sub.depositAmount > 0
                    ? SubState.EXPIRED
                    : SubState.FINALIZED;
        } else if (sub.paidUntil <= now) {
            return SubState.CHARGEABLE;
        } else {
            return SubState.PAID;
        }
    }


    ///@notice create a new subscription offer.
    ///@dev only registered service provider is allowed to create offers.
    ///@dev subscription uses SAN token for payment, but an exact amount to be paid or deposit is calculated using exchange rate from external xrateProvider (previosly registered on platform).
    ///    This allows to create a subscription bound to another token or even fiat currency.
    ///@param _pricePerHour - subscription price per hour in SAN
    ///@param _xrateProviderId - id of external exchange rate provider from subscription currency to SAN; "0" means subscription is priced in SAN natively.
    ///@param _chargePeriod - time period to charge; subscription can't be charged more often than this period. Time units are native ethereum time, returning by `now`, i.e. seconds.
    ///@param _expireOn - offer can't be accepted after this time.
    ///@param _offerLimit - how many subscription are available to created from this offer; there is no magic number for unlimited offer -- use big number instead.
    ///@param _depositAmount - upfront deposit required for creating a subscription; this deposit becomes fully returned on subscription is over.
    ///       currently this deposit is not subject of platform fees and will be refunded in full. Next versions of this module can use deposit in case of outstanding payments.
    ///@param _startOn - a subscription from this offer can't be created before this time. Time units are native ethereum time, returning by `now`, i.e. seconds.
    ///@param _descriptor - arbitrary bytes as an offer descriptor. This descriptor is copied into subscription and then service provider becomes it passed in notifications.
    //
    function createSubscriptionOffer(uint _pricePerHour, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositAmount, uint _startOn, bytes _descriptor)
    public
    noReentrancy(L01)
    onlyRegisteredProvider
    returns (uint subId) {
        assert (_startOn < _expireOn);
        assert (_chargePeriod <= 10 years); //sanity check
        var (_xrate_n, _xrate_d) = _xrateProviderId == 0
                                 ? (1,1)
                                 : XRateProvider(xrateProviders[_xrateProviderId]).getRate(); // <=== possible reentrancy
        assert (_xrate_n > 0 && _xrate_d > 0);
        subscriptions[++subscriptionCounter] = Subscription ({
            transferFrom    : 0,                  // empty transferFrom field means we have an offer, not a subscription
            transferTo      : msg.sender,         // service provider is a beneficiary of subscripton payments
            pricePerHour    : _pricePerHour,      // price per hour in SAN (recalculated from base currency if needed)
            xrateProviderId : _xrateProviderId,   // id of registered exchange rate provider or zero if an offer is nominated in SAN.
            initialXrate_n  : _xrate_n,           // fraction nominator of the initial exchange rate
            initialXrate_d  : _xrate_d,           // fraction denominator of the initial exchange rate
            paidUntil       : 0,                  // service is considered to be paid until this time; no charge is possible while subscription is paid for now.
            chargePeriod    : _chargePeriod,      // period in seconds (ethereum block time unit) to charge.
            depositAmount   : _depositAmount,     // deposit required for subscription accept.
            startOn         : _startOn,
            expireOn        : _expireOn,
            execCounter     : _offerLimit,
            descriptor      : _descriptor,
            onHoldSince     : 0                   // offer is not on hold by default.
        });
        return subscriptionCounter;               // returns an id of the new offer.
    }


    ///@notice updates currently available number of subscription for this offer.
    ///        Other offer's parameter can't be updated because they are considered to be a public offer reviewed by customers.
    ///        The service provider should recreate the offer as a new one in case of other changes.
    //
    function updateSubscriptionOffer(uint _offerId, uint _offerLimit) public {
        Subscription storage offer = subscriptions[_offerId];
        assert (_isOffer(offer));
        assert (offer.transferTo == msg.sender); //only Provider is allowed to update the offer.
        offer.execCounter = _offerLimit;
    }


    ///@notice accept given offer and create a new subscription on the base of it.
    ///
    ///@dev the service provider (offer.`transferTo`) becomes notified about new subscription by call `onSubNew(newSubId, _offerId)`.
    ///     It is provider's responsibility to retrieve and store any necessary information about offer and this new subscription. Some of info is only available at this point.
    ///     The Service Provider can also reject the new subscription by throwing an exception or returning `false` from `onSubNew(newSubId, _offerId)` event handler.
    ///@param _offerId   - id of the offer to be accepted
    ///@param _expireOn  - subscription expiration time; no charges are possible behind this time.
    ///@param _startOn   - subscription start time; no charges are possible before this time.
    ///                    If the `_startOn` is in the past or is zero, it means start the subscription ASAP.
    //
    function createSubscription(uint _offerId, uint _expireOn, uint _startOn) public noReentrancy(L02) returns (uint newSubId) {
        assert (_startOn < _expireOn);
        Subscription storage offer = subscriptions[_offerId];
        assert (_isOffer(offer));
        assert (offer.startOn == 0     || offer.startOn  <= now);
        assert (offer.expireOn == 0    || offer.expireOn >= now);
        assert (offer.onHoldSince == 0);
        assert (offer.execCounter > 0);
        --offer.execCounter;
        newSubId = ++subscriptionCounter;
        //create a clone of the offer...
        Subscription storage newSub = subscriptions[newSubId] = offer;
        //... and adjust some fields specific to subscription
        newSub.transferFrom = msg.sender;
        newSub.execCounter = 0;
        newSub.paidUntil = newSub.startOn = max(_startOn, now);     //no debts before actual creation time!
        newSub.expireOn = _expireOn;
        newSub.depositAmount = _applyXchangeRate(newSub.depositAmount, newSub);                    // <=== possible reentrancy
        //depositAmount is now stored in the sub, so burn the same amount from customer's account.
        assert (san._burnForDeposit(msg.sender, newSub.depositAmount));
        assert (ServiceProvider(newSub.transferTo).onSubNew(newSubId, _offerId));                  // <=== possible reentrancy; service provider can still reject the new subscription here

        NewSubscription(newSub.transferFrom, newSub.transferTo, _offerId, newSubId);
        return newSubId;
    }


    ///@notice cancel an offer given by `offerId`.
    ///@dev sets offer.`expireOn` to `expireOn`.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function cancelSubscriptionOffer(uint offerId) public returns (bool) {
        Subscription storage offer = subscriptions[offerId];
        assert (_isOffer(offer));
        assert (offer.transferTo == msg.sender || owner == msg.sender); //only service provider or platform owner is allowed to cancel the offer
        if (offer.expireOn>now){
            offer.expireOn = now;
            OfferCanceled(offerId, msg.sender);
            return true;
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }


    ///@notice cancel an subscription given by `subId` (a graceful version).
    ///@notice IMPORTANT: a malicious service provider can consume all gas and preventing subscription from cancellation.
    ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
    ///         see `cancelSubscription(uint subId, uint gasReserve)` for more documentation.
    //
    function cancelSubscription(uint subId) public {
        return cancelSubscription(subId, 0);
    }


    ///@notice cancel an subscription given by `subId` (a forced version).
    ///        Cancellation means no further charges to this subscription are possible. The provided subscription deposit can be withdrawn only `paidUntil` period is over.
    ///        Depending on nature of the service provided, the service provider can allow an immediate deposit withdrawal by `returnSubscriptionDesposit(uint subId)` call, but its on his own.
    ///        In some business cases a deposit must remain locked until `paidUntil` period is over even, the subscription is already canceled.
    ///@notice gasReserve is a gas amount reserved for contract execution AFTER service provider becomes `onSubCanceled(uint256,address)` notification.
    ///        It guarantees, that cancellation becomes executed even a (malicious) service provider consumes all gas provided.
    ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
    ///        This difference is because the customer must always have a possibility to cancel his contract even the service provider disagree on cancellation.
    ///@param subId - subscription to be cancelled
    ///@param gasReserve - gas reserved for call finalization (minimum reservation is 10000 gas)
    //
    function cancelSubscription(uint subId, uint gasReserve) public noReentrancy(L03) {
        Subscription storage sub = subscriptions[subId];
        assert (sub.transferFrom == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to cancel it
        assert (_isSubscription(sub));
        var _to = sub.transferTo;
        sub.expireOn = max(now, sub.paidUntil);
        if (msg.sender != _to) {
            //supress re-throwing of exceptions; reserve enough gas to finish this function
            gasReserve = max(gasReserve,10000);  //reserve minimum 10000 gas
            assert (msg.gas > gasReserve);       //sanity check
            if (_to.call.gas(msg.gas-gasReserve)(bytes4(sha3("onSubCanceled(uint256,address)")), subId, msg.sender)) {     // <=== possible reentrancy
                //do nothing. it is notification only.
                //Later: is it possible to evaluate return value here? If is better to return the subscription deposit here.
            }
        }
        SubCanceled(subId, msg.sender);
    }


    ///@notice place an active offer on hold; it means no subscriptions can be created from this offer.
    ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
    ///@param offerId - id of the offer to be placed on hold.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function holdSubscriptionOffer(uint offerId) public returns (bool success) {
        Subscription storage offer = subscriptions[offerId];
        assert (_isOffer(offer));
        require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can place the offer on hold.
        if (offer.onHoldSince == 0) {
            offer.onHoldSince = now;
            OfferOnHold(offerId, true, msg.sender);
            return true;
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }


    ///@notice resume on-hold offer; subscriptions can be created from this offer again (if other conditions are met).
    ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
    ///@param offerId - id of the offer to be resumed.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function unholdSubscriptionOffer(uint offerId) public returns (bool success) {
        Subscription storage offer = subscriptions[offerId];
        assert (_isOffer(offer));
        require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can reactivate the offer.
        if (offer.onHoldSince > 0) {
            offer.onHoldSince = 0;
            OfferOnHold(offerId, false, msg.sender);
            return true;
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }


    ///@notice called by customer or service provider to place a subscription on hold.
    ///        If call is originated by customer the service provider can reject the request.
    ///        A subscription on hold will not be charged. The service is usually not provided as well.
    ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function holdSubscription(uint subId) public noReentrancy(L04) returns (bool success) {
        Subscription storage sub = subscriptions[subId];
        assert (_isSubscription(sub));
        var _to = sub.transferTo;
        require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
        if (sub.onHoldSince == 0) {
            if (msg.sender == _to || ServiceProvider(_to).onSubUnHold(subId, msg.sender, true)) {          // <=== possible reentrancy
                sub.onHoldSince = now;
                SubOnHold(subId, true, msg.sender);
                return true;
            }
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }


    ///@notice called by customer or service provider to unhold subscription.
    ///        If call is originated by customer the service provider can reject the request.
    ///        A subscription on hold will not be charged. The service is usually not provided as well.
    ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function unholdSubscription(uint subId) public noReentrancy(L05) returns (bool success) {
        Subscription storage sub = subscriptions[subId];
        assert (_isSubscription(sub));
        var _to = sub.transferTo;
        require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
        if (sub.onHoldSince > 0) {
            if (msg.sender == _to || ServiceProvider(_to).onSubUnHold(subId, msg.sender, false)) {         // <=== possible reentrancy
                sub.paidUntil += now - sub.onHoldSince;
                sub.onHoldSince = 0;
                SubOnHold(subId, false, msg.sender);
                return true;
            }
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }



    // *************************************************
    // *              deposit handling                 *
    // *************************************************

    ///@notice can be called by provider on CANCELED subscription to return a subscription deposit to customer immediately.
    ///        Customer can anyway collect his deposit after `paidUntil` period is over.
    ///@param subId - subscription holding the deposit
    //
    function returnSubscriptionDesposit(uint subId) public {
        Subscription storage sub = subscriptions[subId];
        assert (_subscriptionState(sub) == SubState.CANCELED);
        assert (sub.depositAmount > 0); //sanity check
        assert (sub.transferTo == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to release deposit.
        sub.expireOn = now;
        _returnSubscriptionDesposit(subId, sub);
    }


    ///@notice called by customer on EXPIRED subscription (`paidUntil` period is over) to collect a subscription deposit.
    ///        Customer can anyway collect his deposit after `paidUntil` period is over.
    ///@param subId - subscription holding the deposit
    //
    function claimSubscriptionDeposit(uint subId) public {
        Subscription storage sub = subscriptions[subId];
        assert (_subscriptionState(sub) == SubState.EXPIRED);
        assert (sub.transferFrom == msg.sender);
        assert (sub.depositAmount > 0);
        _returnSubscriptionDesposit(subId, sub);
    }


    //@dev returns subscription deposit to customer
    function _returnSubscriptionDesposit(uint subId, Subscription storage sub) internal {
        uint depositAmount = sub.depositAmount;
        sub.depositAmount = 0;
        san._mintFromDeposit(sub.transferFrom, depositAmount);
        SubscriptionDepositReturned(subId, depositAmount, sub.transferFrom, msg.sender);
    }


    ///@notice create simple unlocked deposit, required by some services. It can be considered as prove of customer's stake.
    ///        This desposit can be claimed back by the customer at anytime.
    ///        The service provider is responsible to check the deposit before providing the service.
    ///@param _value - non zero deposit amount.
    ///@param _descriptor - is a uniq key, usually given by service provider to the customer in order to make this deposit unique.
    ///        Service Provider should reject deposit with unknown descriptor, because most probably it is in use for some another service.
    ///@return depositId - a handle to claim back the deposit later.
    //
    function createDeposit(uint _value, bytes _descriptor) public returns (uint depositId) {
        require (_value > 0);
        assert (san._burnForDeposit(msg.sender,_value));
        deposits[++depositCounter] = Deposit ({
            owner : msg.sender,
            value : _value,
            descriptor : _descriptor
        });
        NewDeposit(depositCounter, _value, msg.sender);
        return depositCounter;
    }


    ///@notice return previously created deposit to the user. User can collect only own deposit.
    ///        The service provider is responsible to check the deposit before providing the service.
    ///@param _depositId - an id of the deposit to be collected.
    //
    function claimDeposit(uint _depositId) public {
        var deposit = deposits[_depositId];
        require (deposit.owner == msg.sender);
        var value = deposits[_depositId].value;
        delete deposits[_depositId];
        san._mintFromDeposit(msg.sender, value);
        DepositReturned(_depositId, msg.sender);
    }



    // *************************************************
    // *            some internal functions            *
    // *************************************************

    function _amountToCharge(Subscription storage sub) internal reentrant returns (uint) {
        return _applyXchangeRate(sub.pricePerHour * sub.chargePeriod, sub) / 1 hours;       // <==== reentrant function usage
    }

    function _applyXchangeRate(uint amount, Subscription storage sub) internal reentrant returns (uint) {  // <== actually called from reentrancy guarded context only (i.e. externally secured)
        if (sub.xrateProviderId > 0) {
            // xrate_n: nominator
            // xrate_d: denominator of the exchange rate fraction.
            var (xrate_n, xrate_d) = XRateProvider(xrateProviders[sub.xrateProviderId]).getRate();        // <=== possible reentrancy
            amount = amount * sub.initialXrate_n * xrate_d / sub.initialXrate_d / xrate_n;
        }
        return amount;
    }

    function _isOffer(Subscription storage sub) internal constant returns (bool){
        return sub.transferFrom == 0 && sub.transferTo != 0;
    }

    function _isSubscription(Subscription storage sub) internal constant returns (bool){
        return sub.transferFrom != 0 && sub.transferTo != 0;
    }

    function _exists(Subscription storage sub) internal constant returns (bool){
        return sub.transferTo != 0;   //existing subscription or offer has always transferTo set.
    }

    modifier onlyRegisteredProvider(){
        if (!providerRegistry[msg.sender]) throw;
        _;
    }

} //SubscriptionModuleImpl
```

<br />

<hr />

## SantimentWhiteList

From the `COMMUNITY_ALLOWANCE_LIST` field of the CrowdsaleMinter contract, the SantimentWhiteList contract is deployed at [0xd2675d3ea478692ad34f09fa1f8bda67a9696bf7](https://etherscan.io/address/0xd2675d3ea478692ad34f09fa1f8bda67a9696bf7#code) with the following code, with Soliditiy v0.4.11+commit.68ef5810 and optimised:

```javascript
// BK Ok
pragma solidity ^0.4.11;

//
// ==== DISCLAIMER ====
//
// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
//
// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ====
//
//
// ==== PARANOIA NOTICE ====
// A careful reader will find some additional checks and excessive code, consuming some extra gas. This is intentional.
// Even though the contract should work without these parts, they make the code more secure in production and for future refactoring.
// Also, they show more clearly what we have considered and addressed during development.
// Discussion is welcome!
// ====
//

/// @author written by ethernian for Santiment Sagl
/// @notice report bugs to: bugs@ethernian.com
/// @title Santiment WhiteList contract
contract SantimentWhiteList {

    string constant public VERSION = "0.3.1";

    function () { throw; }   //explicitly unpayable

    struct Limit {
        uint24 min;  //finney
        uint24 max;  //finney
    }

    struct LimitWithAddr {
        address addr;
        uint24 min; //finney
        uint24 max; //finney
    }

    mapping(address=>Limit) public allowed;
    uint16  public chunkNr = 0;
    uint    public recordNum = 0;
    uint256 public controlSum = 0;
    bool public isSetupMode = true;
    address public admin;

    function SantimentWhiteList() { admin = msg.sender; }

    ///@dev add next address package to the internal white list.
    ///@dev call is allowed in setup mode only.
    function addPack(address[] addrs, uint24[] mins, uint24[] maxs, uint16 _chunkNr)
    setupOnly
    adminOnly
    external {
        var len = addrs.length;
        require ( chunkNr++ == _chunkNr);
        require ( mins.length == len &&  mins.length == len );
        for(uint16 i=0; i<len; ++i) {
            var addr = addrs[i];
            var max  = maxs[i];
            var min  = mins[i];
            Limit lim = allowed[addr];
            //remove old record if exists
            if (lim.max > 0) {
                controlSum -= uint160(addr) + lim.min + lim.max;
                delete allowed[addr];
            }
            //insert record if max > 0
            if (max > 0) {
                // max > 0 means add a new record into the list.
                allowed[addr] = Limit({min:min, max:max});
                controlSum += uint160(addr) + min + max;
            }
        }//for
        recordNum+=len;
    }

    ///@notice switch off setup mode
    function start()
    adminOnly
    public {
        isSetupMode = false;
    }

    modifier setupOnly {
        if ( !isSetupMode ) throw;
        _;
    }

    modifier adminOnly {
        if (msg.sender != admin) throw;
        _;
    }

}
```