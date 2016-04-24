// Put your application scripts here
document.addEventListener("deviceready",pripraven);
$(document).ready(function () { pripraven(); });
var recipe = new Array; // ulozi jednotlive recepty do hashe
var recipes = ""; // textova data pro prime stazeni, prip. upravu
var I=0;
function pripraven(){
    configureCSRF(); //ziskame token pro komunikaci
}

function loadModule(file){
    var formular,fsource;

    fsource = "/modules/" + file + ".html";
    $.get(fsource, function( data ) {
        var tg = "<input type=\"hidden\" name=\"__i__\" value=\""+ I + "\" />";
        I= I + 1;
        var sr = $(data);
        $(tg).appendTo(sr);
        var t = $(sr).wrap("<div class='module'></div>")
        t.appendTo($(".recipe"));
        return false;
    });
    return false;
}

function createRecipe(){
    var instrukce = $(".recipe");
    var moduly = instrukce.find("div[data-module]");
    var recept = "", checkboxes = "";
    var postup = "";

    recipe = []; //smazeme predchozi hodnoty
    recipes = "";

    $.each(moduly,function (index, modul){
        recept = $(modul).attr("data-module") +":\n";
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
        recipe.push(recept);
        recipes += recept;
    });
}

function downloadRecipes(){
    download(recipes,"recipe.yml","text/plain");
}

function createStep(part){
    var moduly = $("div[data-module=\"" + part +"\"]");
    var recept = "", checkboxes = "";
    $.each(moduly,function (index, modul){
        recept += $(modul).attr("data-module") +":\n";
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

function verify(evt,module,fce){
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
    $.post("/verify",recip,function (data){
        fce(data);
    },"json");
}

function prepareUpload(evt, module,parameter){
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

function upload(evt,from,module,parameter){
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
