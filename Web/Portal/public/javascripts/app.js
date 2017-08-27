/**
 * Created by ivir on 14.1.17.
 */
function getPack(evt){ //vyhledani zakladniho tagu obalujici file
    var zacatek = evt.currentTarget.parentElement;
    var modu = undefined;
    while( (zacatek != undefined)){
        if( $(zacatek).hasClass("files")){
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

function addFile(evt){
    var div = getPack(evt);
    num = ($.find("input[type='file']")).length;
    data = '<div class="input-group">' +
        '<span class="input-group-addon" id="basic-addon1">Soubor pro zpracování (file' + (num+1) + ')</span>' +
        '<input type="file" name="data[]" class="form-control" placeholder="Nahravana data" aria-describedby="basic-addon1"></div>';
    $(data).appendTo(div);
}

function process(evt){
    return true;
}
document.addEventListener("deviceready",configureCSRF);
$(document).ready(function () { configureCSRF() });
var CSRF_TOKEN = '';

function configureCSRF() {
    $.get('/build/csrf_token','', function (data, textStatus, jqXHR) {
        CSRF_TOKEN = data.csrf;
    });
}

function sim_del(evt){
    var sformData = new FormData();
    var rodic = evt.target.parentElement.parentElement;
    var hodnota = $(rodic).find("td");
    sformData.append("sim",hodnota[1].innerHTML);
    sformData.append("authenticity_token",CSRF_TOKEN);
    $.ajax({
        type: "POST",
        url: "/sim/delete",
        data: sformData,
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
        success: function (data) {
                //odstranime radek
                $.removeChild(rodic);
        }
    });
    return false;
}

function js_post(path,val,ret_func){
    var sformData = new FormData();
    sformData.append("authenticity_token",CSRF_TOKEN);
    sformData.append("data",val);
    $.ajax({
        type: "POST",
        url: path,
        data: sformData,
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
        success: function (data) {
            //odstranime radek
            if(ret_func != null){
                ret_func(data);
            }
        }
    });
    return false;
}

function js_get(path,val,ret_func){
    var sformData = new FormData();
    sformData.append("authenticity_token",CSRF_TOKEN);
    sformData.append("data",val);
    $.ajax({
        type: "GET",
        url: path,
        data: sformData,
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
        success: function (data) {
            //odstranime radek
            if(ret_func != null){
                ret_func(data);
            }
        }
    });
    return false;
}

function sendPOST(path,source,pageReload, ret_func){

    var sformData = new FormData();
    sformData.append("authenticity_token",CSRF_TOKEN);

    var rodic = source.target.parentElement.parentElement;
    var parametry = $(rodic).find("input,select");

    checkboxes = "";
    val = Array();
    $.each(parametry, function (index,parametr){
        if (parametr.tagName == "INPUT") {
            if((parametr.type == "CHECKBOX") || (parametr.type == "checkbox")){
                //kontrolujeme zdali je name stejny jako predtim;pokud je jiny, vytvarime novou polozku
                if(checkboxes != parametr.name){
                    //vytvarime novy paramettr
                    if(val.count != 0){
                        sformData.append(checkboxes,val);
                        val.clear();
                    }
                    checkboxes = parametr.name;
                }
                if (parametr.checked) val.append(parametr.value);
            } else {
                if(checkboxes != ""){
                    sformData.append(checkboxes,val);
                    val.clear();
                    checkboxes = "";
                }
                sformData.append(parametr.name, parametr.value);
            }

        } else if (parametr.tagName == "SELECT") {
            vyber = Array();
            var options = parametr.options;
            var opt;

            for (var i=0, iLen=options.length; i<iLen; i++) {
                opt = options[i];

                if (opt.selected) {
                    vyber.push(opt.value || opt.text);
                }
            }
            data = vyber.join(",");
            sformData.append(parametr.name, data);
        }
    });

    $.ajax({
        type: "POST",
        url: path,
        data: sformData,
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request (zdroj: http://abandon.ie/notebook/simple-file-uploads-using-jquery-ajax)
        success: function (data) {
            //odstranime radek
            if(ret_func != null){
                ret_func(data);
            }
        }
    });
    return false;
}

function sim_add(evt){

}