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

$("a.removeHabilidade").on("click", function() {
    let $elPai = $(this).closest("div.habilidade");
    let idHabilidade = $elPai.find("input[name='idHabilidade']").val();
    let usuarioId = $("input[name='idUsuario']").val();

    $.ajax({
        type: "POST",
        url: "/habilidades/deletar",
        data: {
            habilidade: idHabilidade,
            usuario: usuarioId
        },
        success: function(msg){
            window.location.reload()
        }
    });
});

$("a.adicionaHabilidade").on("click", function() {
    let $elPai = $(this).closest("div.habilidade");
    let nome = $elPai.find("input[name='nome']").val();
    let tempo = $elPai.find("input[name='tempo']:checked").val();
    let usuarioId = $("input[name='idUsuario']").val();
    
    if(nome == "") {
        alert("Preencha o nome da habilidade!");
        return;
    }

    $.ajax({
        type: "POST",
        url: "/habilidades/cadastro",
        data: {
            nome: nome, 
            tempo: tempo,
            usuario: usuarioId
        },
        success: function(msg){
            window.location.reload()
        }
    });
});