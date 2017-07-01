pragma solidity ^0.4.0;
contract Main  {

    /*/
     *  Contract fields
    /*/
    address private owner;
    mapping (address => address) private dealStorage;
    //todo смарт контракт certificationCenter
    //не забудь про модификаторы
    //проверить есть ли такой пользователь в нашей системе

    /*/
     *  Events
    /*/
    event LogetDealAddress(address pk_sender, address smartDeal);
    event LogResultCreateSmartDeal(address pk_sender, address smartDeal);

    /*/
     *  Public functions
    /*/

    // @dev Returns address DealsmartContract,which was created by the sender
    //if return value == 0x0 it means we have not inicialize deal
    // @param _object_id Object id for presale tokens


    //todo должен быть модификатор isowner
    function getAddress(address _senderDoc)constant returns (address) {
       LogetDealAddress(_senderDoc,  dealStorage[_senderDoc]);
        return dealStorage[_senderDoc];
    }

    // @dev Returns address cmartContract
    // @param _docHash hash document of real Contract
    // @param sender - the counterparty who send document
    // @param _recipient the counterparty who shall sign the document

    //todo можно сделать проверку типо есть ли отправитель в другом смартконтракте
    //todo должен быть модификатор isowner
    function createSmartDeal(string _docHash,string _url,address _sender,address _recipient) returns (address) {
         //todo проверка есть ли такой id и хэш сделать модификатором

         dealStorage[_sender] = new SmartDeal(_docHash,_url, _sender, _recipient);
       //to do логер
      // check create contract
        return dealStorage[_sender];
    }
        // modifiers
    modifier isOwner {
        if (msg.sender == owner)
        _;
    }

}

contract SmartDeal {
    /*/
     *  Contract fields
    /*/
    address public  recipient;
    address public sender;
    string public docHash;
    string public url="";
    //todo сделать enum
    bool public isStatus=false;
    SetSign public setSign;

    /*/
     *  Structs
    /*/
     struct SetSign {
        bool isSignSender;
        bool isRecipient;
    }
    /*/
     *  Public functions
    /*/
    function SmartDeal(string _docHash,string _url,address _sender,address _recipient) {
        url = _url;
        recipient=_recipient;
        docHash = _docHash;
        sender = _sender;
        setSign.isSignSender = false;
        setSign.isRecipient = false;
    }


    //todo не предусмотренно про передоговоры
    function signDoc(string _docHash) returns (bool){
        //todo проверить хэш документа
        if(sha3(docHash) ==sha3(_docHash)){
        //todo логирование
        //check it is sender
        if(msg.sender==sender)
        {
            setSign.isSignSender=true;
        }
        if(msg.sender==recipient)
        {
            setSign.isRecipient=true;
        }}
        return checkStatus();
    }
    //todo должна быть call!!!!!!!
    function checkStatus() returns (bool) {
        if(setSign.isSignSender || setSign.isRecipient)
        {
            return isStatus=false;
        }
        return false;
    }
    //todo модификатор isSender isRecipient


}
contract SertificationCentr {
    /*/
     *  Contract fields
    /*/
    mapping (address => InfoUser) private userStorage;
    uint countUser;
    /*/
     *  Events
    /*/
    event LogeUserInfo(address,string,string);
    /*/
     *  Structs
    /*/
    struct  InfoUser {
        string  telegrId;
        string name;
        string definition;
    }
    /*/
     *  Public functions
    /*/
    function getInfo(address _user) constant returns (string,string,string){
        //todo проверить на null
        InfoUser infoUserStruct = userStorage[_user];
        LogeUserInfo(_user,infoUserStruct.telegrId,infoUserStruct.name);
        return (infoUserStruct.telegrId,infoUserStruct.name,infoUserStruct.definition);
    }
    //todo регистрация пользователя
    //todo только владелец
    function registrationUser(address _userAddr,string telegrId,
                        string name,string definition){

    }
    //todo проверка есть ли польхователь в системе
    //проверка количества пользователей
    function checkCountUser(uint _count) constant returns(bool){
        if(countUser==_count){
            return true;
    }
        return false;
    }

}
