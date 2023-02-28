function <function_name> (<param_type <param_name>) <visibility> <state mutability> [ returns (<return_type>) ] {
    // function body
}

/* solidty function visibility specifiers: 
    - private: only visible in the current contract 
    - internal: only visible in the current contract and contracts deriving from it
    - public: visible everywhere, externally and internally (including getter funcitons for storage/state variables)
    - external: only visible externally (not in derived contracts), however, can be accessed within the current contract via this.<function_name>
*/

/* solidity function state mutability specifiers:
    - pure: does not read or modify any state
    - view: does not modify any state. But can read/view states
    - nonpayable: does not accept ether
    - payable: can accept ether, can accpt Ether sent to the contract. If 'payable' is not specified, the function will automatically reject all Ether sent to it
*/