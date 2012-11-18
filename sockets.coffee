jQuery ($) ->
    websockets = io.connect 'http://192.168.1.128:6969/'

    $('#accesoForm').on 'submit', ->
        datosUser = [$('#nombre').val(),$('#password').val()]

        websockets.emit 'userConectado',datosUser

        false

    $('#logout').on 'click', ->
        websockets.emit 'userDesconectado',sessionStorage.nickname

        return

    $('#mensajeForm').on 'submit', ->
        websockets.emit 'mensaje',{nickname: sessionStorage.nickname, mensaje: $("#mensaje").val() }
        $('#mensaje').val ''

        false

    updateUserOnline = (array) ->
        $('#usuariosOnline .conectados').text ''
        $.each array, (key,user) ->
            $('#usuariosOnline .conectados').prepend "<p>#{user}</p>"
            return

    warningPassword = ->
        alert 'La contraseña que has introducido no es correcta'

    warningNick = (nick) ->
        alert "El nick #{nick} no está disponible"

    welcome = (data) ->
        $(location).attr 'href','#chat'
        sessionStorage.nickname = $('#nombre').val()

        notify 'Te has conectado',500,5000

    connectNewUser = (datos) ->
        if datos[0] isnt sessionStorage.nickname
            notify "Usuario #{datos[0]} conectado",500,5000
        updateUserOnline datos[1]

        return

    disconnectUser = (datos) ->
        if datos[0] isnt sessionStorage.nickname
            notify "#{datos[0]} se ha desconectado",500,5000,'error'
        else
            notify 'Te has desconectado',500,5000,'error'
            $(location).attr 'href','#home'

        updateUserOnline datos[1]

        return

    response = (datos) ->
        $('#mensajes').prepend "<p><b>#{datos.nick}</b>: #{datos.msj}</p>"


    websockets.on 'mensajeDesdeServidor', response
    websockets.on 'incorrectPassword',warningPassword
    websockets.on 'incorrectNick',warningNick
    websockets.on 'userConectado',connectNewUser
    websockets.on 'userDesconectado',disconnectUser
    websockets.on 'success',welcome
    
    return