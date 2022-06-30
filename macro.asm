;mDrawFila
;Livesgame
mVariables macro
    ;Mensaje de Bienvenida
    mensajeI db 0A,"Universidad de San Carlos de Guatemala",0A,"Facultad de Ingenieria",0A,"Escuela de Ciencias y Sistemas",0A,"Arquitectura de Compiladores y Ensambladores",0A,"Seccion A",0A,"John Henry Lopez Mijangos",0A,"201710392",0A;0A ES ENTER
    auxMi db "$"
    ;enter para avanzar
    espEnter db 0A,"(Presiona enter para poder continuar): $"
    ;MENU PRINCIPAL 
    Menu db 0A,"Menu",3A,0A,"1. Login",0A,"2. Registrar",0A,"3. Exit",0A,"$"
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
    msgexit db "(presione salir)",0A,"$"
    UsuarioI db 25 dup (24) ;nombre de usuario a ingresar
    useriaux db "$"
    PasswordI db 25 dup (24)   ;contraseña a ingresar scoreGString
    passiaux db "$"
    msgUnE  db 0A,"===Usuario no Existe===",0A,"$"
    msgPinc  db 0A,"===Password Incorrecta===",0A,"$"
    msgUbloqueado db "==Usuario bloqueado==",0A,"$"
    enteraux db 0A,"$"
        ;MENU DE USUARIO
        msgMenuU db "====Menu de usuario===","$"
        MenuUsuario db "1. Iniciar Juego",0A,"2. TOP 10",0A,"3. Salir",0A,"$"
   
        ;MENU USUARIO ADMIN MenuAdmin 
        msgMuA db "Menu usuario Admin","$"
        MenuUsuarioAdmin db "1. TOP 10 score",0A,"F2. Show top 10 scoreboard",0A,"F3. Show my top 10 scoreboard",0A,"F4. Play Game",0A,"F5. Bubble Sort",0A,"F6. Heap Sort",0A,"F7. Tim sort",0A,"F9. Logout",0A,"$"
    
        ;MENU DE ADMIN mEncontrarId
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

        MenuAdmin db "1. TOP SCORE",0A,"2. TOP TIMES",0A,"3. ORDENAMIENTO SCORE",0A,"4. SALIR",0A,"$"
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
    ;COMO AUXILIAR PARA LA MACRO NUM2STRING UsuarioRegis mSizeUser MenuDirOrd
    contador db 0

    ;REGISTRO DE USUARIOS=======================================================================
    msgRegister db 0A,"============Register",58t,"============",0A,"$"
    ;adminG db "Nombre",01,"Contraseña",01,Numero de veces que se equivoco,01,"Bloqueado/n","Admin/n" enter (0A)
    adminG db "201710392BADM$$$$$$$$$$$$",01,"435008102$$$$$$$$$$$$$$$$",01,"0",01,"N",01,"A",0A," "
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
        msgunN db 0A,"Password debe de tener 4 Numeros$"
        msgunS db 0A,"Password  debe de tener al menos una !>%",59t,"*$"
        msglengtherror2 db 0A, "Tamanio de password no entre el rango (4 numeros)$"
        ;GUARDAR USUARIO
        separador db ";"
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
    espacioL db " " ;espacio limpio  MenuMetricaOrd
    espacio db " ","$"
    retroceso db 08, "$"
    asterisco db "*","$"

    ;ORDENAMIENTOS Y SCORE==========================================================================
        MenuDirOrd db "1. Asceendente",0A,"2. Descendente", 0A,"3. SALIR",0A,"$"
        MenuMetricaOrd db "1. Score",0A,"2. Tiempo", 0A,"3. Salir",0A,"$"
        MenuSpeed db "1. 0",0A,"2. 1",0A,"3. 2",0A,"4. 3",0A,"5. 4",0A,"6. 5",0A,"7. 6",0A,"8. 7",0A,"9. Salir",0A,"$"
        datosOrd dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"$"
        indexDato dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"$"
        nRepeticiones dw 0 ;variable para indicarle al programa cuantas veces repetir un ordenamiento 
        
        indexCiclo dw 0
        nRepeticiones2 dw 0 ;variable para indicarle al programa cuantas veces repetir un ordenamiento 
        ;PARA LETREROS 
            filaLetreroOrd db 0 ;fila donde estara cada numero que representa el valor de cada barra 
        ;PARA GRAFICACION DE BARRAS  mCapturarPassword PressSpace
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
        NameUserG db 15t dup(" ") ;NICKNAME DEL JUGADOR  mDrawRectangulo mSumarDw
        auxfpsT db 0
        ;MENSAJES
            Usergame db "Username:"
            Leveltitle db "Vidas:"
            Scoregame db "Score:"
            Timegame db "Time:"
            Livesgame db "Lives:"
            PressSpace db "Press space"
            toStartG  db "to Start"
        ;SCORE
            scoreG dw 0
            unidad dw 0
            decena dw 0
            scoreGString db 5 dup (0)

            vidas dw 0
            vidasString db 5 dup (0)
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
        ;MINUTOS SEGUNDOS Y CENTISEGUNDOS MenuUsuario
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
            letEsp      db "WINER :D"
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
        idEncontrado db 0 ;SE ENCONTRO LA PALABRA EN ESPECIAL QUE SE REQUERIA? mOpenFile2Write
    
    ;APARTADO PARA LOS ARCHIVOS QUE FUNCIONARAN COMO BASE DE DATOS==================================
        usersb      db  "users.gal",0
        scoresb     db  "scores.gal",0
        scoresb2     db  "scores2.gal",0
        RepOrdName  db  "resultados.REP",0
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
        msgSentido      db  "_"
        msgFecha        db  "Fecha: "
        msgHora         db  "Hora: "
        slash           db  2Fh
        msgAscen        db  "_"
        msgDescen       db  "Descendente"
        msgTitleRep     db  "Rank   Player           N       Points  Time",0A
        auxtitlerep     db "$"
        msgEspacios     db  "            "
        userprueba      db "johnlopez     "
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
    ;SE VERIFICA SI NO ES EL ADMIN RepOrdName  scoresb2
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
; pQuitarbloqAdmin msgPinc MenuUsuarioAdmin

