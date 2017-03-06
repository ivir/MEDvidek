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