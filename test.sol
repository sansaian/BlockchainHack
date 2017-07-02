pragma solidity ^0.4.0;
contract Main  {

    /*/
     *  Contract fields
    /*/
    address private owner;
    mapping (address => address) private dealStorage;
    address public sertCentrAdress;

    /*/
     *  Events
    /*/
    event LogetDealAddress(address pk_sender, address smartDeal);
    event LogResultCreateSmartDeal(address pk_sender, address smartDeal);
    event LogAddress(address);

    /*/
     *  Сonstructor
    /*/
    function Main(){
        owner = msg.sender;
    }

    /*/
     *  Public functions
    /*/
    // @dev Returns address DealsmartContract,which was created by the sender
    //if return value == 0x0 it means we have not inicialize deal
    // @param _object_id Object id for presale tokens
    function getAddress(address _senderDoc) isOwner constant returns (address) {
       LogetDealAddress(_senderDoc,  dealStorage[_senderDoc]);
        return dealStorage[_senderDoc];
    }

    // @dev Returns address cmartContract
    // @param _docHash hash document of real Contract
    // @param sender  the counterparty who send document
    // @param _recipient the counterparty who shall sign the document
    function createSmartDeal(string _docHash,string _url,address _sender,address _recipient)
    isOwner returns (address) {
         if(sertCentrAdress!= 0x0){
             SertificationCentr sertCentr = SertificationCentr(sertCentrAdress);
             if(sertCentr.checkUser(_sender))
                dealStorage[_sender] = new SmartDeal(_docHash,_url, _sender, _recipient);

      }
        return dealStorage[_sender];
    }

    // @dev create SmartContract SertificationCentr and return its address
    function createSertificationCentr() isOwner returns(address){
        sertCentrAdress = new SertificationCentr(owner);
        LogAddress(sertCentrAdress);
        return sertCentrAdress;
    }

    /*/
     *  Modifiers
    /*/
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
     *  Events
    /*/
    event LogetDealAddress(bool);

    /*/
     *  Сonstructor
    /*/
    function SmartDeal(string _docHash,string _url,address _sender,address _recipient) {
        url = _url;
        recipient=_recipient;
        docHash = _docHash;
        sender = _sender;
        setSign.isSignSender = false;
        setSign.isRecipient = false;
    }


    /*/
     *  Public functions
    /*/
    // @dev the counterparty sign docs
    // @param _docHash hash document of real Contract
    function signDoc(string _docHash) isSenderAndisRecipient returns (bool){
        if(sha3(docHash) ==sha3(_docHash)){

        if(msg.sender==sender)
        {
            setSign.isSignSender=true;
        }
        if(msg.sender==recipient)
        {
            setSign.isRecipient=true;
        }}
        bool result = checkStatus();
        LogetDealAddress(result);
        return result;
    }

    function checkStatus() returns (bool) {
        if(setSign.isSignSender && setSign.isRecipient)
        {
            return isStatus=true;
        }
        return false;
    }

    /*/
     *  Modifiers
    /*/
    modifier isSenderAndisRecipient {
        if (msg.sender == recipient ||msg.sender == sender)
        _;
    }

}
contract SertificationCentr {

    /*/
     *  Contract fields
    /*/
    mapping (address => InfoUser) private userStorage;
    uint countUser;
    address private owner;

    /*/
     *  Events
    /*/
    event LogeUserInfo(address,string,string);
    event LogCheckUSer(address);
    event LigIsSuccessOperation(bool);

    /*/
     *  Structs
    /*/
    struct  InfoUser {
        address userAddress;
        string  telegrId;
        string name;
        string descriptions;
    }

    /*/
     *  Сonstructor
    /*/
    function SertificationCentr(address _owner){
        owner = _owner;
    }

    /*/
     *  Public functions
    /*/
    // @dev get iniformation about account
    // @param _user  user's address
    function getInfo(address _user) constant returns (string,string,string){
        //todo проверить на null
        InfoUser infoUserStruct = userStorage[_user];
        LogeUserInfo(_user,infoUserStruct.telegrId,infoUserStruct.name);
        return (infoUserStruct.telegrId,infoUserStruct.name,infoUserStruct.descriptions);
    }

    // @dev registration user(or organization) in our system
    // @param _userAddr  user's address
    // @param _telegrId  id in telegram or another message
    // @param _name  name of organization
    // @param _description  another information
    function registrationUser(address _userAddr,string _telegrId,
                        string _name,string _description) isOwner{
     //todo логирование
     // todo проверить на не пустые поля
     userStorage[_userAddr].userAddress = _userAddr;
     userStorage[_userAddr].telegrId = _telegrId;
     userStorage[_userAddr].name = _name;
     userStorage[_userAddr].descriptions = _description;
     LigIsSuccessOperation(true);
    }

    // @dev the function checks whether a user in our system
    // @param _user  user's address
    function checkUser(address _user)returns (bool){
        InfoUser infoUserStruct = userStorage[_user];
        if(infoUserStruct.userAddress!=0x0){
            return true;
        }
        return false;
    }

    modifier isOwner {
        if (msg.sender == owner)
        _;
    }
}