;METODOS PARA REGISTRAR############################################################################################

;REQUISITOS PARA EL USUARIO 
;NO DEBE DE TENER UN NUMERO AL INICIO
mUserInicial macro
    local iniNumero,iniLetra,salir 
    mEnRango UsuarioRegis[0],30h,39h  ; el dato se encuentra entre 0-9 del codigo ascii?
    cmp enrango,0     ;no
    je iniLetra       ;inicia con una letra y otro caracter, no hay error
    iniNumero:        ;inicia con un numero, si hay error 
        mov numinicio,1  ;marca con 1 la variable la variable global que indica un error sobre un numero inicial
        mov eerror,1 ;indica que hay un error en el usuario o en la contraseña por tal razon no se registra
        jmp salir       
      
    iniLetra:   
        mov numinicio,0 ;marca que no hubo error 
    salir: 
endm 
;EL TAMAÑO DEL USUARIO DEBE DE ESTAR ENTRE 8-15 LETRAS UsuarioRegis mANum
mSizeUser macro
    local ciclosize,comparaciones,sentenciagood,salir,sentenciabad
    push si 
    mov contadoraux,0 ;inicializa variable que contendra el tamaño del nombre user  mSizePassword 
    mov si, 0 
    ciclosize:
        cmp si, 15t ;si ya llego a 25? (el tamaño maximo de la variable)
        je comparaciones ; si, pase a comprobar el tamaño del nombre user con los rangos
        mComparar UsuarioRegis[si],"$" ;cuando llegue a $ es que llego al fin del nombre usuario
        je comparaciones ;si es asi pasa a comparar el tamaño con los margenes permitidos
        mSumardb contadoraux,1 ;si no, suma uno al tamaño del nombre user 
        inc si ;incrementa uno al index si 
        jmp ciclosize ; repite el ciclo 
    comparaciones:
        mEnRango contadoraux, 2t,15t ; el tamaño esta entre 8 -15  ?
        mComparar enrango,1  ; esta en rango?
        je sentenciagood     ;si, la sentencia es correcta
        jne sentenciabad     ;no, la sentencia no es correcta 
    sentenciagood:
        mov largoe, 0        ; no hay error respecto al rango 
        jmp salir            ; sale 
    sentenciabad:
        mov largoe,1         ; si hay error respecto al rango
        mov eerror,1         ; si hay error en name user o password 
    salir: 
    pop si 
endm 

