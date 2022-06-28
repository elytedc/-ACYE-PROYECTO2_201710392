mVariables macro
    ;Mensaje de Bienvenida
    mensajeI db 0A,"Universidad de San Carlos de Guatemala",0A,"Facultad de Ingenieria",0A,"Escuela de Ciencias y Sistemas",0A,"Arquitectura de Compiladores y Ensambladores",0A,"Seccion B",0A,"Brandon Oswaldo Yax Campos",0A,"201800534",0A;0A ES ENTER
    auxMi db "$"
    ;enter para avanzar
    espEnter db 0A,"(Presiona enter para poder continuar): $"
    ;MENU PRINCIPAL 
    Menu db 0A,"Menu",3A,0A,"F1. Login",0A,"F2. Register",0A,"F9. Exit",0A,"$"
    ; Opcion incorrecta
    opi db 0A,"**No se escogio una opcion entre las que existen**",0A,"$"
    ;MENSAJE LUEGO DE EQUIVOCARSE 3 VECES
    blockUs db ">> Permission denied <<",0A,">> There where 3 failed login attempts <<",0A,">> Please contact the administrator <<",0A,">> Press Enter to go back to menu <<",0A,"$"
    ;GENERAL LETREROS 
        msguser         db "user: ","$"
        msgTop10        db "==Top 10 Scorboard==","$"
        msgMyTop10      db "==My Top 10 Scorboard==","$"
        msgUnlockUserT  db "==Unlock User==","$"
        msgPromoteAdmin db "==Promote to Admin==","$"
        msgDemoteAdmin  db "==Demote to Admin==","$"
        msgBubbleTitle  db "==Bubble Sort==","$"
        msgMetricTittle db "==Bubble Metric==","$"
        msgSpeedTittle  db "==Bubble Speed==","$"
    ;LOGIN=====================================================================================
    msgLogin db 0A,"============Login",58t,"============",0A,"$"
    msgexit db "(presione tab y luego 2 enter para salir)",0A,"$"
    UsuarioI db 25 dup (24) ;nombre de usuario a ingresar
    useriaux db "$"
    PasswordI db 25 dup (24)   ;contraseña a ingresar
    passiaux db "$"
    msgUnE  db 0A,"===Usuario no Existe===",0A,"$"
    msgPinc  db 0A,"===Password Incorrecta===",0A,"$"
    msgUbloqueado db "==Usuario bloqueado==",0A,"$"
    enteraux db 0A,"$"
        ;MENU DE USUARIO
        msgMenuU db "====Menu de usuario===","$"
        MenuUsuario db "F2. Play game",0A,"F3. Show top 10 scoreboard",0A,"F5. Show my top 10 scoreboard",0A,"F9. Logout",0A,"$"
   
        ;MENU USUARIO ADMIN
        msgMuA db "Menu usuario Admin","$"
        MenuUsuarioAdmin db "F1. Unlock User",0A,"F2. Show top 10 scoreboard",0A,"F3. Show my top 10 scoreboard",0A,"F4. Play Game",0A,"F5. Bubble Sort",0A,"F6. Heap Sort",0A,"F7. Tim sort",0A,"F9. Logout",0A,"$"
    
        ;MENU DE ADMIN
        msgMenuAdmin db "Menu de Admin","$"
        usDesBloq db "Usuario a desbloquear: $"
        usDarAdmin db "Usuario a dar admin: $"
        usQuitarAdmin db "Usuario a remover admin: $"
        msgQuitAdminG db "==No se puede degradar al admin generaL==$"
        uNoBlock db "==El usuario no estaba bloqueado==",0A,"$"
        Uadmin db "==El usuario ya era admin==",0A,"$"
        uNoAdmin db "==El usuario no era admin==",0A,"$"
        Udesbloqueado db "==El usuario ha sido desbloqueado==$"
        Udadoadmin db "==Se ascendio a admin a el usuario==$"
        UquitAdmin db "==Se removio de admin al usuario==$"

        MenuAdmin db "F1. Unlock User",0A,"F2. Promote user to admin",0A,"F3. Demote user from admin",0A,"F5. Bubble Sort",0A,"F6. Heap Sort",0A,"F7. Tim sort",0A,"F9. Logout",0A,"$"
        Umoderado db 25 dup (24)
        ;DELAY
        valort1 db 0
        v1ax db "$"
        valort2 db 0
        v2ax db "$"
        auxt db 0
        contadort dw 0
        contDb db 0
        StringNumT db 4 dup(24)
    ;COMO AUXILIAR PARA LA MACRO NUM2STRING
    contador db 0

    ;REGISTRO DE USUARIOS=======================================================================
    msgRegister db 0A,"============Register",58t,"============",0A,"$"
    ;adminG db "Nombre",01,"Contraseña",01,Numero de veces que se equivoco,01,"Bloqueado/n","Admin/n" enter (0A)
    adminG db "201800534BADM$$$$$$$$$$$$",01,"435008102$$$$$$$$$$$$$$$$",01,"0",01,"N",01,"A",0A," "
    nameAdminG db "201800534BADM$$$$$$$$$$$$"
    rU db "Ingrese usuario",58t," $"
    rP db "Password",58t," $"
    UsuarioRegis db 25 dup (24) ;nombre de usuario a registrar
    PasswordRegis db 25 dup (24)   ;contraseña a registrar 
    validador db 0              ;validador 
        ActionR db "Accion rechazada! $" 
        ;MENSAJES DE NOMBRE DE USUARIO CONE ESTRUCTURA INCORRECTA
        msginitialbad db 0A,"Se debe de iniciar por una letra$"
        msglengtherror db 0A,"Tamanio del nombre de usuario no entre el rango (8-15 caracteres)$"
        msgUExist  db 0A, "El Usuario ya ha sido registrado previamente$"
        msgCaractP db 0A,"Los unicos caracteres permitidos fuera del alfabeto son -_.$"
        ;MENSAJES DE CONTRASEÑA CON ESTRUCTURA INCORRECTA
        msgunaM db 0A,"Password  debe de tener al menos una mayuscula$"
        msgunN db 0A,"Password debe de tener al menos un Numero$"
        msgunS db 0A,"Password  debe de tener al menos una !>%",59t,"*$"
        msglengtherror2 db 0A, "Tamanio de password no entre el rango (16-20 caracteres)$"
        ;GUARDAR USUARIO
        separador db 01
        enterg db 0A, " "
        Nequivdef db "0"
        Bloqdef db "N"
        admindef  db "N"
        Numerrordef db "0"
        BloqueoU db "B"
        AdminU db "A"
        ;ERRORES USUARIO
        numinicio db 0
        largoe db 0
        existee db 0
        caractNp db 0 ;caracteres no permitidos para el usuario
        ;CARACTERISTICAS PASSWORD
        mayuse db 0
        nume db 0
        sinCaractE db 0 ;caracteres especiales faltantes en la contraseña
        largoe2 db 0
        ;EXISTE ERROR
        enrango db 0
        eerror db 0
        contadoraux db 0
        RUSucces db "Registro exitoso",0A,"$"
            ;MENSAJE SUCCES
            msgRegistroSucces db "Se registro el usuario de forma exitosa"

    ; Opcion escogida del menu
    opcion db 0 
    dollar db '$'
    ;STRING DE UN NUMERO Y NUMERO DE UN STRING 
    stringNumactual db 20 dup (24)
    Numactual dw 0 
    auxs db "$"
    espacioL db " " ;espacio limpio 
    espacio db " ","$"
    retroceso db 08, "$"
    asterisco db "*","$"

    ;ORDENAMIENTOS Y SCORE==========================================================================
        MenuDirOrd db "F1. Ascending",0A,"F2. Descending", 0A,"F9. Go back",0A,"$"
        MenuMetricaOrd db "F1. Points",0A,"F2. Time", 0A,"F9. Go back",0A,"$"
        MenuSpeed db "F1. 0",0A,"F2. 1",0A,"F3. 2",0A,"F4. 3",0A,"F5. 4",0A,"F6. 5",0A,"F7. 6",0A,"F8. 7",0A,"F9. Go back",0A,"$"
        datosOrd dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"$"
        indexDato dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"$"
        nRepeticiones dw 0 ;variable para indicarle al programa cuantas veces repetir un ordenamiento 
        
        indexCiclo dw 0
        nRepeticiones2 dw 0 ;variable para indicarle al programa cuantas veces repetir un ordenamiento 
        ;PARA LETREROS 
            filaLetreroOrd db 0 ;fila donde estara cada numero que representa el valor de cada barra 
        ;PARA GRAFICACION DE BARRAS 
            CDatos dw 0 ;cantidad de datos analizados
            anchoBarra dw 0 ;ancho de una barra
            altoBarra dw 0  ;alto de una barra
            x_barra dw 0 ;posicion x de la barra
            y_barra dw 0 ;posicion y  de la barra
            NumactualDocS db 6 dup ("$") ;string de un numero actual atrapado en el doc externo de scores  
            auxNDS db "$"
            NumactualDoc dw 0 ;como almacenador del valor decimal del numero string atrapado 
            DatOrsb db 6 dup(0) ; contendra el valor limpio de cada barra  a la hora de graficar y que esta a la izquierda de estas 
            EstOrd db 0  ; inicio y fin del ordenamiento 
        ;OPCIONES ESCOGIDAS POR EL USUARIO  
            tOrdenamiento db 0 ;ordenamiento a usar 
            ascDec  db 0  ; si escogio ascending o descending
            velocity db 0 ;velocidad para delay 
            velString db 0
            punOtiempo db 0 ;se escogido score o tiempo como metrica 
        ;FLECHAS ORDENAMIENTO Y BORRADOR DE MOVIMIENTOS DE BARRAS
            x_f1 db 0
            flecha dw ">"
            brEspOx dw 0
            brEspOy dw 0
        ;LETREROS
            msgBubble       db  "Bubble"
            arriba          db  "^"
            abajo           db  "v"
            msgSpped        db  "Speed: "
            msgTimeOrd      db  "Time"
            msgPointOrd     db  "Points"
            msgPressHome    db  "Press HOME(inicio) to start"
            msgPressEnd     db  "Press END(fin) to print Rep"

    ;JUEGO===========================================================================
        NameUserG db 15t dup(" ") ;NICKNAME DEL JUGADOR 
        auxfpsT db 0
        ;MENSAJES
            Usergame db "Username:"
            Leveltitle db "Level:"
            Scoregame db "Score:"
            Timegame db "Time:"
            Livesgame db "Lives:"
            PressSpace db "Press space"
            toStartG  db "to Start"
        ;SCORE
            scoreG dw 0
            scoreGString db 5 dup (0)
        ;NIVEL 
            nivelGame dw 0
            nivelGameS dw 0 
            printEnemyE dw 0
        ;NAVE
            cNave_x dw 0
            cNave_y dw 0
            liNave dw 0
            corazonx dw 0
            corazony dw 0
        ;ENEMIGOS 
            ce_x dw 0
            ce_y dw 0 
            limIzqE dw 0
            limDerE dw 0
        ;FILA INICIAL CON LA CUAL SE COMENZARA A moverse los enemigos 
            filaIgame dw 0
        ;ESTADO DE APARICION DE ENEMIGOS
            estEnem db 0
            DestEnem db 0
            DestEnemA db 0 ;si la nave ya fue destruida con anterioridad 
        ;PERMITIR QUE SE MUEVA EL ENEMIGO 
            movEnemigo dw 0
        ;COLISION 
            colisionE db 0
        ;RECTANGULOS
            cordx dw 0
            cordy dw 0
            ancho dw 0
            alto dw 0
        ;BORRADOR DE MOVIMIENTO PARA ENEMIGOS 1
            borrXenemy dw 0
            borrYenemy dw 0
        ;BORRADOR ULTIMO DE MOVIMIENTO PARA ENEMIGOS
            borrUx dw 0
            borrUy dw 0 
        ;BORRADOR EN CASO DE IMPACTO (CUADRO 9 FILAS 16 COLUMNAS)
            bImpactox dw 0
            bImpactoy dw 0 
        ;BORRADOR MOVIMIENTO PARA NAVE 
            borrx dw 0
            borry dw 0
        ;BALAS 
            bala1x dw 0
            bala1y dw 0
            damageb1 dw 1t
            bala2x dw 0
            bala2y dw 0
            damageb2 dw 2t 
            bala3x dw 0
            bala3y dw 0
            damageb3 dw 3t
        ;ESTADOS DE DISPARO
            estD1 db 0
            estD2 db 0
            estD3 db 0
        ;MINUTOS SEGUNDOS Y CENTISEGUNDOS
            mingameS db 2 dup (0)
            seggameS db 2 dup (0)
            cengameS db 2 dup (0)
            segGameReporteS db 5 dup (0)
            dospuntosg db ":"
            mingameN dw 0
            seggameN dw 0
            cengameN dw 0
            segGameReporte dw 0
        ;PAUSA Y EXIT GAME 
            letGover    db "Game over!"
            letEsp      db "(Press Esp to Exit)"
            letPause    db "Pause"
            letRen      db "Continue (Esp)"
            letExit     db "Exit (Esc)"
            letN1       db "Level 1"
            letN2       db "Level 2"
            letN3       db "Level 3"
            letclear    db 7 dup (" ")
            matrizgraph db "matriz.vi",0
            eleactualG  db 0
            exitGame    db 0
            auxDw       dw 0
            auxString   db 4 dup (0)
            as          db "$"
    ;FECHA ====================================================================================
        dia     db 4 dup (0)
        mes     db 4 dup (0)
        anio    db 4 dup (0)
        hora    db 4 dup (0)
        min     db 4 dup (0)
        segun   db 4 dup (0)
        year    dw 0
        month   dw 0
        day     dw 0
        hours   dw 0
        minutes dw 0
        seconds dw 0
    ;MANEJO DE UN ARCHIVO EXTERNO ==============================================================
        eleActual db 0 ;variable que contendra cada elemento leido por el programa
        a db "$"
        handler dw  0
        msgcargar db 0A,"Ingrese el nombre del archivo a cargar: ",'$'
        nameFile db 20 dup(0)
        nfcaux db '$'
        cargood db 0A,"Cargo con exito! (presione cualquier tecla)","$" 
        carbad  db 0A,"Fallo la carga! (presione cualquier tecla)","$"
        estadocarga db 0 ;si se logro cargar algo o no
        savegood db 0A,"Guardado con exito!", "$"
        savebad db 0A, "No se guardo el archivo!","$"
        creacionCorrecta db 0       ;si se creo  con exito un nuevo documento su valor sera 1, caso contrario sera 0
        posLectura dw 0 ;VARIABLE CON LA CUAL SI LLEGA A 0 LUEGO DE INSTANCIAR LA MARCO READFILE SIGNIFICA QUE
        ;EL DOCUMENTO LLEGO AL FINAL DE ESTE
        idEncontrado db 0 ;SE ENCONTRO LA PALABRA EN ESPECIAL QUE SE REQUERIA?
    
    ;APARTADO PARA LOS ARCHIVOS QUE FUNCIONARAN COMO BASE DE DATOS==================================
        usersb      db  "users.gal",0
        scoresb     db  "scores.gal",0
        RepOrdName  db  "LASTSORT.REP",0
        auxarchivo  db 0
        aux1 db "$"
    ;REPORTE DE ORDENAMIENTO ======================================================================
        sepRepOrden     db  "-------------------------------------------------------",0A
        auxseprep            db "$"
        filaScore       db  25 dup (0)
        aux2            db  "$"
        msgEnter        db  0A 
        aux3            db "$"
        msgType         db  "Tipo: "
        msgSentido      db  "Sentido: "
        msgFecha        db  "Fecha: "
        msgHora         db  "Hora: "
        slash           db  2Fh
        msgAscen        db  "Ascendente"
        msgDescen       db  "Descendente"
        msgTitleRep     db  "Rank   Player           N       Points  Time",0A
        auxtitlerep     db "$"
        msgEspacios     db  "            "
        userprueba      db "brandonyax     "
    ;CONTADOR DELAY
    cdelay db 0
    ;PARA LA COMPARACION DE CADENAS==================================================
    cadIguales db 0
    ;DEBUGER ========================================================================
    eProgram db "PROGRAMA SE ENCUENTRA AQUI$"
