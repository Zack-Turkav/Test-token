pragma solidity ^0.8.2;

//  import "./github/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
//  import "./github/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
    import "@openzeppelin/contracts/utils/math/SafeMath.sol";
 

    contract Test3 {
    using SafeMath for uint256;
    uint TAX_FEE = 5;
    uint POOL_FEE = 5;

    mapping(address => bool) excludedFromTax;
    mapping(address => bool) dev;
    address devWal = 0xc8fff4E8d8da804430864fC87915BB3A23033F64;
    address poolWal = 0x3F868554a05Ab37b2F4Cad51C09bC0C2a19de507;
    mapping(address => bool) pool;


    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 10000 * 10 **18;
    string public name = "Test3";
    string public symbol ="T3";
    uint public decimals = 18;  
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(){
        balances[msg.sender] = totalSupply;
        excludedFromTax[msg.sender] = true;
        dev[msg.sender] = true;
    }

    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }

    function transfer(address to, uint value) public returns(bool) {
        if(excludedFromTax[msg.sender] == true)
        {
            require(balanceOf(msg.sender) >= value, 'balance too low');

            balances[to] += value;
            balances[msg.sender] -= value;

            emit Transfer(msg.sender, to, value);
        
        }
        else
        {
            
            require(balanceOf(msg.sender) >= value, 'balance too low');

            uint poolAmount = value.mul(POOL_FEE) / 100;
            uint taxAmount = value.mul(TAX_FEE) / 100;
                        
            balances[devWal] += taxAmount;
            balances[poolWal] += poolAmount;
            balances[to] += value.sub(poolAmount).sub(taxAmount);
            balances[msg.sender] -= value;

            emit Transfer(msg.sender, to, value);
            
        }
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns(bool)
    {
        
        require(balanceOf(from) >= value, 'balance too low');
        require(allowance[from][msg.sender] >= value, 'allowance too low');
        
        balances[to] += value;
        balances[msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
        // if(excludedFromTax[msg.sender] == true)
        // {
        //     require(balanceOf(msg.sender) >= value, 'balance too low');

        //     balances[to] += value;
        //     balances[msg.sender] -= value;

        //     emit Transfer(msg.sender, to, value);
        
        // }
        // else
        // {
        //     uint poolAmount = value.mul(POOL_FEE) / 100;
        //     uint taxAmount = value.mul(TAX_FEE) / 100;
        

        //     balances[devWal] += taxAmount;
        //     balances[poolWal] += poolAmount;
        //     balances[to] += value.sub(poolAmount).sub(taxAmount);
        //     balances[msg.sender] -= value;


        //     // balances[to] += value;
        //     // balances[from] -= value;
        //     emit Transfer(from, to, value);
        // }
        // return true;
    }

    function approve(address spender, uint value) public returns(bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
}