;NO DEBE DE EXISTIR EL USUARIO
mUserExisteR macro 
    local Existe,Noexiste,salir,cicloexiste
    ;SE VERIFICA SI NO ES EL ADMIN
    mOpenFile usersb  ;abre el archivo en modo lectura 
    mReadFile eleActual ;TOMA EL PRIMER VALOR DEL ARCHIVO 
    mEncontrarId UsuarioRegis;lo primero en el documento de usuarios es el admin, que siempre estara aca
    cmp idEncontrado,1 ; se encontro usuario? 
    je Existe ;si se encontro se procede a decir que si existe el usuario y se marcara como error
    cicloexiste: ;caso contrario se procedera a un ciclo de lectura del archivo hasta hallar o un espacio o el id buscado
        mHallarSimbolo 0A  ;se salta hasta el enter hasta la posicion donde esta 0A
        mReadFile eleActual ; se corre una vez el elemento 
        cmp eleActual," " ;si hay un espacio es que ya se llego al fin del documento y el usuario no existe
        ;CADA VEZ QUE SE CREA UN USUARIO SE ELIMINA EL ULTIMO ESPACIO QUE DEJA LA CREACION DEL USUARIO ANTERIOR
        je Noexiste ; no existe usuario
        mEncontrarId UsuarioRegis ;si no es espacio lo que esta en esta posicion fijo es un nombre de user, el user a registrar  es igual a este? 
        cmp idEncontrado,1 ; si, entonces existe 
        je Existe 
        jne cicloexiste 
    Existe:
        mov existee,1 ;se reporta error pues existe usuario que se intenta registrar
        mov eerror,1  ;se reporta error general al registro
        call pCloseFile
        jmp salir 
    Noexiste:
        mov existee, 0 ; no existe usuario, no hay error mRequisitoCletra scoreG
        call pCloseFile
    salir:
endm 

;MACRO QUE VERIFICA SI EXISTE UN ID EN EL DOCUMENTO 
mEncontrarId macro id
    local salir ,comparar,idhallado,idNohallado,finid
    push si 
    mov idEncontrado,0 ;limpiar idEncontrado
    mov si,0
    comparar:
    mComparar id[si],"$" ;llego al final del id escogido   
    je finid 
    mComparar id[si],eleActual   ; la letra obtenida es igual al elemento actual del id?
    jne idNohallado ; no, entonces no son el mismo id, id no se hallo
    ;si, se procede a seguir recorriendo
    mReadFile eleActual
    inc si 
    jmp comparar
    finid: ;llego al fin del id, pero llego al fin del usuario leido en el doc?
        cmp eleActual,"$"
        je idhallado ;si entonces si es ese el id 
        jne idNohallado ; los id no son iguales 
    idhallado:
        MovVariables eleActual,0;LIMPIEZA DE VARIABLE 
        mov idEncontrado,1 ;INDICA SI EL ID FUE ENCONTRADO 
        jmp salir 
    idNohallado:
        MovVariables eleActual,0;LIMPIEZA DE VARIABLE 
        mov idEncontrado,0 ;INDICA SI EL ID FUE ENCONTRADO 
    salir:
    pop si 
endm 
;mHallarSimbolo mReadFile pResetFlagsE mReadFile mUserExiste mSizePassword 


;VERIFICA QUE CADA LETRA DEL USER SEAN CARACTERES PERMITIDOS USANDO EL METODO MENRANGOESP mSizeUser
mRequisitoCletra macro
    local ciclo,sicumpleR,nocumpleR,salir 
    push si 
    mov si,0 ;inicializa si 
    ciclo: 
        cmp si,25t  ;si llego hasta 25? (el tamaño maximo deuna variable)
        je sicumpleR ;si, entonces no paso ningun error por lo tanto todas las letras en el username cumplen con las restricciones
        mComparar UsuarioRegis[si], "$" ; llego hasta $?
        je sicumpleR ;si llego hasta $ significa que no hay errores en los caracteres del name user
        mEnRangoEsp UsuarioRegis[si] ;revisa que esta letra cumpla con los requisitos de los margenes
        cmp enrango,1 ;esta en rango, entre los caracteres permitidos 
        jne nocumpleR ;no, no lo esta 
        inc si  ;si , si lo esta
        jmp ciclo 
    sicumpleR:
        mov caractNp,0 ; no hay errores entre los caracteres permitidos
        jmp salir 
    nocumpleR:
        mov caractNp,1 ;hay error y hay caracteres no permitidos
        mov eerror,1    ; error general 
    salir: 
    pop si 
endm 