endm 


;METODOS PARA LOGIN################################################################################################

mUserExiste macro Username 
    local Existe,Noexiste,salir,cicloexiste
    ;SE VERIFICA SI NO ES EL ADMIN
    mReadFile eleActual ;TOMA EL PRIMER VALOR DEL ARCHIVO 
    mEncontrarId Username;lo primero en el documento de usuarios es el admin, que siempre estara aca
    cmp idEncontrado,1 ; se encontro usuario? 
    je Existe ;si se encontro se procede a decir que si existe el usuario y se marcara como error
    cicloexiste: ;caso contrario se procedera a un ciclo de lectura del archivo hasta hallar o un espacio o el id buscado
        mHallarSimbolo 0A  ;se salta hasta el enter hasta la posicion donde esta 0A
        mReadFile eleActual ; se corre una vez el elemento 
        cmp eleActual," " ;si hay un espacio es que ya se llego al fin del documento y el usuario no existe
        ;CADA VEZ QUE SE CREA UN USUARIO SE ELIMINA EL ULTIMO ESPACIO QUE DEJA LA CREACION DEL USUARIO ANTERIOR
        je Noexiste ; no existe usuario
        mEncontrarId Username ;si no es espacio lo que esta en esta posicion fijo es un nombre de user, el user a registrar  es igual a este? 
        cmp idEncontrado,1 ; si, entonces existe 
        je Existe 
        jne cicloexiste 
    Existe:
        mov existee,1 ;se reporta error pues existe usuario que se intenta registrar
        mov eerror,1  ;se reporta error general al registro
        jmp salir 
    Noexiste:
        mov existee, 0 ; no existe usuario, no hay error
    salir:
