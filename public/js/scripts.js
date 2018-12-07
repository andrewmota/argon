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

    if($("input[name='idUsuario']").length > 0) {
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
    } else if($("input[name='idVaga']").length > 0) {
        let vagaId = $("input[name='idVaga']").val();
        $.ajax({
            type: "POST",
            url: "/habilidades/deletar",
            data: {
                habilidade: idHabilidade,
                vaga: vagaId
            },
            success: function(msg){
                window.location.reload()
            }
        });
    }
});

$("a.adicionaHabilidade").on("click", function() {
    let $elPai = $(this).closest("div.habilidade");
    let nome = $elPai.find("input[name='nome']").val();

    if(nome == "") {
        alert("Preencha o nome da habilidade!");
        return;
    }

    let tempo = $elPai.find("input[name='tempo']:checked").val();
    if($("input[name='idUsuario']").length > 0) {
        let usuarioId = $("input[name='idUsuario']").val();
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
    } else if($("input[name='idVaga']").length > 0) {
        let vagaId = $("input[name='idVaga']").val();
        $.ajax({
            type: "POST",
            url: "/habilidades/cadastro",
            data: {
                nome: nome, 
                tempo: tempo,
                vaga: vagaId
            },
            success: function(msg){
                window.location.reload()
            }
        });
    }
});

$(".editarCandidatura").on("click", function() {
    let idCandidatura = $(this).attr("data-idCandidatura");

    $("#editarCandidatura").find("input[name='idCandidatura']").val(idCandidatura);
});

$("#alterarStatus").on('click', function(e){
    e.preventDefault();
    let $elPai = $(this).closest("form");
    let status = $elPai.find("select[name='status']").val();
    let idCandidatura = $elPai.find("input[name='idCandidatura']").val();

    $.ajax({
        type: "POST",
        url: "/vaga/status",
        data: {
            candidatura: idCandidatura, 
            status: status
        },
        success: function(msg){
            window.location.reload()
        }
    });
 });