;MUESTRA SI LA LETRA MANDADA ESTA ENTRE EL RANGO DE LETRAS Y SIMBOLOS ESPECIALES PEDIDOS 
mEnRangoEsp macro dato
    local enrangoEsp,noenrango,salir
    mEnRango dato, 41h,5Ah  ;de A-Z
    cmp enrango,1
    je enrangoEsp

    mEnRango dato, 61h, 7ah ; de a-z
    cmp enrango,1
    je enrangoEsp

    mEnRango dato, 30h,39h   ; de 0-9
    cmp enrango,1
    je enrangoEsp

    mEnRango dato, 45t,46t   ; "-","."
    cmp enrango,1
    je enrangoEsp

    mComparar dato,"$"
    je enrangoEsp

    mComparar dato,"_"
    je enrangoEsp
    jne noenrango ; si no cuplio con ninguna entonces hay algun simbolo que no esta dentro de los permitidos
    enrangoEsp:
        mov enrango,1
        jmp salir 
    noenrango:
        mov enrango,0
    salir:
endm 



;OPCIONES PARA CONTRASEÑA 
;QUE TENGA AL MENOS UNA MAYUSCULA
mAMayus macro 
    local ciclopassword, salir, tieneMayus,noTieneMayus
    push si 
    mov si, 0 ; se inicializa si 
    ciclopassword:   
        cmp si,25t ; si llego a 25 es que no habia ningun caracter con mayusculas
        je noTieneMayus
        mEnRango PasswordRegis[si],41h,5Ah  ; esta esta letra entre el rango de las mayusculas
        cmp enrango,1 ;esta en el rango?
        je tieneMayus ; si  se pasa a indicar que si tiene mayusculas por lo tanto no hay error
        inc si 
        jmp ciclopassword   
    tieneMayus:
        mov mayuse,0 ; se procede a decir que o hay error en la falta  de mayusculas
        jmp salir 
    noTieneMayus:
        mov mayuse,1 ;falta mayusculas
        mov eerror,1 ;hay error en usuario o password
    salir: 
    pop si 
endm 
;QUE TENGA LA MENOS UN NUMERO
mANum macro 
    local ciclopassword, salir, tieneCaracter,noTieneCAracter
    push si 
    mov si, 0 ; se inicializa si 
    ciclopassword:   
        cmp si,25t ; si llego a 25 es que no habia ningun caracter con numero
        je noTieneCAracter ; se salta a indicar que hay error y no cumple con tener al menos un numero
        mEnRango PasswordRegis[si],30h,39h  ;esta en el rango de numeros?
        cmp enrango,1 ;Si
        je tieneCaracter ;se procede a indicar que existe al menos un numero
        inc si  ;se busca si y se compara el siguiente elemento
        jmp ciclopassword   
    tieneCaracter:
        mov nume ,0 ;hay al menos un numero
        jmp salir 
    noTieneCAracter:
        mov nume,1 ;no hay numeros
        mov eerror,1 ;error 
    salir: 
    pop si 
endm 
; QUE TENGA AL MENOS UN !>%;*
mASigno macro 
    local ciclopassword, salir, tieneCaracter,noTieneCAracter
    push si 
    mov si, 0
    ciclopassword:   
        cmp si,25t ; si llego a 25 es que no habia al menos un caracter especificado en el password
        je noTieneCAracter
        mComparar PasswordRegis[si],"!"
        je tieneCaracter 
        mComparar PasswordRegis[si],">"
        je tieneCaracter
        mComparar PasswordRegis[si],"%"
        je tieneCaracter
        mComparar PasswordRegis[si],59t ;59t = puntoycoma
        je tieneCaracter
        mComparar PasswordRegis[si],"*"
        je tieneCaracter
        inc si 
        jmp ciclopassword   
    tieneCaracter:
        mov sinCaractE ,0
        jmp salir 
    noTieneCAracter:
        mov sinCaractE,1
        mov eerror,1
    salir: 
    pop si 
endm 
;TAMAÑO DE ENTRE 16 A 20
mSizePassword macro 
    local ciclosize,comparaciones,sentenciagood,salir,sentenciabad 
    push si  
    mov contadoraux,0 ; se inicializa la variable que contendra el tamaño del password
    mov si, 0
    ciclosize:
        cmp si,5t ; si llego a 25 (maximo tamaño para una password ) pasa a proceder a verificar el tamaño
        je comparaciones ;pasa a comparar con los margenes
        mComparar PasswordRegis[si],"$" ;llego hasta $, significa que llego al fin del tamaño del password
        je comparaciones ;pasa a comparar con los margenes
        mSumardb contadoraux,1
        inc si 
        jmp ciclosize
    comparaciones:
        mEnRango contadoraux, 4t,4t ;el tamaño esta entre 16 y 20 caracteres?
        mComparar enrango,1 
        je sentenciagood ;si, longitud de password correcta
        jne sentenciabad ;no, longitud de password incorrecta
    sentenciagood:
        mov largoe2 , 0 ;no hay error en el rango
        jmp salir 
    sentenciabad:
        mov largoe2 ,1 ;si hay eror en el rango
        mov eerror,1 ; hay error en usuario o contraseña
    salir: 
    pop si 