endm 


mDrawEborrado macro  x,y 
    local figuraB
    push cx
    push ax
    push dx 
    xor ax, ax 
    xor dx, dx 
    mov cx, 6t
    mov ax, x
    mov dx, y
    dec x 
    dec x 
    figuraB:
        mDecVar y,4t 
        mDrawFila x,y,0t,8t     
        mov y, dx 
        dec x
        loop figuraB
    mov x,ax
    pop dx
    pop ax
    pop cx 
endm 
mDrawNaveEdestruida macro  x,y  ;NAVE ENEMIGA DESTRUIDA 
    local figuraB
    push cx
    push ax
    push dx 
    xor ax, ax 
    xor dx, dx 
    xor cx, cx 
    mov cx, 12t
    mov ax, x
    mov dx, y
    inc x 
    inc x 
    inc x 
    figuraB:
        mDecVar y,8t 
        mDrawFila x,y,0t,16t     
        mov y, dx 
        dec x
        loop figuraB
    mov x,ax
    pop dx
    pop ax
    pop cx 
endm 
;borrar la bala luego de que finalice el movimiento de esta 
mLimpiarDisparo macro x,y 
    local borrarMovBala
    push cx 
    mov cx, 4 
    borrarMovBala:
        mDrawPixel x,y,0t
        inc x
        loop borrarMovBala
    pop cx 
