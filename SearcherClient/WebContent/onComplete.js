

function urlcut(){
    //  alert(document.URL);
    var urls=document.URL;
    var strArray=urls.split('?');
    // alert("urlcut     "+strArray[0]);

    return strArray[0];
}
chrome.extension.sendMessage({
    action: "geturlcut",
    source: urlcut()
});

function titles()
{
    var titlea = document.getElementsByTagName('title')[0].innerHTML;
  //  alert("title   on  "+titlea);

    return titlea;

}
chrome.extension.sendMessage({
    action: "gettitle",
    source: titles()
});

function urls(){
 //   alert(document.URL);
    return document.URL;
}
chrome.extension.sendMessage({
    action: "geturl",
    source: urls()
});
function inId(skiparr, val){
    for(var i= 0,len = skiparr.length; i < len ; i++){
        if(skiparr[i] === val) return true;
    }
    return false;
}

//var skip = ['STYLE','SCRIPT','OBJECT','FRAME','EMBED','LI','UL']; //skip Element 지정

var skip = ['STYLE','SCRIPT','OBJECT','EMBED','LI','UL','IMG'];
var context="";



function inArray(arr, val) {

    for (var i = 0, len = arr.length; i < len; i++) {
        if(arr[i] === val) return true;
    }
    return false;
}


function getTextNodes(ele) {
    var cNodes = ele.childNodes;
    for (var i = 0, len = cNodes.length; i < len; i++) {


        if(cNodes.item(i)===document.getElementById('left')){
            continue;
        }
        else if(cNodes.item(i)===document.getElementById('left-area')){
            continue;
        }
        else if(cNodes.item(i)===document.getElementById('right-area')){
            continue;
        }

        else if(cNodes.item(i)===document.getElementById('bottom-list')){
            continue;
        }
        else if(cNodes.item(i)===document.getElementById('blog-tag')){
            continue;
        }
        else if(cNodes.item(i)===document.getElementById('spiLayer1')){
            continue;
        }
        else if(cNodes.item(i-1)===document.getElementById('content')&&i!==0){
            break;
        }
        else if(cNodes.item(i)===document.getElementById('avoid_facebook_crawling_layer')){
            break;
        }
        else if(cNodes.item(i-1)===document.getElementById('view_cnt')&&i!==0){
            break;
        }
        else if(cNodes.item(i)===document.getElementById('section_sidebar1')){
            break;
        }
        else if(cNodes.item(i)===document.getElementById('lft_top_adplus')){
            break;
        }
        else if(cNodes.item(i)===document.getElementById('right_top_ad')){
            break;
        }
        else if(cNodes.item(i)===document.getElementById('paging')){
            break;
        }



        if (cNodes[i].nodeType === 1) {

            if (inArray(skip, cNodes[i].nodeName)) { //skip Element 확인
                continue;
            }

            else {
                arguments.callee(cNodes[i]);
            }
        }
        if (cNodes[i].nodeType === 3 && /\S/.test(cNodes[i].nodeValue)) { //WhiteSpace 확인
            //textNodes.push(cNodes[i].nodeValue);
            context+=cNodes[i].nodeValue;
        }
    }

    return context;
}