endm 

;MACRO PARA VERIFICAR SI ESTA EN RANGO O NO UN DATO separador
mEnRango macro dato,limif, limsup
    local enElrango,noEnelrango,salir
    ;ja >,jb <,  jbe<=
    mComparar dato,limif
    jb noEnelrango ; si es menor al limite inferior no esa en el rango
    mComparar dato,limsup
    jbe enElrango ; si es menor o igual al limite superior esta en el rango
    ja noEnelrango; si es mayor no esta en el rango 
    enElrango:
        MovVariables enrango,1
        jmp salir 
    noEnelrango:
        MovVariables enrango,0
    salir:
endm 

;Imprime variables
mMostrarString macro var 
    push dx
    push ax
    xor ax,ax
    mov dx,ax 
    lea dx, var
    mov ah, 09
    int 21
    pop ax
    pop dx 
endm
;MACRO PARA CONVERTIR STRINGS A NUMEROS
String2Num macro stringToRead,whereToStore,simbol2stop 
    local readStringValue
    push ax 
    push cx 
    push dx 
    push bx 
    push si 
    xor dx,dx ;limpia dx y la vuelve 0
    mov ax,dx ;ax = 0
    mov si,dx ;si = 0
    mov cx,dx 
    mov bx, 0A ;bx=10
    ;mov si, offset stringtoRead
    readStringValue:
    mov cl,stringToRead[si]
    sub cl,30h ; se le resta 30 para convertirlo a un numero legible (num de 0-9)
    mul bx    ; ax= ax*bx  se multiplica por 10 el valor actual de ax 
    add ax,cx ; se suma a ax el valor de cx
    inc si
    cmp stringToRead[si],simbol2stop ; simbolo para saber cuando finalizo lo relevante de la cadena y parar de convertir 
    jne readStringValue
    mov whereToStore,ax 
    pop si 
    pop bx 
    pop dx
    pop cx  
    pop ax 
endm 

;NUMEROS A STRING
Num2String macro numero, stringvar  ;stringvar: variable donde se almacenara el numero opcion
    local cNumerador,Convertir
    push ax 
    push bx
    push dx 
    push si 
   
    mov contador,0
    mov bx,0A
    mov ax, numero
    cNumerador:   ;condicion de numerador mImprimirLetreros
        xor dx,dx
        div bx
        push dx
        inc contador ;tamaño de la pila, aumenta al agregarse un valor
        cmp ax, 0 ;numerador es igual a 0?
        jne cNumerador
    mov si, offset stringvar; donde se almacenara el nuevo numero
    Convertir:
        pop dx  ;pop = pila.pop(ultimo valor)
        add dx,30h
        mov [si],dx
        inc si 
        dec contador
        cmp contador,0 
        jne Convertir
    pop si
    pop dx 
    pop bx 
    pop ax 
endm 
;MACRO PARA CAPTURAR STRINGS EN UNA VARIABLE
mCapturarString macro variableAlmacenadora 
    local salir,capturarLetras,deletCaracter
    push ax
    push si 
    mov si,0
    capturarLetras:
        mov ah,01h
        int 21h
        cmp al, 0dh ;es igual a enter?
        je salir ; una vez dado enter y capturado todo el nombre, pasar al siguiente procedimiento
        cmp al, 08 ;es igual a retroceso?
        je deletCaracter
        mov variableAlmacenadora[si],al
        inc si
        jmp capturarLetras
    deletCaracter:
        cmp si,0
        je capturarLetras
        mov variableAlmacenadora[si],24
        dec si 
        mMostrarString espacio ; " "
        mMostrarString retroceso ;"<-"
        jmp capturarLetras
    salir:
        pop si
        pop ax 
