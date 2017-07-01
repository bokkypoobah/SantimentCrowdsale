# Base

```javascript
// BK Ok
pragma solidity ^0.4.11;

// BK Ok
contract Base {

    // BK Next 2 lines Ok
    function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
    function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }

    // BK Ok
    modifier only(address allowed) {
        if (msg.sender != allowed) throw;
        _;
    }


    ///@return True if `_addr` is a contract
    // BK Ok
    function isContract(address _addr) constant internal returns (bool) {
        // BK Ok
        if (_addr == 0) return false;
        // BK Ok
        uint size;
        assembly {
            // BK Ok - https://ethereum.stackexchange.com/questions/15641/how-does-a-contract-find-out-if-another-address-is-a-contract
            size := extcodesize(_addr)
        }
        // BK Ok
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
    // BK Ok. As txs are executed serially, these separate locks should operate up the stack
    modifier noReentrancy(uint m) {
        // BK Ok - Saving current state
        var _locks = bitlocks;
        // BK Ok - This particular bit locked?
        if (_locks & m > 0) throw;
        // BK Ok - Turn on bit
        bitlocks |= m;
        _;
        // BK Ok - Reverting state at the beginning of this modifier
        bitlocks = _locks;
    }

    // BK Ok
    modifier noAnyReentrancy {
        // BK Ok - Save current state
        var _locks = bitlocks;
        // BK Ok - Check if any other functions have locks
        if (_locks > 0) throw;
        // BK Ok - Switch 0xFF..FF
        bitlocks = uint(-1);
        _;
        // BK Ok - Reverting state at the beginning of this modifier
        bitlocks = _locks;
    }

    ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
    ///     developer should make the caller function reentrant-safe if it use a reentrant function.
    // BK Ok - Used in many functions in SubscriptionModule
    modifier reentrant { _; }

}

// BK Ok
contract MintableToken {
    //target token contract is responsible to accept only authorized mint calls.
    // BK Ok - `SAN.mint(...)`
    function mint(uint amount, address account);

    //start the token on minting finished,
    // BK Ok - `SAN.start()`
    function start();
}

// BK Ok - standard Owned contract with `acceptOwnership()`
contract Owned is Base {

    // BK Next 2 Ok
    address public owner;
    address public newOwner;

    // BK Ok - Constructor assigns message sender as owner of contract
    function Owned() {
        owner = msg.sender;
    }

    // BK Ok - Propose new owner
    function transferOwnership(address _newOwner) only(owner) {
        newOwner = _newOwner;
    }

    // BK Ok - Good
    function acceptOwnership() only(newOwner) {
        // BK Ok - Log
        OwnershipTransferred(owner, newOwner);
        // BK Ok - Update owner
        owner = newOwner;
    }

    // BK Ok
    event OwnershipTransferred(address indexed _from, address indexed _to);

}
```

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Santiment - Jun 25 2017