/**
 * Created by ivir on 22.5.16.
 */

//pridani metody POP, pro rozumnou praci s prvky u EDIT fce
jQuery.fn.pop = [].pop
//--------

document.addEventListener("deviceready",tableReady);
$(document).ready(function () { tableReady(); });

var lastCall;
var editedValues;
var editPath;

function tableReady(){
    createToolBox();

    repairMenu(document);

    $("tr").mouseout(function (event){
        //$('.toolbox').css({"display": "none","position":"static","left":"100px","top":"50px"});

    });
}
function repairMenu(where){
    var element = where.nextElementSibling;
    if(element == undefined){
        element = where;
    }
    $(element).find("td").click(function (event){
        editValue(this);
    });
    var elem;

    if(element.tagName == "TR"){
        elem = $(element);
    } else {
        elem = $(element).find("tr");
    }

    elem.mouseover(function (event){
        var x,y = 0;
        lastCall = event.currentTarget;
        var rect = event.currentTarget.getBoundingClientRect();
        y = rect.top;
        x = rect.right + 10;
        //x = prvek.position.
        $('.toolbox').css({"display": "block","position":"absolute","left": x +"px","top": y +"px"});

    });
}

function addRow(e){
    var pocetBunek = $(lastCall).find("td").size();
    var row = "<tr>";
    for(var i=0;i<pocetBunek;i++){
        row += "<td></td>";
    }
    row += "</tr>"
    var info = $(lastCall).after(row);
    repairMenu(lastCall);
}

function DelRow(e){
    $(lastCall).remove();
}

function editValue(from){
    editPath = from;
    var edit = $(from).html();
    $(".valuesbox [name='Dvalue']").val(edit);

    var rect = from.getBoundingClientRect();
    y = rect.top;
    x = rect.right + 10;
    //x = prvek.position.
    $('.valuesbox').css({"display": "block","position":"absolute","left": x +"px","top": y +"px"});
    $(".valuesbox [name='Dvalue']").focus();
}

function EditRow(from){
    editedValues = $(lastCall).find("td");
    var first = editedValues.pop();
    editValue(first);
}

function saveEdit(){
    var Dvalue = $(".valuesbox [name='Dvalue']")[0];
    var data = Dvalue.value;
    $(editPath).text(data);
    $(".valuesbox").hide();

    if( (editedValues != undefined) && (editedValues.size()>0)){
        editValue(editedValues.pop());
    }
}

function closeEdit() {
    $(".valuesbox").css("display","none");

    if( (editedValues != undefined) && (editedValues.size()>0)){
        editValue(editedValues.pop());
    }
}

function createToolBox(){
    $("body").append("<div class=\"toolbox\"><a href='#' onclick='addRow(event)'><img src='./images/add.png' /></a><a href='#' onclick='EditRow(event)'><img src='./images/edit.png' /></a><a href='#' onclick='DelRow(event)'><img src='./images/delete.png' /></a></div>");
    $("body").append("<div class=\"valuesbox\"><input type='text' name='Dvalue'/><button onclick='saveEdit(event)'>Uložit</button><button onclick='closeEdit()'>Storno</button></div>");
    $('.toolbox').css("display","none");
}