endm 
;CAPTURAR CONTRASEÑA
mCapturarPassword macro variableAlmacenadora 
    local salir,capturarLetras,deletCaracter
    push ax
    push si 
    mov si,0
    capturarLetras:
        mov ah,01h
        int 21h
        cmp al, 0dh ;es igual a enter?
        je salir ; una vez dado enter y capturado todo el nombre, pasar al siguiente procedimiento
        cmp al, 08 ;es igual a retroceso?
        je deletCaracter
        mMostrarString retroceso ;"<-"
        ;mMostrarString asterisco ; "*"
        mov variableAlmacenadora[si],al
        inc si
        jmp capturarLetras
    deletCaracter:
        cmp si,0
        je capturarLetras
        mov variableAlmacenadora[si],24
        dec si 
        mMostrarString espacio ; " "
        mMostrarString retroceso ;"<-"
        jmp capturarLetras
    salir:
        pop si
        pop ax 
endm 
;LIMPIA UNA VARIABLE
mLimpiar macro lista,numero,signo
    local salir,borrar
    push si  
    mov si,0
    borrar:
        mov lista[si],signo   
        inc si
        cmp si,numero
        je salir
        jne borrar
    salir:
    pop si 
endm
;MUEVE EL CONTENIDO DE UNA VARIABLE A OTRA 
MovVariables macro var1,var2
    push dx 
    mov dl,var2
    mov var1, dl ; SE INGRESA A LA NUEVA POSICION EL SIMBOLO ACTUAL
    pop dx 
endm
;COMPARAR STRINGS 
mCompararStrings macro var1, var2
    local salir,Iguales,noIguales,comparar,pfvar1,pfvar2
    push si 
    mov cadIguales,0
    mov si,0
    comparar:   
        mComparar var1[si],var2[si]
        je Pfvar1 
        jne noIguales
    pfvar1:
        mComparar var1[si],"$" ;cadena llego al final?
        je pfvar2 ;tambien llego al final en la cadena 2?
        inc si 
        jne comparar 
    pfvar2:
        mComparar var2[si],"$"
        je Iguales ;si llego al final al mismo tiempo que var 1, son iguales
        jne noIguales ;no son iguales 
    Iguales: 
        mov cadIguales,1
        jmp salir 
    noIguales:
        mov cadIguales,0
        jmp salir 
    salir: 
    pop si 
endm 
;COMPARA VARIABLES
mComparar macro var1,var2
    push ax 
    push bx 
    xor ax,ax
    mov bx,ax 
    mov al,var1
    mov bl,var2
    cmp al,bl
    pop bx
    pop ax
endm 
;COMPARA VARIABLES
mCompararDw macro var1,var2
    push ax 
    push bx 
    xor ax,ax
    mov bx,ax 
    mov ax,var1
    mov bx,var2
    cmp ax,bx
    pop bx
    pop ax
endm 


;SUMAR DW mMultiplicacionDw
mSumarDw macro var1,var2
    push ax 
    xor ax,ax 
    mov ax,var1
    add ax,var2
    mov var1,ax
    pop ax 
endm 
;SUMAR DB 
mSumardb macro var1,var2
    push ax 
    xor ax,ax 
    mov al,var1
    add al,var2
    mov var1,al
    pop ax 
endm 
;Resta dos variables
mRestadb macro var1,var2
    push ax 
    xor ax,ax 
    mov al, var1 
    sub al, var2
    mov var1, al
    pop ax 
endm 
mRestaDw macro var1,var2
    push ax 
    xor ax,ax 
    mov ax, var1 
    sub ax, var2
    mov var1, ax
    pop ax 
endm 
;Multiplicacion
mMultiplicacionDw macro var1,var2
    push ax
    push bx 
    xor ax,ax 
    xor bx,bx 
    mov ax,var1
    mov bx, var2
    mul bx
    mov var1,ax  
    pop bx
    pop ax 
endm 

mDivisionDw macro var1,var2
    push ax
    push bx 
    push cx 
    push dx 
    xor ax,ax
    mov bx,ax  
    mov cx,ax 
    mov dx,ax 
    mov ax, var1
    mov bx, var2
    div bx
    mov var1, ax 
    pop dx 
    pop cx 
    pop bx 
    pop ax 
endm
;MOD 
mModdb macro var1,var2
    ;CUANDO SE LEEN ARCHIVOS LOS 4 REGISTROS SON AFECTADOS 
    push ax
    push bx 
    xor ax,ax
    mov bx,ax 
    mov al, var1
    mov bl, var2
    div bl
    mov var1, ah 
    pop bx 
    pop ax 
endm
MovVariablesDw macro var1,var2
    push dx
    mov dx,0
    mov dx,var2
    mov var1, dx ; SE INGRESA A LA NUEVA POSICION EL SIMBOLO ACTUAL
    pop dx 
endm

