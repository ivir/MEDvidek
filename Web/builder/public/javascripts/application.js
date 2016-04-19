// Put your application scripts here
document.addEventListener("deviceready",pripraven);
$(document).ready(function () { pripraven(); });

function pripraven(){
    
}

function loadModule(file){
    var formular,fsource;
    fsource = "/modules/" + file + ".html";
    $.get(fsource, function( data ) {
        var sr = $(data)
        sr.appendTo($(".recipe"));
        return false;
    });
    return false;
}

function createRecipe(){
    var instrukce = $(".recipe");
    var moduly = instrukce.find("div[data-module]");
    var recept = "", checkboxes = "";
    $.each(moduly,function (index, modul){
        recept += modul.attr("data-module") +":\n";
        var parametry = $(modul).find("input,select");
        checkboxes = "";
        $.each(parametry, function (index,parametr){
            if (parametr.tagName == "INPUT") {
                if((parametr.type == "CHECKBOX") || (parametr.type == "checkbox")){
                    //kontrolujeme zdali je name stejny jako predtim;pokud je jiny, vytvarime novou polozku
                    if(checkboxes != parametr.name){
                        //vytvarime novy paramettr
                        recept += "    " + parametr.name + ":\n";
                        checkboxes = parametr.name;
                    }
                    if (parametr.checked) recept += "        - " + parametr.value + "\n";
                } else {
                    if ((parametr.type == "text") || (parametr.type == "TEXT"))
                    recept += "    " + parametr.name + ": \"" + parametr.value + "\"\n";
                }

            } else if (parametr.tagName == "SELECT") {

                vyber = parametr.value;
                recept += "    " + parametr.name + ": " + vyber + "\n";
            }
        });
    });
    alert(recept);
}