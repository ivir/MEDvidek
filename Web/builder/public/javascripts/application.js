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
    var moduly = instrukce.find("div");
    var recept = "";
    $.each(moduly,function (index, modul){
        recept += modul.className +":\n";
        alert(recept);
        var parametry = $(modul).find("input,select");
        $.each(parametry, function (index,parametr){
            recept += "\t" + parametr.name + ":" + parametr.value + "\n";
        });
    });
    alert(recept);
}