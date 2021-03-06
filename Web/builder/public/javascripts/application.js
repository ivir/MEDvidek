// Put your application scripts here
document.addEventListener("deviceready",pripraven);
$(document).ready(function () { pripraven(); });
var recipe = new Array; // ulozi jednotlive recepty do hashe
var recipes = ""; // textova data pro prime stazeni, prip. upravu
var I=0;
function pripraven(){
    configureCSRF(); //ziskame token pro komunikaci
}

function loadModule(file){ //nacte do stranky formular modulu
    var formular,fsource;

    fsource = "/modules/" + file + ".html";
    $.get(fsource, function( data ) {
        var tg = "<input type=\"hidden\" name=\"__i__\" value=\""+ I + "\" />";
        var head = "<div class='head'>"+ file + "</div>"
        I= I + 1;
        var sr = $(data);
        $(tg).appendTo(sr);
        moduleToolbox(sr);
        $(head).prependTo(sr);
        var t = $(sr).wrap("<div class='module'></div>")

        t.appendTo($(".recipe"));
        return false;
    });
    return false;
}

function createRecipe(){ //vygeneruje uplny recept
    var instrukce = $(".recipe");
    var moduly = instrukce.find("div[data-module]");
    var recept = "", checkboxes = "";
    var postup = "";

    recipe = []; //smazeme predchozi hodnoty
    recipes = "";

    $.each(moduly,function (index, modul){
        recept = "- " + $(modul).attr("data-module") +":\n";
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
                    if ((parametr.type == "file") || (parametr.type == "FILE")) return;
                    //if ((parametr.type == "text") || (parametr.type == "TEXT"))
                    recept += "    " + parametr.name + ": \"" + parametr.value + "\"\n";
                }

            } else if (parametr.tagName == "SELECT") {

                vyber = parametr.value;
                recept += "    " + parametr.name + ": " + vyber + "\n";
            }
        });
        recipe.push(recept);
        recipes += recept;
    });
}

function downloadRecipes(){ //umoznuje stazeni vytvareneho receptu
    download(recipes,"recipe.yml","text/plain");
}