;ARCHIVOS 
mCrearFile macro nameFile
    local falloCT,salidaCT,salir 
    push ax
    mov cx,0    
    lea dx, nameFile
    mov ah, 3C
    int 21
    jc falloCT    
    mov handler, ax
    jmp salidaCT
    falloCT:
        mMostrarString savebad
        mov creacionCorrecta,0
        jmp salir
    salidaCT: ;sale del bucle
        ;mMostrarString savegood
        mov creacionCorrecta,1
        jmp salir
    salir:
    pop ax 
endm
;para escribir en un archivo externo
mWriteToFile macro palabra
    push ax 
    push bx 
    push cx 
    push dx 
    mov bx, handler
    mov cx, LENGTHOF palabra 
    mov dx, offset palabra
    mov ah,40
    int 21
    pop dx 
    pop cx 
    pop bx 
    pop ax 
endm
mReadFile macro varAlmacenadora
    push ax 
    push bx 
    push cx 
    push dx 
    mov bx, handler
    mov cx, 1 
    lea dx, varAlmacenadora ; esto seria igual a:  mov dx, offset lectura, "EN LA POSICION DE LECTURA GRABAR LO LEIDO"
    mov ah, 3F
    int 21
    mov posLectura, ax 
    pop dx 
    pop cx 
    pop bx 
    pop ax 
endm

;ARCHIVO
mOpenFile macro fileName
    local errorOpen,Opencorrecto,salidaOpen
    push ax 
    push dx 
    mov estadocarga,0
    mov al,0
    lea dx, fileName
    mov ah,3Dh
    int 21
    jc errorOpen
    mov handler, ax
    jmp Opencorrecto
    errorOpen:
        mMostrarString carbad
        mov estadocarga,0
        ;ESPERAR ENTER PARA VOLVER AL MENU
        mov ah, 01
        int 21 
        jmp salidaOpen
    Opencorrecto:
        ;mMostrarString cargood
        mov estadocarga,1
        ;ESPERAR ENTER PARA EMPEZAR A JUGAR
        mov ah, 01
        int 21 
        jmp salidaOpen
    salidaOpen:
    pop dx 
    pop ax 
endm

mOpenFile2Write macro fileName
    local errorOpen,Opencorrecto,salidaOpen
    push ax
    push dx 
    mov estadocarga,0
    mov al,2
    lea dx, fileName
    mov ah,3Dh
    int 21
    jc errorOpen
    mov handler, ax
    jmp Opencorrecto
    errorOpen:
        mMostrarString carbad
        mov estadocarga,0
        jmp salidaOpen
    Opencorrecto:
        ;mMostrarString cargood mCapturarFilaDoc Num2String
        mov estadocarga,1
        jmp salidaOpen
    salidaOpen:
    pop dx 
    pop ax 
endm
mHallarSimbolo macro simbolo 
    local buscar,salir 
    buscar:
        mReadFile eleActual 
        cmp posLectura,0  ;"LLEGO AL FINAL DEL DOCUMENTO?"
        je salir; si llego, salir del metodo sino seguir comparando 
        mComparar eleActual,simbolo ;buscando el simbolo buscado, si se hallo ya no se manda al ciclo buscar y se sale
        jne buscar
    salir:
endm 
; mEncontrarId
;MACROS PARA JUEGO ################################################################################

mDelayt macro tiempo
    local ciclodelay,segundo,salir 
    push ax 
    push dx 
    mov valort1,0
    mov auxt, 0 ;borrar
    mov contDb,0
    cmp tiempo,0 ;si el delay es de 0 salir por que indica que no hay delay por hacer
    je salir
    mov ah,2Ch
    int 21h
    mov valort1,dh  ;VALOR 1 TOMA UN TIEMPO INICIAL
    ciclodelay:
        ;segunda toma de tiempo 
        mov ah,2Ch
        int 21h
        mComparar valort1,dh  ;los tiempos son distintos (si es asi paso un segundo)
        jne segundo ;SI ESE ES EL CASO PASA A UN APARTADO DE CUANDO PASO 1 SEGUNDO
        jmp ciclodelay
        segundo:
            cmp contDb,tiempo ;CONTADOR ES IGUAL A EL TIEMPO REQUERIDO?
            je salir  ;SI, SALIR 
            mov valort1,dh ;si no es asi, mover el tiempo actual a la variable tiempo y repetir ciclo
            inc contDb; SE LE SUMA UNO AL CONTADOR 
            jmp ciclodelay
    salir: 
        pop dx
        pop ax 
endm 

