/**
 * Created by ivir on 22.5.16.
 */

document.addEventListener("deviceready",tableReady);
$(document).ready(function () { tableReady(); });

var lastCall;

function tableReady(){
    $("td").click(function (event){
        var value = prompt("Value:",$(this).html());
        $(this).text(value);
        $(this).css("font-weight","bold");
    });
}

function editValue(from){
    
}