function createStep(part){ // vytvori YAML strukturu pro jeden modul
    var moduly = $("div[data-module=\"" + part +"\"]");
    var recept = "", checkboxes = "";
    $.each(moduly,function (index, modul){
        recept += "- " + $(modul).attr("data-module") +":\n";
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
    return recept;
}

function verify(evt,module,fce){ //odesle recept na server k overeni vysledku

    createRecipe(); //vygenerujeme aktualni recept (pro snizeni nutnosti neustaleho klikani na "Vytvorit recept" v pripade zmeny)
    var recip = "";
    var __I__ = $(evt.target.closest('.module')).find("[name='__i__']");;
    var cislo = __I__.val();
    var k = 0;
    $.each(recipe,function(key,value){
        if(k > cislo){
            return false;
        } else {
            recip += value;
        }
        k++;
    });
    alert(recip);
    //mame pripraven recept k odeslani -> posleme

    var sformData = new FormData();
    sformData.append("recipe",recip);
    sformData.append("authenticity_token",CSRF_TOKEN);

    $.ajax({
        type: "POST",
        url: "/verify",
        data: sformData,
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
        success: function (data) {
            showOutput(data);
        }
    });
}

function loadFiles(){ //vyhledani vsech input[type=file] tagu a nahrani souboru na server;
// pote postupne nastavuje nazvy souboru do pole value pro moznost vygenerovani receptu a opetovneho pouziti.
    var data = $.find("input[type='file']");

    $.each(data,function(k,v){
        var rodic = v.parentElement.parentElement;
        var hodnota = $(rodic).find("input[name='value']");
        var sformData = new FormData();
        var prvek = v.files;
        $.each(prvek, function (key,value){
            sformData.append(key,value);
        });
        sformData.append("authenticity_token",CSRF_TOKEN);
        //zdroj: https://www.w3.org/TR/file-upload/
        var reader = new FileReader();

        // Read file into memory as UTF-16
        /*reader.readAsText(prvek,'UTF-8');
         reader.onload = function (evt){*/
        //var data = evt.target.result;
        $.ajax({
            type: "POST",
            url: "/upload",
            enctype: 'multipart/form-data',
            data: sformData,
            processData: false, // Don't process the files
            contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
            success: function (data) {
                if(hodnota != undefined) hodnota.val(data);
                //findSet(evt.target,module,parameter,data);
            }
        });
    });
}

function prepareUpload(evt, module,parameter){ //fce se jiz nevyuziva
    var kam = evt.target;
    var tlacitko = kam.nextElementSibling;

    $(tlacitko).click(function (evt){ upload(evt,kam,module,parameter)});

}

//funkce se pokusi nalezt v danem modulu parametr a nastavi jej na hodnotu value
function findSet(start,module,parameter,value){
    var zacatek = start.parentElement;
    while( (zacatek != undefined)){
        if( zacatek.hasAttribute("data-module")){
            var modu = zacatek.getAttribute("data-module");
            if (modu.localeCompare(module) == 0){
                break;
            }
        }
        if( typeof zacatek.previousElementSibling !== undefined){
            zacatek = zacatek.previousElementSibling;
        } else {
            zacatek = zacatek.parentElement;
        }
    }
    if (zacatek == undefined){
        //nepovedlo se najit, zkusime jQuery
        zacatek = $(start).closest("[data-module='" + module + "']");
    }

    var hodnota = $(zacatek).find("[name='" + parameter + "']");
    hodnota.val(value);
}

function upload(evt,from,module,parameter){ // fce pro nahravani dat
    var sformData = new FormData();
    var prvek = from.files;
    $.each(prvek, function (key,value){
        sformData.append(key,value);
    });
    sformData.append("authenticity_token",CSRF_TOKEN);
    //zdroj: https://www.w3.org/TR/file-upload/
    var reader = new FileReader();

    // Read file into memory as UTF-16
    /*reader.readAsText(prvek,'UTF-8');
    reader.onload = function (evt){*/
        //var data = evt.target.result;
        $.ajax({
            type: "POST",
            url: "/upload",
            enctype: 'multipart/form-data',
            data: sformData,
            processData: false, // Don't process the files
            contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
            success: function (data) {
                findSet(evt.target,module,parameter,data);
            }
        });
    //};
    /*formData.append();
    $.post("/upload",formData,function(data){
        var path = $(module);
        path.find('input[name="' + parameter + '"]').val(data);
    }
    );*/

}

function addCol(name, evt){ //pridani polozky typu checkbox ve spravnem tvaru pro YAML
    var place = $(evt.target).parent();
    var cols = $(place).find("ul");
    var col = $(place).find("[name='scolumn']").val();
    var val = $(place).find("[name='srename']").val();
    var rs = col;
    if(val != ""){
        rs = col + ": " + val;
    }
    var result = "<li><input type=\"checkbox\" name='"+ name + "' value='" + rs +"' checked />"+ rs + "</li>";
    cols.append(result);
}

function showOutput(data){ //zobrazeni dat
    var result = JSON.parse(data).result;
    var objectType = typeof(result);
    if ( objectType == 'object') {
        var resu = ConvertJsonToTable(result,"result",null,null);
        $('.DemoView').html(resu);
    } else {
        $('.DemoView').text(result);
    }
}

function moduleToolbox(module){ //vlozeni menu pro manipulaci
    $("<div class=\"toolbox\"><a href='#' onclick='UpModule(event)'><img src='./images/up.png' /></a><a href='#' onclick='DownModule(event)'><img src='./images/down.png' /></a><a href='#' onclick='DelModule(event)'><img src='./images/delete.png' /></a></div>").appendTo(module);
}

function UpModule(evt){ //posunuti prvki vzhuru
    var modul = getModule(evt);
    if(modul == undefined){
        alert("Nedefinovano");
    }

    var dalsi = modul.previousElementSibling;

    if(dalsi == undefined) return; //nemame dalsi prvek pro nahrazeni

    var cislo = $(modul).find("[name='__i__']");
    cislo.val(parseInt(cislo.val())-1);

    cislo = $(dalsi).find("[name='__i__']");
    cislo.val(parseInt(cislo.val())+1);

    var tmp = $(modul).detach();
    $(tmp).insertBefore(dalsi);
}

function DownModule(evt){ //posun modulu dolu
    var modul = getModule(evt);
    var dalsi = modul.nextElementSibling;

    if(dalsi == undefined) return; //nemame dalsi prvek pro nahrazeni

    var cislo = $(modul).find("[name='__i__']");
    cislo.val(parseInt(cislo.val())+1);

    cislo = $(dalsi).find("[name='__i__']");
    cislo.val(parseInt(cislo.val())-1);

    var tmp = $(modul).detach();
    $(tmp).insertAfter(dalsi);
}

function DelModule(evt){ //smazani modulu
    var modul = getModule(evt);
    var cislo = $(modul).find("[name='__i__']").val(); //ziskame cislo odkud musime ostatni snizit
    if(modul != undefined){
        modul.remove();
        var poradi = $.find("[name='__i__']");
        $.each(poradi,function (k,value){
           if(k >= cislo){
               $(value).val((parseInt($(value).val())-1));
           }
        });
        I = I - 1;
    }
}

function getModule(evt){ //vyhledani zakladniho tagu obalujici veskera data modulu
    var zacatek = evt.currentTarget.parentElement;
    var modu = undefined;
    while( (zacatek != undefined)){
        if( $(zacatek).hasClass("module")){
            modu = zacatek;
            return modu;
        }
        if( zacatek.previousElementSibling != null){
            zacatek = zacatek.previousElementSibling;
        } else {
            zacatek = zacatek.parentElement;
        }
    }
    return modu;
}

//------ Zpracovani process -----
function processRecipe(evt){
    var data = $.find("input[type='file']");

    $.each(data,function(k,v){
        var rodic = v.parentElement.parentElement;
        var hodnota = $(rodic).find("input[name='value']");
        var sformData = new FormData();
        var prvek = v.files;
        $.each(prvek, function (key,value){
            sformData.append(key,value);
        });
        sformData.append("authenticity_token",CSRF_TOKEN);
        //zdroj: https://www.w3.org/TR/file-upload/
        var reader = new FileReader();

        // Read file into memory as UTF-16
        /*reader.readAsText(prvek,'UTF-8');
         reader.onload = function (evt){*/
        //var data = evt.target.result;
        $.ajax({
            type: "POST",
            url: "/upload",
            enctype: 'multipart/form-data',
            data: sformData,
            processData: false, // Don't process the files
            contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
            success: function (data) {
                var fl = $.find("input[name='recipe']");
                var nms = ($(fl).val()).split("\\");
                if(nms.length == 0){
                    return
                } else {
                    nms = nms[nms.length-1];
                }
                alert(nms);
                $.get("/process/" + nms, function (data){location.reload(true)});
                //findSet(evt.target,module,parameter,data);
            }
        });
    });
}

function appendFile(evt){
    var div = $.find(".form");
    $("<div><input type=\"file\" name=\"data[]\" /></div>").appendTo(div);
}


//-------------

//download.js v4.1, by dandavis; 2008-2015. [CCBY2] see http://danml.com/download.html for tests/usage
// v1 landed a FF+Chrome compat way of downloading strings to local un-named files, upgraded to use a hidden frame and optional mime
// v2 added named files via a[download], msSaveBlob, IE (10+) support, and window.URL support for larger+faster saves than dataURLs
// v3 added dataURL and Blob Input, bind-toggle arity, and legacy dataURL fallback was improved with force-download mime and base64 support. 3.1 improved safari handling.
// v4 adds AMD/UMD, commonJS, and plain browser support
// v4.1 adds url download capability via solo URL argument (same domain/CORS only)
// https://github.com/rndme/download

(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define([], factory);
    } else if (typeof exports === 'object') {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        module.exports = factory();
    } else {
        // Browser globals (root is window)
        root.download = factory();
    }
}(this, function () {

    return function download(data, strFileName, strMimeType) {

        var self = window, // this script is only for browsers anyway...
            u = "application/octet-stream", // this default mime also triggers iframe downloads
            m = strMimeType || u,
            x = data,
            url = !strFileName && !strMimeType && x,
            D = document,
            a = D.createElement("a"),
            z = function(a){return String(a);},
            B = (self.Blob || self.MozBlob || self.WebKitBlob || z),
            fn = strFileName || "download",
            blob,
            fr,
            ajax;
        B= B.call ? B.bind(self) : Blob ;


        if(String(this)==="true"){ //reverse arguments, allowing download.bind(true, "text/xml", "export.xml") to act as a callback
            x=[x, m];
            m=x[0];
            x=x[1];
        }


        if(url && url.length< 2048){
            fn = url.split("/").pop().split("?")[0];
            a.href = url; // assign href prop to temp anchor
            if(a.href.indexOf(url) !== -1){ // if the browser determines that it's a potentially valid url path:
                var ajax=new XMLHttpRequest();
                ajax.open( "GET", url, true);
                ajax.responseType = 'blob';
                ajax.onload= function(e){
                    download(e.target.response, fn, u);
                };
                ajax.send();
                return ajax;
            } // end if valid url?
        } // end if url?



        //go ahead and download dataURLs right away
        if(/^data\:[\w+\-]+\/[\w+\-]+[,;]/.test(x)){
            return navigator.msSaveBlob ?  // IE10 can't do a[download], only Blobs:
                navigator.msSaveBlob(d2b(x), fn) :
                saver(x) ; // everyone else can save dataURLs un-processed
        }//end if dataURL passed?

        blob = x instanceof B ?
            x :
            new B([x], {type: m}) ;


        function d2b(u) {
            var p= u.split(/[:;,]/),
                t= p[1],
                dec= p[2] == "base64" ? atob : decodeURIComponent,
                bin= dec(p.pop()),
                mx= bin.length,
                i= 0,
                uia= new Uint8Array(mx);

            for(i;i<mx;++i) uia[i]= bin.charCodeAt(i);

            return new B([uia], {type: t});
        }

        function saver(url, winMode){

            if ('download' in a) { //html5 A[download]
                a.href = url;
                a.setAttribute("download", fn);
                a.className = "download-js-link";
                a.innerHTML = "downloading...";
                D.body.appendChild(a);
                setTimeout(function() {
                    a.click();
                    D.body.removeChild(a);
                    if(winMode===true){setTimeout(function(){ self.URL.revokeObjectURL(a.href);}, 250 );}
                }, 66);
                return true;
            }

            if(typeof safari !=="undefined" ){ // handle non-a[download] safari as best we can:
                url="data:"+url.replace(/^data:([\w\/\-\+]+)/, u);
                if(!window.open(url)){ // popup blocked, offer direct download:
                    if(confirm("Displaying New Document\n\nUse Save As... to download, then click back to return to this page.")){ location.href=url; }
                }
                return true;
            }

            //do iframe dataURL download (old ch+FF):
            var f = D.createElement("iframe");
            D.body.appendChild(f);

            if(!winMode){ // force a mime that will download:
                url="data:"+url.replace(/^data:([\w\/\-\+]+)/, u);
            }
            f.src=url;
            setTimeout(function(){ D.body.removeChild(f); }, 333);

        }//end saver




        if (navigator.msSaveBlob) { // IE10+ : (has Blob, but not a[download] or URL)
            return navigator.msSaveBlob(blob, fn);
        }

        if(self.URL){ // simple fast and modern way using Blob and URL:
            saver(self.URL.createObjectURL(blob), true);
        }else{
            // handle non-Blob()+non-URL browsers:
            if(typeof blob === "string" || blob.constructor===z ){
                try{
                    return saver( "data:" +  m   + ";base64,"  +  self.btoa(blob)  );
                }catch(y){
                    return saver( "data:" +  m   + "," + encodeURIComponent(blob)  );
                }
            }

            // Blob but not URL:
            fr=new FileReader();
            fr.onload=function(e){
                saver(this.result);
            };
            fr.readAsDataURL(blob);
        }
        return true;
    }; /* end download() */
}));
//-----------------------------

//------ zdroj: http://www.randomactsofsentience.com/2013/06/the-dreaded-attack-prevented-by.html
// osetreni CSRF - ziskani tokenu pro overeni opravnenosti pozadavku

var CSRF_TOKEN = '';

function configureCSRF() {
    $.get('/csrf_token','', function (data, textStatus, jqXHR) {
            CSRF_TOKEN = data.csrf;
        });
}
