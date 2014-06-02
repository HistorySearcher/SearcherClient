/**
 * Created with JetBrains WebStorm.
 * User: Administrator
 * Date: 14. 1. 9
 * Time: 오후 11:42
 * To change this template use File | Settings | File Templates.
 */
var xhr=null;
function sendRequest(url,param,callback,method,async){

    method(method.toLowerCase()=="get")?"GET":"POST";
    param=(param==null||param=="")?null:param;
    if(method=="GET"&&param!=null){
        url=url+"?"+param;
    }

    xhr.onreadystatechange=callback;
    xhr.open(method,url,async); //요청정보 지정
    xhr.setRequestHeader("Content-Type","application/x-www-form-urlencodeed")

    xhr.send((method=="POST")?param:null);

}