endm 

;IMPRIME STRINGS CON COLOR EN UNA POSICION INDICADA 
mImprimirLetreros macro letrero,fila,columna,color
    push ax
    push bx
    push cx
    push dx  
    push bp 
    mov al,1   ;MODO DE IMPRESION CON COLOR (1), SIN COLO(0)
    mov bh,0   ;PAGINA 
    mov bl,color  ;COLOR  (PALETA VGA 1t-255t)
    mov cx,LENGTHOF letrero ;tamaño del letrero 
    mov dl,columna ;columna 
    mov dh,fila ;fila 
    call pDataS_ES ;se puede realiar esto o el procedimiento de abajo siempre y cuando ds tenga el valor de @data 
    ;push ds  ;meto el valor de ds a la pila (que contiene el data segment)
    ;pop es  ;dicho valor se saca de la pila y se asigna a "es" 
    mov bp,offset letrero 
    mov ah,13h
	int 10h
    call pMemVideoMode;SE VUELVE A COLOCAR LA MEMORIA DE VIDEO EN ES 
    pop bp 
    pop dx 
    pop cx
    pop bx 
    pop ax 
endm 

;EN RANGO PERO CON DW 
mEnRangoDw macro dato,limif, limsup
    local enElrango,noEnelrango,salir
    ;ja >,jb <,  jbe<=
    mCompararDw dato,limif
    jb noEnelrango ; si es menor al limite inferior no esa en el rango
    mCompararDw dato,limsup
    jbe enElrango ; si es menor o igual al limite superior esta en el rango
    ja noEnelrango; si es mayor no esta en el rango 
    enElrango:
        MovVariables enrango,1
        jmp salir 
    noEnelrango:
        MovVariables enrango,0
    salir:
