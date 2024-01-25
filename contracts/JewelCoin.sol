// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract JewelCoin is ERC20, AccessControl {
   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
   address destinatario;

   //mapping che associa il prezzo ad un item
   mapping(uint => uint) private pricesMapping;

   constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply) ERC20(name, symbol) {
      _mint(msg.sender, initialSupply);
      _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
      _setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);

      pricesMapping[0] = 20000000000000000000;
      pricesMapping[1] = 40000000000000000000;
      pricesMapping[2] = 40000000000000000000;
      pricesMapping[3] = 50000000000000000000;
      pricesMapping[4] = 80000000000000000000;
      pricesMapping[5] = 110000000000000000000;
      pricesMapping[6] = 120000000000000000000;
      pricesMapping[7] = 250000000000000000000;

   }

   event Debug(address user, address sender, bytes32 role, bytes32 adminRole, bytes32 senderRole);
   event ChecksoloAdmin(address user);
   event ChecksoloMinters(address user);

   // Modificatore soloAdmin
modifier soloAdmin() {
      // Emette un evento ChecksoloAdmin che registra il mittente
      emit ChecksoloAdmin(msg.sender);
      // Controlla se il mittente è un amministratore
      require(isAdmin(msg.sender), "Restricted to admins");
      // Procede con l'operazione 
      _;
   }

// Modificatore soloMinters
modifier soloMinters() {
      // Emette un evento ChecksoloMinters che registra il mittente
      emit ChecksoloMinters(msg.sender);
      // Controlla se il mittente è un minter
      require(isMinter(msg.sender), "Caller is not a minter");
      // Procede con l'operazione 
      _;
   }

// Funzione per verificare se un account è un amministratore
function isAdmin(address account) public virtual view returns (bool) {
      // Verifica se l'account ha il ruolo di amministratore predefinito
      return hasRole(DEFAULT_ADMIN_ROLE, account);
   }

// Funzione per verificare se un account è un minter
function isMinter(address account) public virtual view returns (bool) {
      // Verifica se l'account ha il ruolo di minter
      return hasRole(MINTER_ROLE, account);
   }

// Funzione di coniazione
function mint(address to, uint256 amount) public soloMinters {
      // Esegue la coniazione
      _mint(to, amount);
    }

// Funzione per aggiungere un nuovo minter
function addMinterRole(address to) public soloAdmin {
      // Emette un evento di debug per registrare l'operazione
      emit Debug(to, msg.sender, MINTER_ROLE, getRoleAdmin(MINTER_ROLE), DEFAULT_ADMIN_ROLE);
      // Assegna il ruolo di minter all'account
      grantRole(MINTER_ROLE, to);
    }

// Funzione per rimuovere il ruolo di minter da un account
function removeMinterRole (address to) public {
      // Rimuove il ruolo di minter dall'account
      renounceRole(MINTER_ROLE, to);
    }

// Funzione per impostare un destinatario
function setDestinatario (address to) public soloAdmin{
      // Imposta il destinatario
      destinatario=to;
    }

   
    // Funzione per pagare un elemento
function payItem(uint256 price, uint itemId) public returns (uint){
      // Controlla che il prezzo memorizzato per l'elemento corrisponda a quello specificato
      require(pricesMapping[itemId]==price);
      // Controlla che il pagamento sia stato eseguito con successo all'indirizzo del gestore della CryptoGym
      require(transfer(0x78f247fe3ccee2AbB9eA8a354f186cE5EB1dF538,price));
      // Restituisce l'ID dell'elemento
      return itemId;
    }

}