chrome.extension.sendMessage({
    action: "getcontext",
    source: getTextNodes(document)
});
/*
       var la;
$(document).ready(function(){

        if(localStorage.getItem("username")!== null) {

            // 웹 스토리지 지원 가능
            //localStorage.clear();
            //alert("if  "+localStorage.getItem("username"));
            la=localStorage.getItem("username");
            alert("on   "+localStorage.getItem("username"));
           // alert("on  if    "+localtest);

        }
//        else {
//            localStorage.setItem("username",localtest );
//            //   localStorage.clear();
//            alert("on  else   "+localStorage.getItem("username"));
//            // localtest = localStorage.getItem("username");
//            // return localStorage.getItem("username");
//
//        }

        var strArray=urls().split('?');
        if((urls()!=="http://112.108.40.87:8080/Lucene4.3-Server-rev02/index.jsp")&&(strArray[0]!=="http://search.zum.com/search.zum")&&(strArray[0]!=="http://search.daum.net/nate")&&(strArray[0]!=="https://www.google.co.kr/search")&&(strArray[0]!=="https://www.google.co.kr/webhp")&&(strArray[0]!=="http://search.naver.com/search.naver")&&(strArray[0]!=="http://search.daum.net/search")){


            jQuery.ajax({
                type:"POST",
                url:"http://112.108.40.87:8080/Lucene4.3-Server-rev02/indexWrite.jsp",
                //data: {user:"kwonhak",content: getTextNodes(document.body),title:,url:urla},
                data: {user:localStorage.getItem("username"),content:getTextNodes(document),title:titles(),url:urls()},
                // data: {user:"dooroomee",content:DOMtoString(document.body) ,title:titles(),url:urls()},


                success:function(data){
                    //alert("success"+data);
                },
                complete:function(data){
                    // alert("barely success"+data);
                },
                error:function(data,error){
                    alert("에러발생"+data+error.status);
                }
            });
        } //if
    }
);


*/
//alert(getTextNodes(document.body));

function extract_Title()
{
    var title, encoded_title, items, max_matching_rate=0;

    //1. 뉴스 기사 웹페이지에서 title 태그의 엘리먼트를 가져온다.
    title = document.getElementById("Article").querySelectorAll("title");

    // 2. 특수문자 쌍따옴표를 기본 쌍따옴표로 치환한다.
    // 예시 뉴스기사 중앙일보 http://joongang.joins.com/article/886/12941886.html?ctg=1300
    title = title[0].innerHTML.replace('”','"');
    title = title.replace('”','"');

    //console.log("Title 태그값: " + title);

    // 3. URI 주소 방식으로 인코딩 한다.
    encoded_title = encodeURI(title);

    // 4. 뉴스 기사 HTML 웹페이지에서 h1, h2, h3, h4, h5, h6 태그값들을 모두 가져온다.
    items = document.querySelectorAll("h1, h2, h3, h4, h5, h6, span");	//span for 매일경제

    for(var i=0; i<items.length; i++)
    {
        // 5. 4번 과정에서 가져온 태그 값에서 특수문자 쌍따옴표를 기본 쌍따옴표로 치환한다.
        var filtered_item = items[i].innerHTML.replace('”','"');
        filtered_item = filtered_item.replace('”','"');

        // 6. 문자열 앞뒤 공백을 제거 한다.
        filtered_item = filtered_item.replace(/^\s*|\s*$/g, '');

        //console.log("Items 태그값: "+filtered_item);

        // 7.URI 주소 방식으로 인코딩 한다.
        var encoded_item = encodeURI(filtered_item);

        // 8-1. 3번 과정과의 값과 7번 과정의 값을 비교한다.
        if(encoded_title.match(encoded_item)&&(items[i].innerHTML.length > 1))
        {
            //현재 index의 매칭율
            var current_matching_rate;

            //8-2. 3번 과정의 태그 값과 7번의 태그들의 값을 비교하여 일치율을 조사합니다.
            if(encoded_item.length >= encoded_title.length){
                current_matching_rate = encoded_title.length/encoded_item.length;
            }else{
                current_matching_rate = encoded_item.length/encoded_title.length;
            }

            //console.log("현재값 매칭율: "+current_matching_rate);

            //9. 일치율이 가장 높은 태그가 기사 제목이 됩니다.
            if(current_matching_rate >= max_matching_rate)
            {
                max_matching_rate = current_matching_rate;
                title = items[i].innerHTML;
            }
        }
        else{
            //console.log("Miss Matching :" + items[i].innerHTML + '|'+items[i].innerHTML.length);
        }
    }

    console.log("extract_Title(): 추출된 제목의 매칭율: "+ max_matching_rate);
    console.log("extract_Title(): 추출된 제목: " + title);

//    document.getElementById("Play_Title").innerHTML ='';
//    document.getElementById("Play_Title").innerHTML += '<h3>' + title + '</h3>';
}