mDelaytCenti macro tiempo
    local ciclodelay,centisegundo,salir 
    push ax 
    push dx 
    push bx 
    push cx 
    mov valort1,0
    mov auxt, 0 ;borrar
    mov contDb,0
    mov ah,2Ch
    int 21h
    mov valort1,dl  ;VALOR 1 TOMA UN TIEMPO INICIAL
    ciclodelay:
        ;segunda toma de tiempo 
        mov ah,2Ch
        int 21h
        mComparar valort1,dl  ;los tiempos son distintos (si es asi paso un centisegundo)
        jne centiSegundo ;SI ESE ES EL CASO PASA A UN APARTADO DE CUANDO PASO 1 centisegundo
        jmp ciclodelay
        centiSegundo:
            call pTimeOrd ;SI SE QUIERE USAR ESTA MACRO PARA CUALQUIER OTRA COSA, BORRAR ESTA LINEA 
            mComparar contDb,tiempo ;CONTADOR ES IGUAL A EL TIEMPO REQUERIDO?
            je salir  ;SI, SALIR 
            mov valort1,dl ;si no es asi, mover el tiempo actual a la variable tiempo y repetir ciclo
            inc contDb; SE LE SUMA UNO AL CONTADOR 
            jmp ciclodelay
    salir: 
        pop cx 
        pop bx 
        pop dx
        pop ax 
endm 
;debug
;mMostrarString eProgram
;call pEspEnter mEncontrarId


;APARTADO PARA EL JUEGO
mDrawPixel macro line,column,color 
    push ax
    push bx 
    push dx 
    push si 
    xor ax,ax
    xor bx,bx 
    xor dx,dx
    xor si,si 
   
    ;formula para pintar un pixel de la matriz video = ((linea-1) * 320) + (columna-1) 
    mov ax,line
    dec ax 
    mov bx, 320t
    mul bx
    ;en ax ya tengo el resultado del primer parentesis  
    add ax, column
    dec ax 

    mov si, ax 
    mov bl,color 
    mov es:[si],bl

    pop si
    pop dx
    pop bx 
    pop ax 
endm  
;MACRO PARA DECREMENTAR N CANTIDAD DE VECES UNA VARIABLE mUserExisteR
mDecVar macro var1,nveces
    local c1 
    push cx 
    mov cx,nveces
    c1: 
        dec var1
        loop c1 
    pop cx 
endm 
;MACRO PARA INCREMENTAR N CANTIDAD DE VECES UNA VARIABLE 
mIncVar macro var1,nveces
    local c1 
    push cx 
    mov cx,nveces
    c1: 
        inc var1
        loop c1 
    pop cx 
endm 

;MACRO PARA PINTAR UNA FILA DE PIXELES  mSumarDw
mDrawFila macro fila,column,color,nveces
    local c1 
    push cx 
    mov cx,nveces
    c1:    
        mDrawPixel fila,column,color 
        inc column 
        loop c1 
    pop cx 
endm 
;MACRO PARA DIBUJAR UN RECTANGULO 
mDrawRectangulo macro x,y,ancho,alto,color 
    local lineasup,barraslat,lineainf
    push cx 
    push bx 
    xor cx,cx
    xor bx,bx
    mov bx,y  ;auxiliar que tendra almacenada la variable y mSumarDw
    mov cordx,x
    mov cordy,y 

    mov cx,ancho 
    lineasup: ;se grafica la linea superior, imprimiendo y aumentando las columnas para generar una linea
        mDrawPixel cordx,cordy,color 
        inc cordy
        loop lineasup
    mov cordy,bx ; se regresa cordy a su valor original
    inc cordx ;se pasa a la siguiente fila 

    mov cx,alto ; se hara el siguiente procedimiento hasta que se cumpla el alto establecido 
    barraslat: ;se grafican las barras laterales 
        mDrawPixel cordx,cordy,color 
        mSumarDw cordy,ancho
        dec cordy
        mDrawPixel cordx,cordy,color 
        mov cordy,bx ;una vez hecho las dos impresiones siempre volver al valor original 
        inc cordx
        loop barraslat
    mov cx,ancho
    lineainf: 
        mDrawPixel cordx,cordy,color 
        inc cordy
        loop lineainf
    mov cordx,0
    mov cordy,0
    pop bx 
    pop cx 
endm 

;macro para dibujar espacios en negro para borrar rastros de movimiento 
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
;CAPTURA LA FILA ACTUAL DONDE SE ENCUENTRA EL CURSOR EN EL DOCUMENTO LEIDO EN UNA VARIABLE mOpenFile2Write
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
