io = require('socket.io').listen(6969)


console.log 'Servidor iniciado'
listUsersConectados = {}

io.sockets.on 'connection', (socket) ->
    socket.on 'userConectado', (data) ->
        if data[1] is 'admin'
            if !listUsersConectados[data[0]]
                console.log listUsersConectados[data[0]]
                listUsersConectados[data[0]] = data[0]

                socket.emit 'success'
                io.sockets.emit 'userConectado',[data[0],listUsersConectados]
            else
                socket.emit 'incorrectNick', data[0]
        else
            socket.emit 'incorrectPassword'

    socket.on 'userDesconectado', (user) ->
        if listUsersConectados[user]
            delete listUsersConectados[user]

            io.sockets.emit 'userDesconectado',[user,listUsersConectados]

    socket.on 'mensaje', (data) ->
        io.sockets.emit 'mensajeDesdeServidor',{
                nick: data.nickname, 
                msj: data.mensaje
            }

    return