endm

mWaitKey macro key 
    local ciclo 
    push ax 
    ciclo: 
    mov ah, 00  ;Espera a que se presione una tecla y la lee
    int 16h
    cmp al,key 
    jne ciclo 
    pop ax 
endm 

;MACROS PARA ORDENAMIENTO ################################################################################

;MACRO PARA CAPTURAR STRINGS DE UN DOCUMENTO EXTERNO EN UNA VARIABLE 
mCapturarStringDoc macro variableAlmacenadora 
    local salir,capturarString
    push si  
    mov si,0
    capturarString:
        MovVariables variableAlmacenadora[si],eleActual
        inc si
        mReadFile eleActual
        cmp eleActual,1 ;es igual a 1 ASCII (no es igual al 1 decimal no afecta a los numeros)?
        je salir  ; si, terminar de capturar
        cmp eleactual,00
        je salir 
        cmp eleActual,0A ;es igual a enter tipo1
        je salir  ; si, terminar de capturar
        cmp eleActual," " ;los 0's impresos en un documento externo se vuelven espacios
        je salir  ; si, terminar de capturar
        jmp capturarString
    salir:
    pop si 
endm

mDrawBarra macro x,y,alto,ancho,color 
    local cicloAncho,cicloAlto,no0x,no0y
    push ax 
    push dx
    push cx 
    
    movVariablesDw cordx,x
    movVariablesDw cordy,y 
        cmp cordx,0
        jne no0x
        mov cordx,1 
        no0x:
        cmp cordy,0
        jne no0y
        mov cordy,1 
        no0y:
    ;ancho de x1 a x2
    ;alto de y1 a y2
    mov ax,x
    mov dx,y 
    mov cx,ancho
    cicloAncho: 
    push cx 
        mov cx, alto 
        cicloAlto:
            mDrawPixel cordx,cordy,color  
            inc cordx 
        loop cicloAlto
        mov cordx,ax 
    pop cx 
    inc cordy 
    loop cicloAncho
    mov cordy, dx 
    pop cx
    pop dx 
    pop ax 
