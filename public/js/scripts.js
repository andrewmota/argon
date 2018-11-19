$(document).ready(function() {
    $("input[name='tipoUsuario']").on("change", function() {
        if($(this).val() == "empresa")
            $(".tipoEmpresa").show();
        else
            $(".tipoEmpresa").hide();
    });

    if($("input[name='tipoUsuario']").val() == "empresa")
        $(".tipoEmpresa").show();
    else
        $(".tipoEmpresa").hide();

});

$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results == null)
       return null;

    return decodeURI(results[1]) || 0;
}