endm 

mIncFilaBar macro fila
    local salir 
    mEnRangoDw CDatos,12t,20t 
    inc fila 
    cmp enrango,1
    je salir  

    mEnRangoDw CDatos,8t,11t 
    inc fila 
    cmp enrango,1
    je salir 

    mEnRangoDw CDatos,5t,7t
    inc fila 
    cmp enrango,1
    je salir 

    inc fila 
    cmp CDatos,4t 
    je salir  

    inc fila 
    inc fila 
    cmp CDatos,3t 
    je salir  
    mIncVar fila,3t 
    cmp CDatos,2t
    salir: 
endm 
;MUEVE EL CURSOR DE LA POSICION ACTUAL DEL DOCUMENTO LEIDO A LA FILA DESEADA (empieza desde 0)
mMoverAFila macro fila 
    local ciclo,salir 
    call pInidoc ;POSICIONA EL CURSOR EN EL INICIO DEL DOCUMENTO LEIDO 
    push cx
    cmp fila,0
    je salir 
    mov cx,fila 
    ciclo: 
        mHallarSimbolo 0A
    loop ciclo
    salir:     
    pop cx
endm 
;CAPTURA LA FILA ACTUAL DONDE SE ENCUENTRA EL CURSOR EN EL DOCUMENTO LEIDO EN UNA VARIABLE
mCapturarFilaDoc macro varAlmacenadora 
    local salir,capturarString,noseparador,separador
    push si  
    mov si,0
        mReadFile eleactual
    capturarString:
        cmp eleactual,01 ;separador
        jne noseparador
        MovVariables varAlmacenadora[si],09h ;tabulacion
        jmp separador
        noseparador: 
        MovVariables varAlmacenadora[si],eleActual
        separador:
        inc si
        mReadFile eleActual
        cmp eleActual,0A ;es igual a enter tipo1
        je salir  ; si, terminar de capturar
        cmp eleActual,0dh ;es igual a enter tipo1
        je salir  ; si, terminar de capturar
        jmp capturarString
    salir:
    pop si 
endm
