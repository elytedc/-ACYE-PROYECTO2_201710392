include macro.asm   
.MODEL small
.STACK
.RADIX 16
.DATA
;APARTADO PARA LA DECLARACION DE VARIABLES Y LISTAS
mVariables
.CODE
;APARTADO PARA EL CODIGO
start:
    main proc
        call pFlujoProyecto2
    main endp

;MenuUsuario
pFlujoProyecto2 proc 
    call pAjustarMemoria
        ;call pBaseDatos ;comentar esto si no se quiere borrar la base de datos 
        call pLimpiarConsola
        mMostrarString mensajeI
         ;apartado de espera de un enter----------------------
            call pEspEnter
        ;---------------------------------------------------
        call pLimpiarConsola
        call pMenuPrincipal
    ;call pMenuOrd
    call pRetControl
    ret 
pFlujoProyecto2 endp 

;METODO PARA LIMPIAR LA CONSOLA 
pLimpiarConsola proc 
    push ax
    push bx
    push cx
    push dx 
    ;Limpia la consola 
    mov ax,0600h ; es igual a mov ah,06 (scroll up windows con el int 10)  y mov al,00
    mov bh, 07   
    mov cx, 00000  ; es igual a mov ch,0   mov cl, 0 , filas y coumnas de derecha a izquierda
    mov dx, 184FH  ;filas y columnas de both 
    int 10
    ;posiciona el cursor en la pos 0
    mov ah, 02
    mov bh,0  ;numero de pagina
    mov dl,0   ;columna
    mov dh,0   ;fila 
    int 10
    pop dx
    pop cx
    pop bx
    pop ax 
    ret 
pLimpiarConsola  endp 
;PROC PARA DEVOLVER EL CONTROL AL SISTEMA
pRetControl proc
    mov al, 10  
    mov ah, 4C  
    int 21
    ret
pRetControl endp
;PROC PARA AJUSTAR LA MEMORIA AL SISTEMA
pAjustarMemoria proc 
    mov dx, @DATA
    mov ds,dx
    mov es,dx
    ret
pAjustarMemoria endp
;PROC PARA CREAR BASE DE DATOS (USUARIOS Y SCORES)
pBaseDatos proc
    mCrearFile usersb
    mWriteToFile adminG
    call pCloseFile
    mCrearFile scoresb
    mWriteToFile espacioL
    call pCloseFile
    ret 
pBaseDatos endp 
;IMPRIMIR NOMBRE DE USUARIO ACTUAL  ARRIBA A LA DERECHA DE CADA MENU
pImprimirUser proc
    push ax 
    push dx 
    push bx 
    mov ah, 02
    mov bh,0  ;numero de pagina
    mov dl,30t   ;columna
    mov dh,0   ;fila 
    int 10
    mMostrarString msguser
    mMostrarString UsuarioI  
    mov ah, 02
    mov bh,0  ;numero de pagina
    mov dl,0   ;columna
    mov dh,1   ;fila 
    int 10
    mMostrarString sepRepOrden;LINEA SEPARADORA ENTRE LOS CABEZALES Y EL MENU
    pop bx 
    pop dx 
    pop ax 
    ret
pImprimirUser endp 

;MENU PRINCIPAL  
pMenuPrincipal proc    
    ciclomenu: 
        mov opcion,0
        mMostrarString Menu
        ;la laptop que se posee para trabajar esto necesita de presionar una tecla antes de los FN
        ; para que los reconozca por tal motivo s   e hizo esto dos veces para que se pudiera a trapar el valor de Fn
        mov ah,01
        int 21
        mov opcion,al
        cmp opcion,31h
        je Login
        cmp opcion,32h
        je Register
        cmp opcion, 33h
        je salir
        mMostrarString opi
        jmp ciclomenu
    Login:
        call pLogin
        call pLimpiarConsola
        jmp ciclomenu
    Register:
        call pResetFlagsE ;RESETEA LAS BANDERAS QUE DETECTAN DE ERRORES A LA HORA DE REGISTRAR
        call pRegistrar
        call pLimpiarConsola
        jmp ciclomenu   
    salir: 
        call pLimpiarConsola
    ret 
pMenuPrincipal endp 

;LOGIN 
pLogin proc 
    call pResetFlagsE
    mOpenFile2Write usersb ;abre el archivo de users
    cicloLogin:
    ;call pLimpiarConsola
    call pInidoc ;COLOCAR EL PUNTERO AL INICIO DEL DOCUMENTO 
    mLimpiar UsuarioI,25,24 ;limpia el espacio para  almacenar el usuario ingresado
    mLimpiar PasswordI,25,24 ;limpia el espacio donde se almacenara temporalmente la contra ingresada
    mMostrarString msgLogin ;muestra mesaje de login
    mMostrarString msgexit
    ;captura de usuario y contraseña 
    mMostrarString rU
    mCapturarString UsuarioI
    mMostrarString rP 
    mCapturarString PasswordI
    ;ADMIN PRINCIPAL==================================================
    cmp UsuarioI[0],09 ;tab=Exit  ;POR SI SE QUIERE SALIR DEL MENU 
    je exitab
    mReadFile eleActual
    mEncontrarId UsuarioI
    cmp idEncontrado,0
    je noesadmin
    esadmin: ;ES EL ADMIN PRINCIPAL
        mHallarSimbolo ";" ;pasa al separador que esta alapar de contraseña
        mReadFile eleActual;se salta el separador
        mEncontrarId PasswordI;verificar si la contraseña es la correcta 
        cmp idEncontrado,0
        je PasswordIncorrect
        ;USUARIO GENERAL PRINCIPAL==========================================
        cAdminCor:;password de admin correcta
            ;call pQuitarbloqAdmin ;al ingresar la contraseña correcta tanto nveces error y bloqueo se vuelven a su valor default
            call pCloseFile
            call pLimpiarConsola
            call pMenuAdmin
            jmp salir 
    ;USUARIO O USUARIO ADMIN==================================================
    noesadmin: ;ENTONCES ES UN USUARIO NORMAL o ADMIN SECUNDARIO 
        mUserExiste UsuarioI
        cmp existee,0 ;EXISTE USUARIO?
        je Noexiste  ;NO EXISTE
        ;luego del metodo mUserExiste  estara posicionado justo en la linea deseada
        mHallarSimbolo ";" ;Separador alapar de contraseña 
        mReadFile eleActual ;Primer elemento de contraseña 
        mEncontrarId PasswordI
        cmp idEncontrado,1
        jne PasswordIncorrect
        je PasswordCorrect
        ;EXISTE?
    PasswordCorrect:
        jmp UsuarioNormal
    ;USUARIO NORMAL=================================================
    UsuarioNormal: 
        call pCloseFile
        call pLimpiarConsola
        call pMenuUser ;MUESTRA MENU CORRESPONDIENTE  
        jmp salir 
    ;USUARIO ADMIN==================================================
    Usuarioadmin: 
        call pCloseFile
        call pLimpiarConsola
        call pMenuU_admin ;MUESTRA MENU CORRESPONDIENTE
        jmp salir        
    
    PasswordIncorrect:
        ;LE SUMA UNO AL NUMERO DE ERRORES 
        mMostrarString msgPinc
        ;call pIncVEquivoco
        ;call pDarbloqueo
        ;call pEspEnter
        ;SABER SI ES ADMIN O NO, AQUI YA RECORRIO LA POSICION DE NVECES ERROR Y LA DE BLOQUEO CON
        ;UN SOLO HALLAR SIMBOLO SE PASARIA AL APARTADO PARA SABER SI ES ADMIN O NO
        ;mHallarSimbolo 01
        ;mReadFile eleActual
        ;cmp eleActual,"A"
        ;je PasswordIAdmin;SI ES ADMIN
        ;SI NO SEGUIR 
        jmp cicloLogin

    Noexiste:
        mMostrarString msgUnE ;MENSAJE USUARIO NO EXISTE 
        ;call pEspEnter
        jmp cicloLogin
    ;NO EXISTE
    exitab:
        call pCloseFile
    salir:
    ret 
pLogin endp  

;REGISTER 
pRegistrar proc  
    mov eerror,0
    mLimpiar UsuarioRegis,25,24
    mLimpiar PasswordRegis,25,24
    call pLimpiarConsola
    mMostrarString msgRegister
    mMostrarString rU
    mCapturarString UsuarioRegis
    mMostrarString rP
    mCapturarPassword PasswordRegis
    ;RESTRICCIONES 
    mUserInicial
    mSizeUser
    mUserExisteR
    ;mRequisitoCletra
    ;mAMayus
    mANum
    ;mASigno
    mSizePassword 
    ;EXISTE ERROR?
    mComparar eerror,1
    je ErrorRegistro
    jne noErrorRegistro
    ErrorRegistro:
        mMostrarString ActionR
        ;NUMERO INICIAL
        mComparar numinicio,0
        je nNinicial
        yNinicial:;error posee un numero en su caracter incial
            mMostrarString msginitialbad 
        nNinicial:; no posee error de este tipo
        
        mComparar largoe,0
        je nLerornea
        ;LONGITUD ERRONEA
        yLerronea: ; posee error 
            mMostrarString msglengtherror
        nLerornea:; no posee error de este tipo
        
        ;USUARIO EXISTENTE
        mComparar existee,0
        je nUexist
        yUexist:;usuario existe
            mMostrarString msgUExist
        nUexist:; no posee error de este tipo

        ;CARACTERES ESPECIALES NO PERMITIDOS PRESENTES
        mComparar caractNp,0
        je nCnexist
        yCnexist: ; error carateres especiales no permitidos presentes
            mMostrarString msgCaractP
        nCnexist: ; no posee error de este tipo
        
        ;PASSWORD SIN AL MENOS UNA MAYUSCULA
        mComparar mayuse,0
        je nPsm
        yPsm:; Password sin mayuscula
            mMostrarString msgunaM
        nPsm:; no posee error de este tipo
        
        ;PASSWORD SIN AL MENOS UN NUMERO
        mComparar nume,0
        je nPsn
        yPsn: ; Password sin numero
            mMostrarString msgunN
        nPsn:; no posee error de este tipo
        
        ;PASWORD SI AL MENOS UN SIMBOLO ESPECIAL(!>%;*)
        mComparar sinCaractE,0
        je nPss
        yPss: ;password sin simbolos
            mMostrarString msgunS
        nPss:; no posee error de este tipo
        
        ;PASSWORD CON LONGITUD ERRONEA
        mComparar largoe2,0
        je nPlongitud
        yPlongitud:; hay error respecto a la longitud 
            mMostrarString msglengtherror2
        nPlongitud:; no posee error de este tipo

        call pEspEnter
        jmp salir 

    noErrorRegistro: ;registro sin error
        call pAlmacenaruser
        mMostrarString RUSucces
        call pEspEnter
    salir: 
    ret 
pRegistrar endp

;---------------------------------MENUS PARA LOS DISTINTOS TIPOS DE USUARIOS 
;MENU PARA EL ADMIN GENERAL
pMenuAdmin proc 
    push ax 
    mOpenFile2Write usersb 
    ciclomenu:
    call pResetFlagsE
    mMostrarString msgMenuAdmin ;MENU ADMIN
    call pImprimirUser ;IMPRIMIR NOMBRE DE USUARIO ACTUAL 
    mMostrarString MenuAdmin  ;MUESTRA EL MENU 
    mov opcion,0
    ;la laptop que se posee para trabajar esto necesita de presionar una tecla antes de los FN
    ; para que los reconozca por tal motivo se hizo esto dos veces para que se pudiera a trapar el valor de Fn
    mov ah,01
    int 21;atrapa la tecla fn 
    mov opcion,al
    cmp opcion, 31h
    je pShowtop10
    cmp opcion, 32h
    je pShowtop10
    cmp opcion, 33h
    je Bublesort
    cmp opcion, 34h
    je Bublesort
    cmp opcion, 35h
    je salir 
    mMostrarString opi
    jmp ciclomenu
    unlockUser:
        call pQuitarbloqueo
        call pLimpiarConsola
        jmp ciclomenu
    darAdmin:
        call pDarAdmin
        call pLimpiarConsola
        jmp ciclomenu
    quitarAdmin:
        call pQuitarAdmin
        call pLimpiarConsola
        jmp ciclomenu
    Bublesort:
        call pMenuOrd
        jmp ciclomenu
    heapsort:
        jmp Bublesort ;CAMBIAR ESTA LINEA SI DICHO ORDENAMIENTO HUBIERA SIDO TRABAJADO
    Timsort:
        jmp Bublesort ;CAMBIAR ESTA LINEA SI DICHO ORDENAMIENTO HUBIERA SIDO TRABAJADO
    salir:
        pop ax 
    ret 
pMenuAdmin endp 

;MENU PARA EL USUARIO NORMAL
pMenuUser proc 
    menuUser: 
    ;MENU DE USUARIO 
    mMostrarString msgMenuU  ;MENU DE USUARIO NORMAL
    call pImprimirUser ;IMPRIMIR NOMBRE DE USUARIO ACTUAL  
    mMostrarString MenuUsuario ;IMPRESION DE MENU USUARIO 
    mov opcion,0
    ;la laptop que se posee para trabajar esto necesita de presionar una tecla antes de los FN
    ; para que los reconozca por tal motivo se hizo esto dos veces para que se pudiera a trapar el valor de Fn
    mov ah,01
    int 21

    mov opcion,al
    cmp opcion, 31h
    je game
    cmp opcion, 32h
    je totalscorboard
    ;cmp opcion, 33h
    ;je myscorboards
    cmp opcion, 33h
    je salir 
    mMostrarString opi
    jmp menuUser
    game:
        call pGame ;llama al juego 
        call pAlmacenarScore ;almacena el score 
        jmp menuUser
    totalscorboard:
        call pShowtop10
        jmp menuUser
    myscorboards:
        call pShowMytop10
        jmp menuUser
    salir: 
    ret 
pMenuUser endp 

;MENU PARA EL USUARIO ADMIN
pMenuU_admin proc  
    ciclomenu:
    mMostrarString msgMuA   ;TITULO: MENU DE USUARIO ADMIN
    call pImprimirUser ;IMPRIMIR NOMBRE DE USUARIO ACTUAL 
    mMostrarString MenuUsuarioAdmin ;OPCIONES DEL MENU DE USUARIO ADMIN 
    mov opcion,0
    ;la laptop que se posee para trabajar esto necesita de presionar una tecla antes de los FN
    ; para que los reconozca por tal motivo se hizo esto dos veces para que se pudiera a trapar el valor de Fn
    mov ah,01
    int 21
    mov opcion,al
    cmp opcion, 59t
    je unlockUser
    cmp opcion, 37h
    je totalscorboard
    cmp opcion, 31h
    je myscorboards
    cmp opcion, 32h
    je game 
    cmp opcion, 33h
    je Bublesort
    cmp opcion, 34h
    je heapsort
    cmp opcion, 35h
    je Timsort
    cmp opcion, 36h
    je salir 
    mMostrarString opi
    jmp ciclomenu
    unlockUser:
        call pQuitarbloqueo
        call pLimpiarConsola
        jmp ciclomenu
    totalscorboard:
        call pShowtop10
        jmp ciclomenu
    myscorboards:
        call pShowMytop10
        jmp ciclomenu
    game:
        call pGame ;llama al juego 
        call pAlmacenarScore ;almacena el score
        jmp ciclomenu
    Bublesort:
        call pMenuOrd
        jmp ciclomenu
    heapsort:
        jmp Bublesort ;CAMBIAR ESTA LINEA SI DICHO ORDENAMIENTO HUBIERA SIDO TRABAJADO
    Timsort:
        jmp Bublesort ;CAMBIAR ESTA LINEA SI DICHO ORDENAMIENTO HUBIERA SIDO TRABAJADO
    salir:
    ret 
pMenuU_admin endp  

;PROC PARA DELAY DE 30 SEGUNDOS CON IMPRESION DE SEGUNDOS EN LA CONSOLA 
pDelay30 proc  
    push ax 
    push dx 
    mov valort1,0
    mov contadort,0
    ;SE TOMA EL VALOR DE T1 
    mov ah,2Ch
    int 21h
    mov valort1,dh  ;VALOR 1 TOMA UN TIEMPO INICIAL
    ciclodelay:
        mov ah,2Ch
        int 21h
        mComparar valort1,dh ;EL CICLO SE REPETIRA HASTA QUE SEAN DISTINTOS
        jne segundo ;ES DISTINTO POR LO CUAL YA CAMBIO DE SEGUNDO 
        jmp ciclodelay
        segundo:      
            mLimpiar StringNumT,4,24 ;SE LIMPIA EL STRING QUE ALMACENARA EL SEGUNDO
            Num2String contadort,StringNumT ;SE PASA EL CONTADOR ACTUAL A STRING 
            mMostrarString StringNumT ;SE IMPRIME EL STRING DEL CONTADOR  
            cmp contadort,30t ;CONTADOR ES IGUAL A 30?
            je salir  ;SI, SALIR 
            MovVariables valort1,dh ;NO, ENTONCES VALORT1=auxt (que contiene el valor2 sin el efecto de mod)
            inc contadort ; SE LE SUMA UNO AL CONTADOR 
            jmp ciclodelay
    salir: 
        pop dx
        pop ax 
    ret 
pDelay30 endp 

;ALMACENA EL USUARIO ACTUAL EN EL ARCHIVO DE USERS
pAlmacenaruser proc
    mOpenFile2Write usersb
    call pFinaldoc
    mWriteToFile UsuarioRegis
    mWriteToFile separador
    mWriteToFile PasswordRegis
    ;mWriteToFile separador
    ;mWriteToFile Numerrordef
    ;mWriteToFile separador 
    ;mWriteToFile Bloqdef
    ;mWriteToFile separador
    ;mWriteToFile admindef
    mWriteToFile enterg 
    call pCloseFile
    ret 
pAlmacenaruser endp 

;ALMACENA EL SCORE ACTUAL  EN EL ARCHIVO DE SCORES 
pAlmacenarScore proc
    mLimpiar segGameReporteS,5,0
    Num2String segGameReporte,segGameReporteS
    mOpenFile2Write scoresb
    call pFinaldoc
    mWriteToFile NameUserG
    mWriteToFile separador
    mWriteToFile nivelGameS
    mWriteToFile separador
    mWriteToFile scoreGString
    mWriteToFile separador
    mWriteToFile segGameReporteS
    mWriteToFile enterg 
    call pCloseFile
    ret 
pAlmacenarScore endp 

pEspEnter proc
    push ax 
    cicloEspEnter:
        mMostrarString espEnter
        mov ah,01
        int 21
        cmp al,0dh
        jne cicloEspEnter ; SI NO ES UN ENTER SE REPETIRA EL CICLO
    pop ax 
    ret 
pEspEnter endp
;RESETEAR LAS BANDERA QUE INDICAN LOS ERRORES EN EL REGISTRO 
pResetFlagsE proc
    ;ERRORES USUARIO
    mov numinicio,0  
    mov largoe,0  
    mov existee,0  
    mov caractNp,0   ;caracteres no permitidos para el usuario
    ;CARACTERISTICAS PASSWORD
    mov mayuse,0 
    mov nume,0  
    mov sinCaractE,0  ;caracteres especiales faltantes en la contraseña
    mov largoe2,0  
    ;default del indicador de si la variable analizada esta en un rango en especifico 
    mov enrango,0 
    ;BANDERAS QUE HUBIERON ERRORES
    mov eerror,0 
    mov contadoraux,0 
    ret 
pResetFlagsE endp

;PROCEDIMIENTOS PARA MANIPULAR O MOVERSE EN UN DOCUMENTO EXTERNO 
;cx: me coloco en esta posicion --- dx: me mueve tantas cantidades de posiciones desde la posicion de cx
;cx:1 me quedo en la posicion actual  dx:  me mueve tantas cantidades de posiciones desde la posicion de cx
;cx:0 inicio
;cx:2 final de archivo
pInidoc proc
    push ax 
    push bx 
    push cx 
    push dx 
    mov al,0
    mov bx,handler
    mov cx,0
    mov dx,0
    mov ah,42h
    int 21 
    pop dx 
    pop cx 
    pop bx 
    pop ax 
    ret
pInidoc endp 

pFinaldoc proc
    push ax 
    push bx
    push cx 
    mov al,2
    mov bx,handler
    mov cx,-1
    mov dx,-1
    mov ah,42h
    int 21 
    pop cx 
    pop bx 
    pop ax 
    ret
pFinaldoc endp 

;coloca el documento una posiciona anterior al lugar actual leido 
pPosAnterior proc
    mov al,1
    mov bx,handler
    mov cx,-1
    mov dx,-1
    mov ah,42h
    int 21 
    ret
pPosAnterior endp 

pCloseFile proc 
    push bx 
    push ax 
    mov bx, handler
    mov ah, 3Eh
    int 21
    pop ax 
    pop bx 
    ret 
pCloseFile endp 

;user db "Nombre",01,"Contraseña",01,Numero de veces que se equivoco,01,"Bloqueado/n","Admin/n" enter (0A)
   
;AUMENTA EL NUMERO DE VECES QUE SE EQUIVOCO
pIncVEquivoco proc
    mHallarSimbolo separador ; esta situado en la posicion de contraseña solo es necesario buscar una vez el separador 
    mReadFile eleActual; saltarse el separador 
    cmp eleActual,33h ;no se suma si es exactamente 3 el numero de veces que se equivoco
    je salir 
    mSumardb eleActual,1
    call pPosAnterior
    mWriteToFile eleActual
    salir: 
    ret 
pIncVEquivoco endp 

;DAR BLOQUEO 
pDarbloqueo proc 
    ;ya que dar bloqueo va despues de incrementar veces que se equivoco solo se busca una vez el separador
    cmp eleActual,33h
    jne nobloquear 
    mHallarSimbolo separador
    mWriteToFile BloqueoU
    jmp salir 
    nobloquear: ;si no se bloquea al menos se debe de desplazar la misma cantidad de espacios de como
    ;si se hubiera bloqueado 
        mHallarSimbolo separador
        mReadFile eleActual
    salir: 
    ret 
pDarbloqueo endp

;QUITAR BLOQUEO ADMIN
pQuitarbloqAdmin proc
    mHallarSimbolo separador
    mWriteToFile Nequivdef ;numero de veces que se equivoco, en este caso se le asigna 0
    mHallarSimbolo separador
    mWriteToFile Bloqdef ;bloqueado o no bloqueado, en este caso se le asigna Bloqueado 
    ret
pQuitarbloqAdmin endp 


;QUITAR BLOQUEO
pQuitarbloqueo proc
    call pLimpiarConsola
    mMostrarString msgUnlockUserT ;IMPRIMIR TITULO DEL APARTADO  
    call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
    mLimpiar Umoderado,25,24
    mOpenFile2Write usersb 
    call pResetFlagsE
    mMostrarString usDesBloq
    mCapturarString Umoderado; CAPTURAR STRING DE USUARIO
    call pExisteUserM
    cmp existee,0 ;no existe el usuario ingresado?
    je Unoexiste ; no existe, entonces marca error y se sale
    ;SI EXISTE, ENTONCES EL ARCHIVO YA SE ENCUENTRA POSICIONADO EN EL ESPACIO DESEADO 
    mHallarSimbolo separador; contraseña
    mHallarSimbolo separador ; n veces error
    mHallarSimbolo separador; B/n 
    mReadFile eleActual
    cmp eleActual, "N" ; no bloqueado
    je noBloqAnt
    call pPosAnterior ; separador antes de B/n
    call pPosAnterior ;n veces error
    call pPosAnterior ; separador antes de n veces eror
    mWriteToFile Nequivdef
    mHallarSimbolo 01
    mWriteToFile Bloqdef
    mMostrarString Udesbloqueado
    call pEspEnter
    jmp salir 
    noBloqAnt:
        mMostrarString Unoblock ;el usuario no estaba bloqueado 
        call pEspEnter
        jmp salir 
    Unoexiste:
    mMostrarString MsgUnE ;usuario no existe
    call pEspEnter
    jmp salir 
    salir: 
    call pCloseFile
    ret
pQuitarbloqueo endp 

;DAR ADMIN
pDarAdmin proc 
    call pLimpiarConsola
    mMostrarString msgPromoteAdmin;IMPRIMIR TITULO DEL APARTADO  
    call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
    mLimpiar Umoderado,25,24
    mOpenFile2Write usersb
    call pResetFlagsE
    mMostrarString usDarAdmin
    mCapturarString Umoderado; CAPTURAR STRING DE USUARIO
    call pExisteUserM
    cmp existee,0 ;no existe el usuario ingresado?
    je Unoexiste ; no existe, entonces marca error y se sale
    ;SI EXISTE, ENTONCES EL ARCHIVO YA SE ENCUENTRA POSICIONADO EN EL ESPACIO DESEADO 
    mHallarSimbolo separador; contraseña
    mHallarSimbolo separador ; n veces error
    mHallarSimbolo separador; B/n 
    mHallarSimbolo separador; separador antes de Admin/No admin 
    mReadFile eleActual
    cmp eleActual, "A" ; el elemento es admin
    je AdminAnt
    call pPosAnterior ; separador antes de Admin/No admin
    mWriteToFile AdminU
    mMostrarString Udadoadmin
    call pEspEnter
    jmp salir 
    AdminAnt:
        mMostrarString Uadmin ;el usuario ya era admin
        call pEspEnter
        jmp salir 
    Unoexiste:
    mMostrarString MsgUnE ;usuario no existe
    call pEspEnter
    jmp salir 
    salir: 
    call pCloseFile
    ret
pDarAdmin endp 

;QUITAR ADMIN
pQuitarAdmin proc
    call pLimpiarConsola ;LIMPIA LA CONSOLA 
    mMostrarString msgDemoteAdmin ;IMPRIMIR TITULO DEL APARTADO  
    call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
    mLimpiar Umoderado,25,24 ;Limpiar la variable donde se almacenara el usuario a quitar admin 
    mOpenFile2Write usersb ;ABRE EL ARCHIVO DE USUARIOS PARA LEER Y ESCRIBIR 
    call pResetFlagsE ;RESETEA TODAS LAS BANDERAS 

    mMostrarString usQuitarAdmin ;MENSAJE PARA QUITAR ADMIN 
    mCapturarString Umoderado; CAPTURAR STRING DE USUARIO
    mCompararStrings Umoderado,nameAdminG
    cmp cadIguales, 1
    je Admin_G

    call pExisteUserM ;EXISTE USUARIO?
    cmp existee,0 ;no existe el usuario 
    je U_noexiste ; no existe, entonces marca error y se sale
    ;SI EXISTE, ENTONCES EL ARCHIVO YA SE ENCUENTRA POSICIONADO EN EL ESPACIO DESEADO 
    mHallarSimbolo separador; contraseña
    mHallarSimbolo separador ; n veces error
    mHallarSimbolo separador; B/n 
    mHallarSimbolo separador; separador antes de Admin/No admin 
    mReadFile eleActual
    cmp eleActual, "N" ; el elemento es admin para poder degradarlo?
    je AdminAnt ;el elemento no es admin, por tal motivo no es posible degradarlo
    call pPosAnterior ; separador antes de Admin/No admin
    mWriteToFile admindef
    mMostrarString UquitAdmin
    call pEspEnter
    jmp salir 
    AdminAnt:
        mMostrarString uNoAdmin ;el usuario no era admin
        call pEspEnter
        jmp salir 
    U_noexiste:
        mMostrarString MsgUnE ;usuario no existe
        call pEspEnter
        jmp salir 
    Admin_G:;se intento quitar el admin al admin general 
        mMostrarString msgQuitAdminG
        call pEspEnter
        jmp salir 
    salir: 
    call pCloseFile
    ret

pQuitarAdmin endp 

pExisteUserM proc 
    ;SE VERIFICA SI NO ES EL ADMIN
    mReadFile eleActual ;TOMA EL PRIMER VALOR DEL ARCHIVO 
    mEncontrarId Umoderado;lo primero en el documento de usuarios es el admin, que siempre estara aca
    cmp idEncontrado,1 ; se encontro usuario? 
    je Existe ;si se encontro se procede a decir que si existe el usuario y se marcara como error
    cicloexiste: ;caso contrario se procedera a un ciclo de lectura del archivo hasta hallar o un espacio o el id buscado
        mHallarSimbolo 0A  ;se salta hasta el enter hasta la posicion donde esta 0A
        mReadFile eleActual ; se corre una vez el elemento 
        cmp eleActual," " ;si hay un espacio es que ya se llego al fin del documento y el usuario no existe
        ;CADA VEZ QUE SE CREA UN USUARIO SE ELIMINA EL ULTIMO ESPACIO QUE DEJA LA CREACION DEL USUARIO ANTERIOR
        je Noexiste ; no existe usuario
        mEncontrarId Umoderado ;si no es espacio lo que esta en esta posicion fijo es un nombre de user, el user a registrar  es igual a este? 
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
    ret 
pExisteUserM endp 



;APARTADO PARA EL JUEGO #######################################################################################

;POR DEFAULT DOSBOX SE MANEJA CON EL TEXT MODE, SI SE DESEA VOLVER AL MODO NORMAL LUEGO DEL MODO VIDEO VOLVER
;A INSTANCIAR ESTE METODO 
pTextMode proc
    push ax
    mov ax, 03
    int 10h
    pop ax 
    ret 
pTextMode endp 
;PARA EL JUEGO SE DEBE DE CAMBIAR A MODO VIDEO 
pVideoMode proc
    push ax
    mov ax, 13
    int 10h
    pop ax 
    ret 
pVideoMode endp 
;PARA PONER LA MEMORIA DE VIDEO EN "ES" 
pMemVideoMode proc
    push dx
    mov dx, 0A000
    mov es,dx 
    pop dx 
    ret 
pMemVideoMode endp 
;METODO PARA PONER EL SEGMENTO DE DATOS EN "ES" 
pDataS_ES proc
    push dx
    mov dx, @DATA
    mov es,dx 
    pop dx 
    ret 
pDataS_ES endp 

pGame proc
    call pMemVideoMode
    call pVideoMode 
    call pMovimientoGame
    call pTextMode
    ret
pGame endp

;#########################################################################################
pMovimientoGame proc
    mov auxfpsT,0
    reset: 
        call pConfigIni   
    fps: ;ciclo que provoca un movimiento cada centisegundo letN1
        mov ah,2Ch
        int 21
        cmp dl, auxfpsT
        je fps
    mov auxfpsT, dl
    ;call pDrawCleansCorazones
    ;call pDrawCorazones 

    cmp unidad,7 ; si se finalizo el 3 nivel, nivelgame llegara a 4 indicando que finalizo el juego 
    je win1
    jmp seguir
    
    win1:
        cmp decena,2 ; si se finalizo el 3 nivel, nivelgame llegara a 4 indicando que finalizo el juego 
        je win
        

    seguir:
        cmp liNave,0 ;si la vida de la nave llego a 0 es game over 
        je gameover

        ;MOVIMIENTO 
        ;call pLevel 
        call pScore
        call pTimeGame
        call pvida
        ;MOVIMIENTOS DE LA NAVE 
        call pMovNave
        call pDrawNaveBorr
        call pDrawNave
        cmp exitGame,1 ; si luego de una pausa se selecciono en salir del juego 
        je salir 

        ;IMPRESION DE ENEMIGOS-NIVELES  
        cmp printEnemyE,1 ;SI YA SE IMPRIMIO NO VOLVER A IMPRIMIR 
        je yaimpresoEnemy
        ;SE ESPERA A QUE EL USUARIO PRESIONE ESPACIO PARA PODER IMPRIMIR LOS ENEMIGOS Y SEGUIR CON EL RESTO DEL JUEGO  
            call pEspInicial
            ;mDelayt 1t  ;DELAY ANTES DE EMEPEZAR CADA NIVEL, ESTE DELAY ES DE 1 SEGUNDO 
        call pDrawEnemigos ;SE IMPRIME ENEMIGOS 
        mov printEnemyE,1 ;SE MARCA QUE YA SE IMPRIMIO 
        ;COORDENADAS INICIALES PARA EL MOVIMIENTO DE ENEMIGOS    
            mov ce_x,45t
            mMultiplicacionDw ce_x,nivelGame
            mov ce_y, 140t
            mov filaIgame,45t  ;auxiliar que contendra la fila actual recorrida 
            mMultiplicacionDw filaIgame,nivelGame
        yaimpresoEnemy: 
        call pMovEnemys ;mover enemigos 

        ;MOVIMIENTO DE BALAS
        ;BALA 1 
            cmp estD1,0 ;no se tiene permitido imprimir la bala 
            je sinAccion
            ;si se tiene permitido disparar la bala 
                call pMovbala
            sinAccion: 
            cmp nivelGame,1
            je fps 

    
     win:
        ;mImprimirLetreros letGover,10t,23t,15t ;imprimir letrero de game over 
        mImprimirLetreros letEsp,12t,18t,15t ;mensaje indicando accion a realizar 
        mWaitKey " "
        call pScore
        Jmp salir

    gameover:
        mImprimirLetreros letGover,10t,23t,15t ;imprimir letrero de game over 
        ;mImprimirLetreros letEsp,12t,18t,15t ;mensaje indicando accion a realizar 
        mWaitKey " "
    salir:
    ret 
pMovimientoGame endp 


;DRAW--------------------------------------------------------------------------------
pDrawCorazon proc
    push ax 
    push dx 
    mov ax,corazonx
    mov dx, corazony
    ;punta corazon 
    mDrawPixel corazonx,corazony,39t ;rojo
    ;fila de arriba 
    dec corazonx
    dec corazony
    mDrawFila corazonx,corazony,39t,3t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,4t 
    mDrawFila corazonx,corazony,39t,5t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,39t,7t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,7t
    mDrawFila corazonx,corazony,39t,7t
    ;fila de arriba  
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,39t,2t
    inc corazony
    mDrawFila corazonx,corazony,39t,2t
    mov corazonx,ax 
    mov corazony,dx 
    pop dx 
    pop ax 
    ret 
pDrawCorazon endp 


paso proc
ret 
paso endp 
pDrawCleanCorazon proc
    push ax 
    push dx 
    mov ax,corazonx
    mov dx, corazony
    ;punta corazon 
    mDrawPixel corazonx,corazony,0t ;rojo
    ;fila de arriba 
    dec corazonx
    dec corazony
    mDrawFila corazonx,corazony,0t,3t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,4t 
    mDrawFila corazonx,corazony,0t,5t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,0t,7t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,7t
    mDrawFila corazonx,corazony,0t,7t
    ;fila de arriba  
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,0t,2t
    inc corazony
    mDrawFila corazonx,corazony,0t,2t
    mov corazonx,ax 
    mov corazony,dx 
    pop dx 
    pop ax 
    ret 
pDrawCleanCorazon endp 

pDrawEnemigo1 proc
    ;punta sur del enemigo
    push ax
    push dx  
    mov ax, ce_x
    mov dx, ce_y
    mDecVar ce_y,4
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    ;mIncVar ce_y,7
    mDrawPixel ce_x,ce_y,01


    ;fila anterior 
    dec ce_x
    mDecVar ce_y,8
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y

    ;fila anterior
    dec ce_x
    mDecVar ce_y,8
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01t,2t
    mDrawPixel ce_x,ce_y,01  ; aqui ççççççççççççççççççççççç
    inc ce_y
     mDrawPixel ce_x,ce_y,39t
     inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y


    ;fila anterior
    dec ce_x
    mDecVar ce_y,6
    mDrawFila ce_x,ce_y,01,7t  ; imprime uno de mas
    ;fila anterior


    dec ce_x
    mDecVar ce_y,9
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01,2t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01  ; aqui 2
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    dec ce_y

    ;fila anterior 



    dec ce_x
    ;mDecVar ce_y,4t
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
   ; mDrawPixel ce_x,ce_y,39t
    dec ce_y
    inc ce_y
    inc ce_y
     inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawFila ce_x,ce_y,01,3t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y
    dec ce_y


    ;antenas
    dec ce_x
    mDecVar ce_y,7
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 
    inc ce_y

    mDrawPixel ce_x,ce_y,39t
    ;mIncVar ce_y,5t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t 
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 

    mov ce_x,ax
    mov ce_y,dx
    pop dx
    pop ax
    ret 
pDrawEnemigo1 endp 

pDrawEnemigo2 proc 
    push ax
    push dx
    ;mov ce_x,40t 
    ;mov ce_y,140t   
    mov ax, ce_x
    mov dx, ce_y
    
   

   mDecVar ce_y,4
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    ;mIncVar ce_y,7
    mDrawPixel ce_x,ce_y,01


    ;fila anterior 
    dec ce_x
    mDecVar ce_y,8
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y

    ;fila anterior
    dec ce_x
    mDecVar ce_y,8
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01t,2t
    mDrawPixel ce_x,ce_y,01  ; aqui ççççççççççççççççççççççç
    inc ce_y
     mDrawPixel ce_x,ce_y,39t
     inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y


    ;fila anterior
    dec ce_x
    mDecVar ce_y,6
    mDrawFila ce_x,ce_y,01,7t  ; imprime uno de mas
    ;fila anterior


    dec ce_x
    mDecVar ce_y,9
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01,2t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01  ; aqui 2
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    dec ce_y

    ;fila anterior 



    dec ce_x
    ;mDecVar ce_y,4t
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
   ; mDrawPixel ce_x,ce_y,39t
    dec ce_y
    inc ce_y
    inc ce_y
     inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawFila ce_x,ce_y,01,3t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y
    dec ce_y


    ;antenas
    dec ce_x
    mDecVar ce_y,7
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 
    inc ce_y

    mDrawPixel ce_x,ce_y,39t
    ;mIncVar ce_y,5t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t 
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 



    mov ce_x,ax
    mov ce_y,dx
    pop dx
    pop ax
    
    ret 
pDrawEnemigo2 endp

pDrawEnemigo3 proc
    push ax
    push dx
    ;mov ce_x,50t  
    ;mov ce_y,140t   
    mov ax, ce_x
    mov dx, ce_y

    mDecVar ce_y,4
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    ;mIncVar ce_y,7
    mDrawPixel ce_x,ce_y,01


    ;fila anterior 
    dec ce_x
    mDecVar ce_y,8
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y

    ;fila anterior
    dec ce_x
    mDecVar ce_y,8
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01t,2t
    mDrawPixel ce_x,ce_y,01  ; aqui ççççççççççççççççççççççç
    inc ce_y
     mDrawPixel ce_x,ce_y,39t
     inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y


    ;fila anterior
    dec ce_x
    mDecVar ce_y,6
    mDrawFila ce_x,ce_y,01,7t  ; imprime uno de mas
    ;fila anterior


    dec ce_x
    mDecVar ce_y,9
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01,2t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01  ; aqui 2
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    dec ce_y

    ;fila anterior 



    dec ce_x
    ;mDecVar ce_y,4t
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
   ; mDrawPixel ce_x,ce_y,39t
    dec ce_y
    inc ce_y
    inc ce_y
     inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawFila ce_x,ce_y,01,3t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y
    dec ce_y


    ;antenas
    dec ce_x
    mDecVar ce_y,7
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 
    inc ce_y

    mDrawPixel ce_x,ce_y,39t
    ;mIncVar ce_y,5t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t 
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 
    


    mov ce_x,ax
    mov ce_y,dx
    pop dx
    pop ax
    ret 
pDrawEnemigo3 endp 


pDrawEnemigo4 proc
    push ax
    push dx
    ;mov ce_x,50t  
    ;mov ce_y,140t   
    mov ax, ce_x
    mov dx, ce_y

    mDecVar ce_y,4
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    ;mIncVar ce_y,7
    mDrawPixel ce_x,ce_y,01


    ;fila anterior 
    dec ce_x
    mDecVar ce_y,8
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y

    ;fila anterior
    dec ce_x
    mDecVar ce_y,8
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01t,2t
    mDrawPixel ce_x,ce_y,01  ; aqui ççççççççççççççççççççççç
    inc ce_y
     mDrawPixel ce_x,ce_y,39t
     inc ce_y
     ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y


    ;fila anterior
    dec ce_x
    mDecVar ce_y,6
    mDrawFila ce_x,ce_y,01,7t  ; imprime uno de mas
    ;fila anterior


    dec ce_x
    mDecVar ce_y,9
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y

    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawFila ce_x,ce_y,01,2t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,01  ; aqui 2
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    dec ce_y

    ;fila anterior 



    dec ce_x
    ;mDecVar ce_y,4t
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    dec ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
   ; mDrawPixel ce_x,ce_y,39t
    dec ce_y
    inc ce_y
    inc ce_y
     inc ce_y

    mDrawFila ce_x,ce_y,39t,2t
    mDrawFila ce_x,ce_y,01,3t
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t
    dec ce_y
    dec ce_y
    dec ce_y


    ;antenas
    dec ce_x
    mDecVar ce_y,7
    ;mDrawPixel ce_x,ce_y,39t
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 
    inc ce_y

    mDrawPixel ce_x,ce_y,39t
    ;mIncVar ce_y,5t
    inc ce_y
    mDrawPixel ce_x,ce_y,39t
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    mDrawPixel ce_x,ce_y,01 
    inc ce_y
    
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    mDrawPixel ce_x,ce_y,39t

    inc ce_y
    mDrawPixel ce_x,ce_y,39t 
    inc ce_y
    ;mDrawPixel ce_x,ce_y,39t 
    


    mov ce_x,ax
    mov ce_y,dx
    pop dx
    pop ax
    ret 
pDrawEnemigo4 endp 

pDrawNave proc
    push cx 
    push ax
    push dx 
    mov ax,cNave_x
    mov dx, cNave_y
    ;CAÑON PRINCIPAL 
    ; bloque 1 ...................................................
    dec cNave_y
    dec cNave_y
    dec cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    dec cNave_y
    dec cNave_y
    dec cNave_y

    ;bloque 2-----------------------------
    inc cNave_x 
    dec cNave_y
    dec cNave_y
    dec cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y


    
    ;CUERPO
    ; bloque  3.............
    inc cNave_x
    ;llantas 1, superior izquierdo
    dec cNave_y
    dec cNave_y
    dec cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    

    mDrawFila cNave_x,cNave_y,15t,7t

    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    dec cNave_y
    

    ; bloque 4---------------------------------------
    inc cNave_x
    ;llantas 1, superior izquierdo
    dec cNave_y
    dec cNave_y
    dec cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    ; termina llantas 1, superior izquierdo
    mDrawFila cNave_x,cNave_y,15t,7t
    ; ;llantas 1, superior derecho
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    
     ; ;termina   llantas 1, superior derecho
    dec cNave_y
    dec cNave_y
    dec cNave_y


    
    ;; bloque 5.............................

    inc cNave_x
    mDecVar cNave_y,9t
    ;llantas   llantas 1, inferior izquierdo
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y

    mDrawFila cNave_x,cNave_y,15t,7t 
     ;llantas   llantas 1, inferior derecho
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    dec cNave_y
    dec cNave_y


    ; bloque 6..............................................

    inc cNave_x  ; aqui va la raya roja de la ventana.....................................................
    mDecVar cNave_y,7t  
    mDrawFila cNave_x,cNave_y,15t,2t
    mDrawFila cNave_x,cNave_y,15t,3t
    mDrawFila cNave_x,cNave_y,15t,2t


    ; bloque 7-----------------------------------------
    inc cNave_x 
    mDecVar cNave_y,7t
    mDrawFila cNave_x,cNave_y,15t,2t
    mDrawPixel cNave_x,cNave_y,15t ; ; lados rojos de ventanas
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t  ; lados rojos de ventanas
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t    ;; lados rojos de ventanas
    
    ; Primera ala de la nave derecha-----------------------------------------------------------------------------
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    ;mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    ;mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    ;mDrawFila cNave_x,cNave_y,39t,4t

    
    ;bloque 8----------------------------------------------------------------------------------------------------

    inc cNave_x
    mDecVar cNave_y,9t
    mDrawFila cNave_x,cNave_y,15t,7t

    ;;; bñloque 9------------------------------------------------------
    ;otra parte ; segunda linea abajo de la ventana roja.
    inc cNave_x
    mDecVar cNave_y,10t
   ; llantas 2    inferior izquierdo
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    
    mDrawFila cNave_x,cNave_y,15t,7t 

    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    ;termina llantas 2 inferior derecho


    ; bloque 10 -------------------------------------------------------------------
    inc cNave_x
    mDecVar cNave_y,13t
    ;llantas 2    inferior izquierdo
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    
    mDrawFila cNave_x,cNave_y,15t,2t 
    mDrawFila cNave_x,cNave_y,15t,3t 
    mDrawFila cNave_x,cNave_y,15t,2t 

    ;llantas 2    inferior derecho
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    inc cNave_y
    ;OTRA PARTE   ; Tercera linea abajo de la ventana roja.


    ; bloque 11..............................................................
    inc cNave_x
    mDecVar cNave_y,14t 
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y

    mDrawFila cNave_x,cNave_y,15t,7t 

    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y

    mov cNave_x,ax
    mov cNave_y,dx
    cmp nivelGame,1 
    je salir 




    ;caño izquierdo 
        mIncVar cNave_x,5t 
        mDecVar cNave_y,7t 
        mDrawPixel cNave_x,cNave_y,39t
        mov cx,3t 
        canonizq:
            inc cNave_x
            mDrawPixel cNave_x,cNave_y,15t
        loop canonizq
        mov cNave_x,ax
        mov cNave_y,dx
        cmp nivelGame,2 
        je salir
    ;cañon derecho 
        mIncVar cNave_x,5t 
        mIncVar cNave_y,7t 
        mDrawPixel cNave_x,cNave_y,39t
        mov cx,3t 
        canonder:
            inc cNave_x
            mDrawPixel cNave_x,cNave_y,15t
        loop canonder
        mov cNave_x,ax
        mov cNave_y,dx 

    salir:     
    pop dx
    pop ax 
    pop cx 
    ret 
pDrawNave endp 

pDrawBala1 proc
    push ax 
    push cx 
    mov ax, bala1x  
    mov cx,3
    ciclo:
        mDrawPixel bala1x,bala1y,25t ;blanco 
        inc bala1x
        loop ciclo 

    mov bala1x,ax 
    pop cx 
    pop ax 
    ret 
pDrawBala1 endp 

pDrawBala2 proc
    push ax 
    push cx 
    mov ax, bala2x  
    mov cx,3
    ciclo:
        mDrawPixel bala2x,bala2y,5t ;morado
        inc bala2x
        loop ciclo 
    mov bala2x,ax 
    pop cx 
    pop ax 
    ret 
pDrawBala2 endp 

pDrawBala3 proc
    push ax 
    push cx 
    mov ax, bala3x  
    mov cx,3
    ciclo:
        mDrawPixel bala3x,bala3y,39t ;rojo
        inc bala3x
        loop ciclo 
    mov bala3x,ax 
    pop cx 
    pop ax 
    ret 
pDrawBala3 endp 
;BORRA EL MOVIMIENTO DE LA NAVE 
pDrawNaveBorr proc
     
    push ax
    push cx 
    ;12 filas x 15 columnas
    MovVariablesDw borrx, cNave_x
    MovVariablesDw borry, cNave_y
    mDecVar borry,8t
    mov ax, borry
    mov cx,12t
    ciclo:
        mDrawFila borrx,borry,00,17t
        mov borry,ax 
        inc borrx 
        loop ciclo 
    pop cx 
    pop ax 
    ret
pDrawNaveBorr endp

;FILAS DE ELEMENTOS --------------------------------------------------------------------------
pDrawCorazones proc 
    push cx 
    mov corazonx,125t
    mov corazony,60t
    mov cx, liNave ;vida de la nave
    cmp cx, 0
    je salir  
    corazones: 
        call pDrawCorazon
        mSumarDw corazony,14t
        mov corazonx,125t
        loop corazones
    salir: 
    pop cx 
    ret 
pDrawCorazones endp 
;PARA LIMPIAR LOS CORAZONES 
pDrawCleansCorazones proc 
    push cx 
    mov corazonx,125t
    mov corazony,60t
    mov cx, 3t
    je salir  
    corazones: 
        call pDrawCleanCorazon
        mSumarDw corazony,14t
        mov corazonx,125t
        loop corazones
    salir: 
    pop cx 
    ret 
pDrawCleansCorazones endp 

pFilaEnemigo1 proc
    push ax  
    push dx 
    push cx 
    ;mov ce_x,15t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx,ce_y  
    mov ax,ce_x
    mov cx, 7
     drawFila: 
        call pDrawEnemigo1
        mSumarDw ce_y,28t 
        loop drawFila
    mov ce_y,dx;para escribir cada elemento en la misma columna
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo1 endp 

pFilaEnemigo2 proc
    push ax  
    push dx 
    push cx
    ;mov ce_x,30t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx,ce_y  
    mov ax,ce_x
    mov cx, 7
    drawFila: 
        call pDrawEnemigo2
        mSumarDw ce_y,28t 
        loop drawFila
    mov ce_y, dx
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo2 endp 

pFilaEnemigo3 proc
    push ax  
    push dx 
    push cx
    ;mov ce_x,45t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx, ce_y
    mov ax, ce_x
    mov cx, 7t ;cx es el contador de cuantas veces el loop se repetira 
    drawFila: 
        call pDrawEnemigo3
        mSumarDw ce_y,28t 
        loop drawFila
    mov ce_y, dx 
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo3 endp 

pFilaEnemigo4 proc
    push ax  
    push dx 
    push cx
    ;mov ce_x,45t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx, ce_y
    mov ax, ce_x
    mov cx, 7t ;cx es el contador de cuantas veces el loop se repetira 
    drawFila: 
        call pDrawEnemigo4
        mSumarDw ce_y,28t 
        loop drawFila
    mov ce_y, dx 
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo4 endp 


pDrawEnemigos proc 
    push cx 
    mov cx, nivelGame
    mov ce_x,15t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    drawE:
        ;ENEMIGOS TIPO 1 
        call pFilaEnemigo1 ; los azules los primeros
        mSumarDw ce_x,15t 

        ;ENEMIGOS TIPO 2 
        mov ce_y,140t
        call pFilaEnemigo2
        mSumarDw ce_x,15t 

        ;ENEMIGOS TIPO 3 
        mov ce_y,140t
        call pFilaEnemigo3
        mSumarDw ce_x,15t 
        mov ce_y,140t

       
    loop drawE

    mov ce_x,15t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    pop cx 
    ret 
pDrawEnemigos endp 

;MOV-------- ----------------------------------------------------------------------------- RepOrdName
pMovNave proc
    push ax 
        mov ah,01 ;existe pulsascion o no?
        int 16h
        jz salir ; no hay pulsacion, salir 
        mov ah, 00  ;Espera a que se presione una tecla y la lee
        int 16h
        
        cmp ah,"K"  ;FLECHA IZQUIERDA - se encuentra en el lado izuierdo de ax 
        je movIzquierda
        cmp ah,  "M" ;FLECHA DERECHA - se encuentra en el lado izquierdo de ax 
        je movDerecha
        ;la flecha de arriba es H y la de abajo es P tambien en ah 
        cmp al, " " ;espacio 
        je Tdisparos
        cmp al, 27t ;escape 
        je Pausa 
        cmp al, "v"
        je Disparo1
        cmp al, "V"
        je Disparo1
        cmp nivelGame,1t ;si el el nivel es 1 solo debera de cumplir con estas instrucciones  
        je salir 
        ;NIVEL 2 O MAS
        cmp al,"b"
        je Disparo2
        cmp al,"B"
        je Disparo2
        cmp nivelGame,2t  ;si el el nivel es 2 solo debera de cumplir con estas instrucciones 
        je salir 
        ;NIVEL 3 O MAS 
        cmp al, "n"
        je Disparo3
        cmp al, "N"
        je Disparo3 
        jmp salir 
    movIzquierda:
        cmp cNave_y,132t
        jb salir 
        dec cNave_y
        jmp salir 
    movDerecha:
        cmp cNave_y,310t
        ja salir 
        inc cNave_y  
        jmp salir   
    Pausa: 
        call pPauseGame ;PAUSA DONDE SOLO HABRA O
        jmp salir 
    Disparo1:
        ;tomar en cuanta que esta opcion solo se tomara cuando se presione el boton indicado   
        cmp estD1,1t ;si ya se presiono una vez y la bala se esta moviendo se ignora estas otras instrucciones
        je salir 
        ;si no se oprimio antes se reestablece el punto de partida de la bala y se comienza a mover 
        MovVariablesDw bala1x, cNave_x ;regresa la bala a su posicion inicial en el cañon de enmedio 
        mDecVar bala1x,3t ; le resta 3 para que la bala comience 3 espacios arriba de este cañon 
        movVariablesDw bala1y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mov estD1,1 ;se le autoriza al programa a pintar la bala
        ;cuando la bala llegue al fin del movimiento estD volver a 0 y le prohibira al programa pintar la bala
        ;EL METODO PARA PINTAR BALA SE LLAMA EN OTRO PROC (el corazon del movimiento del juego)
        jmp salir 
    Disparo2:
        cmp estD2,1 
        je salir 
        MovVariablesDw bala2x, cNave_x ;regresa la bala a su posicion inicial 
        mIncVar bala2x,2t ; se le suma 2  para que comience en una posicion adecuada arriba del cañon izquierdo 
        movVariablesDw bala2y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mDecVar bala2y,8t ;se le resta 8 para estar en la columna correcta del cañon izquierdo
        mov estD2,1 ;  se le autoriza al programa a pintar la bala
        jmp salir 
    Disparo3:
        cmp estD3,1 
        je salir 
        MovVariablesDw bala3x, cNave_x ;regresa la bala a su posicion inicial 
        mIncVar bala3x,2t ; se le suma 2  para que comience en una posicion adecuada arriba del caño derecho
        movVariablesDw bala3y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mIncVar bala3y,8t ;se le suma 8 para estar en la columna correcta del cañon derecho
        mov estD3,1 ;  se le autoriza al programa a pintar la bala
        jmp salir 
    Tdisparos:
        cmp estD1,1t 
        je nd1;no disparo 1  
        MovVariablesDw bala1x, cNave_x 
        mDecVar bala1x,3t 
        movVariablesDw bala1y, cNave_y 
        mov estD1,1 
        nd1:
        cmp nivelGame,1 ; si es nivel 1 es innecesario hacerle caso al resto de intrucciones de abajo
        je salir 
        ;BALA 2 
        cmp estD2,1 
        je nd2 
        MovVariablesDw bala2x, cNave_x ;regresa la bala a su posicion inicial 
        mIncVar bala2x,2t ; se le suma 2  para que comience en una posicion adecuada arriba del cañon izquierdo 
        movVariablesDw bala2y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mDecVar bala2y,8t ;se le resta 8 para estar en la columna correcta del cañon izquierdo
        mov estD2,1 ;  se le autoriza al programa a pintar la bala
        nd2: 
        cmp nivelGame,2 ; si es nivel 2 es innecesario hacerle caso al resto de intrucciones de abajo
        je salir
        ;BALA 3  
        cmp estD3,1 
        je salir 
        MovVariablesDw bala3x, cNave_x ;regresa la bala a su posicion inicial 
        mIncVar bala3x,2t ; se le suma 2  para que comience en una posicion adecuada arriba del caño derecho
        movVariablesDw bala3y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mIncVar bala3y,8t ;se le suma 8 para estar en la columna correcta del cañon derecho
        mov estD3,1 ;  se le autoriza al programa a pintar la bala
        jmp salir 
    salir: 
    pop ax 
    ret 
pMovNave endp  

pMovbala proc
    push ax
    push dx
    push cx 
    mov cx,3t
    movnormal:
    cmp bala1x,5t
    je  finmovimiento
        push cx 
        
        ;OBTENER EL VALOR DE UN PIXEL 
        dec bala1x
        mov cx,bala1y ;column
        dec cx 
        mov dx,bala1x ;fila
        dec dx 
        dec dx 
        mov ah, 0Dh
        int 10h 
        cmp al,1t; azul 
        je DestEnemigo
        cmp al,44t ;si es igual al enemigo tipo 2 desaparece la bala pues no es de mayor calibre
        je colision
        cmp al,2t ;si es igual al enemigo tipo 3 desaparece la bala pues no es de mayor calibre
        je colision
        ;DIBUJO DE LA BALA 
        call pDrawBala1
        mIncVar bala1x,3t
        mDrawPixel bala1x,bala1y,0t
        inc dx 
        inc dx 
        mov bala1x,dx 
        pop cx 
    loop movnormal
    jmp salir
    DestEnemigo:
        pop cx 
        mDrawNaveEdestruida bala1x,bala1y 
        mSumarDw scoreG, 100t 
        jmp finmovimiento
    colision:  ;enemigo no posible de eliminar 
        pop cx     
    finmovimiento:
        mLimpiarDisparo bala1x,bala1y ;borrar bala 
        mov estD1,0
    salir: 
    pop cx 
    pop dx 
    pop ax  
    ret
pMovbala endp  

pMovbala2 proc
    push ax
    push dx
    push cx 
    mov cx,3t
    movnormal:
        cmp bala2x,5t
        je  finmovimiento
        push cx 
        ;OBTENER EL VALOR DE UN PIXEL 
        dec bala2x
        mov cx,bala2y ;column
        dec cx 
        mov dx,bala2x ;fila
        dec dx 
        dec dx 
        mov ah, 0Dh
        int 10h 
        cmp al,1t; si es igual al enemigo tipo 1 lo destruye y la bala sigue el recorrido con el daño de esta restada en 1 
        je DestEnemigot1
        cmp al,2t ;si es igual al enemigo tipo 2 lo destruye y la bala desaparece
        je DestEnemigot2
        cmp al,44t ;si es igual al enemigo tipo 3 desaparece la bala pues no es de mayor calibre
        je colision
        call pDrawBala2
        mIncVar bala2x,3t
        mDrawPixel bala2x,bala2y,0t
        inc dx 
        inc dx 
        mov bala2x,dx 
        pop cx 
    loop movnormal
    jmp salir
    DestEnemigot1: 
        pop cx 
        mDrawNaveEdestruida bala2x,bala2y
        mSumarDw scoreG, 100t  
        cmp damageb2,1 ; si el daño de la bala es de 1 (desaparece la bala)
        je finmovimiento
            dec damageb2 ;si es de 2 se le resta 1 al daño de la bala y sigue su camino 
            mLimpiarDisparo bala2x,bala2y ;borrar bala 
            jmp salir ;no desaparece la bala 2 
    DestEnemigot2:
        pop cx 
        cmp damageb2,1 ; si el daño de la bala es de 1 (desaparece la bala) ya no tiene el daño necesario
        je finmovimiento
        mDrawNaveEdestruida bala2x,bala2y 
        mSumarDw scoreG, 200t  
        jmp finmovimiento
    colision: ;enemigo no posible de eliminar 
        pop cx     
    finmovimiento:
        mov damageb2,2t 
        mLimpiarDisparo  bala2x,bala2y ;borrarbala 
        mov estD2,0 ;estado disparo 2 
    salir:
    pop cx 
    pop dx 
    pop ax  
    ret 
pMovbala2 endp 

pMovbala3 proc 
    push ax
    push dx
    push cx 
    mov cx,3t
    movnormal:
        cmp bala3x,5t ;si llega al tope de la pantalla se detiene 
        je  finmovimiento
        push cx 
        ;OBTENER EL VALOR DE UN PIXEL 
        dec bala3x
        mov cx,bala3y ;column
        dec cx 
        mov dx,bala3x ;fila
        dec dx  ;dec dx no tiene que ver con el procedimiento para dibujar la bala
        dec dx  ;si embargo se decrementa dos veces para saber como es el pixel  a la bala dos posiciones arriba 
        mov ah, 0Dh
        int 10h 
        cmp al,1t; si es igual al enemigo tipo 1 lo destruye y la bala sigue el recorrido con el daño de esta restada en 1 
        je DestEnemigot1
        cmp al,2t ;si es igual al enemigo tipo 2 lo destruye y y la bala sigue el recorrido con el daño de esta restada en 2 
        je DestEnemigot2
        cmp al,44t ;si es igual al enemigo tipo 3 lo destruye y la bala desaparece 
        je DestEnemigot3
        call pDrawBala3 ;pinta la bala 
        mIncVar bala3x,3t ;para borrar el rastro de la bala se posiciona en el ultimo pixel pintado de esta
        mDrawPixel bala3x,bala3y,0t ;se pinta de negro 
        inc dx 
        inc dx 
        mov bala3x,dx 
        pop cx 
    loop movnormal
    jmp salir
    DestEnemigot1: 
        pop cx 
        mDrawNaveEdestruida bala3x,bala3y
        mSumarDw scoreG, 100t  
        cmp damageb3,1 ; si el daño de la bala es de 1 (desaparece la bala)
        je finmovimiento
            dec damageb3 ;si es de 2 o mas se le resta 1 al daño de la bala y sigue su camino 
            mLimpiarDisparo bala3x,bala3y ;borrar bala 
            jmp salir ;no desaparece la bala 
    DestEnemigot2: 
        pop cx 
        cmp damageb3,1 ; si el daño de la bala es menor a 1 ya no tiene el daño necesario para destruir al enemigo 2 
        je finmovimiento ;se borra la nave 
        mDrawNaveEdestruida bala3x,bala3y
        mSumarDw scoreG, 200t  
        cmp damageb3,2 ; si el daño de la bala es de 2 (desaparece la bala)
        je finmovimiento
            dec damageb3 
            dec damageb3 ;si es de 3 se le resta 2 al daño de la bala y sigue su camino 
            mLimpiarDisparo bala3x,bala3y ;borrar bala 
            jmp salir ;no desaparece la bala 2 
    DestEnemigot3:  
        pop cx 
        cmp damageb3,2 ; si el daño de la bala es menor o igual que 2 ya no tiene el daño necesario para destruir al enemigo 3 
        jle finmovimiento ;se borra la bala
        mDrawNaveEdestruida bala3x,bala3y ;si tiene los 3 justos si destruye la nave y suma al score 
        mSumarDw scoreG, 500t  
        jmp finmovimiento    
    finmovimiento:
        mov damageb3,3t 
        mLimpiarDisparo  bala3x,bala3y ;borrarbala 
        mov estD3,0 ;estado disparo 3 
    salir: 
    pop cx 
    pop dx 
    pop ax 
    ret 
pMovbala3 endp 
;MOVIMIENTO DE LOS ENEMIGOS 
pMovEnemys proc  
    push cx 
    cmp estEnem,3
    je filaene3
    cmp estEnem,2
    je filaene2
    cmp estEnem,1
    je filaene1
    jmp salir ;SE MUEVE EL ESTADO PARA PASAR AL NIVEL 2 

    filaene33: 
        mov cx,nivelGame    
        movi33: 
            call pDestEnemA ;el enemigo fue destruido con anterioridad?
            cmp DestEnemA, 1 ;si entonces saltar a fin de movimiento
            je finMov33 
            movVariablesDw borrXenemy, ce_x
            movVariablesDw borrYenemy, ce_y 
            mDrawEborrado borrXenemy,borrYenemy
            call pColision
            cmp colisionE,1; si colisiono con la nave principal
            je finMov33
            cmp ce_x,196t ;si llego al margen inferior de la pantalla 
            je finMov33
            inc ce_x
            call pDrawEnemigo4
        dec cx 
        jne movi3 
        jmp salir 
        finMov33: 
            call pDrawEborradoU
            movVariablesDw ce_x,filaIgame ;fila actual 
            mSumarDw ce_y,28t
            cmp ce_y,336t ;comparar con la ultima posicion que puede tener una nave enemgia 
            jb  salir ;si es menor al margen salir y seguir graficando de forma normal 
            mRestaDw ce_x,15t 
            movVariablesDw filaIgame, ce_x ; se actualiza la fila actual a usar 
            mov ce_y,308t 
            mov estEnem,2

    filaene3: 
        mov cx,nivelGame    
        movi3: 
            call pDestEnemA ;el enemigo fue destruido con anterioridad?
            cmp DestEnemA, 1 ;si entonces saltar a fin de movimiento
            je finMov3 
            movVariablesDw borrXenemy, ce_x
            movVariablesDw borrYenemy, ce_y 
            mDrawEborrado borrXenemy,borrYenemy
            call pColision
            cmp colisionE,1; si colisiono con la nave principal
            je finMov3
            cmp ce_x,196t ;si llego al margen inferior de la pantalla 
            je finMov3
            inc ce_x
            call pDrawEnemigo3
        dec cx 
        jne movi3 
        jmp salir 
        finMov3: 
            call pDrawEborradoU
            movVariablesDw ce_x,filaIgame ;fila actual 
            mSumarDw ce_y,28t
            cmp ce_y,336t ;comparar con la ultima posicion que puede tener una nave enemgia 
            jb  salir ;si es menor al margen salir y seguir graficando de forma normal 
            mRestaDw ce_x,15t 
            movVariablesDw filaIgame, ce_x ; se actualiza la fila actual a usar 
            mov ce_y,308t 
            mov estEnem,2
    filaene2:
        mov cx,nivelGame 
            
        movi2: 
            call pDestEnemA ;el enemigo fue destruido con anterioridad?
            cmp DestEnemA, 1 ;si entonces saltar a fin de movimiento
            je finMov2 
            movVariablesDw borrXenemy, ce_x ; con las filas actualizadas 
            movVariablesDw borrYenemy, ce_y ;con la columna actualizada 
            mDrawEborrado borrXenemy,borrYenemy
            call pColision
            cmp colisionE, 1 ; si la nave enemiga choco con la nave principal 
            je finMov2
            cmp ce_x,196t 
            je finMov2
            inc ce_x
            call pDrawEnemigo2
        dec cx 
        jne movi2  
        jmp salir 
        finMov2: 
            call pDrawEborradoU
            movVariablesDw ce_x,filaIgame ;se vuelve a reestablecer x en la fila actual 
            mRestaDw ce_y,28t ;se resta 28 a la columna actual 
            cmp ce_y,140t ; si es menor a 140t es que ya se movieron los 7 enemigos 
            jae salir ;si es mayor o igual al margen salir y seguir graficando de forma normal
            mRestaDw ce_x,15t ;si es menor entonces pasar a la siguiente fila de enemigos 
            movVariablesDw filaIgame,ce_x ; se actualiza la fila actual 
            mov ce_y,140t 
            mov estEnem,1
    filaene1: 
        mov cx,nivelGame 
           
        movi1: 
             call pDestEnemA ;el enemigo fue destruido con anterioridad?
            cmp DestEnemA, 1 ;si entonces saltar a fin de movimiento
            je finMov 
            movVariablesDw borrXenemy, ce_x ;toma la fila del enemigo
            movVariablesDw borrYenemy, ce_y ;toma la fila del enemigo
            mDrawEborrado borrXenemy,borrYenemy ;pinta un cuadro negro en dicha poisicon
            call pColision ;verifica si el enemigo no choco con la nave principal
            cmp colisionE,1 ; si la nave choco significa el fin del movimiento de dicha nave 
            je finMov
            cmp ce_x,196t ;llego al margen inferior de la pantalla 
            je finMov; si llego al final de la pantalla, es su fin de movimiento 
            inc ce_x ;se incrementa su fila de 1 en 1 
            call pDrawEnemigo1 ;se manda a dibujar el enemigo 1 
        dec cx 
        jne movi1  
        jmp salir 
        finMov: 
            call pDrawEborradoU
            movVariablesDw ce_x,filaIgame
            mSumarDw ce_y,28t
            cmp ce_y,336t ; si es mayor a 336t es que ya se movieron los 7 enemigos 
            jb salir ;si es menor al margen salir y seguir graficando de forma normal
            mRestaDw ce_x,15t 
            movVariablesDw filaIgame,ce_x
            cmp ce_x, 0 
            jne SeguirMoviendo
    FinalizarMovEnemigos:
        mov estEnem,3 ;incrementa en uno el nivel 
        ;inc nivelGame
        mov printEnemyE,0 ;para indicarle al programa que debe de volver a imprimir enemigos 
        jmp salir 
    SeguirMoviendo:
        movVariablesDw ce_x,filaIgame
        mov ce_y,140t 
        mov estEnem,3
    salir:
    pop cx    
    ret 
pMovEnemys endp 

pColision proc  
    push cx 
    push dx 
    push bx 
        mov colisionE,0
        mov bx,ce_y ;salvalguardar posicion y 
        mov dx,ce_x ;fila
        inc  dx 
        inc dx 
        mov cx,8 
        mDecVar ce_y,5t
        cuerpoenemigo: 
            push cx
            mov cx,ce_y ;column
            mov ah, 0Dh
            int 10h 
            cmp al,15t ;blanco 
            je choque 
            inc ce_y
            pop cx 
        loop cuerpoenemigo
        jmp nochoque
        choque:
            pop cx
            call pDrawNaveBorr;desaparece la nave en el momento del choque 
            mov colisionE,1  ;indicador de que hubo colision 
            cmp liNave,0 ;si la nave tiene vida 0 entonces ya no se hace nada, caso contrario restar 1 a la vida 
            je nochoque 
            dec liNave
            dec scoreG
            dec unidad
        nochoque: 
        mov ce_y,bx 
    pop bx 
    pop dx 
    pop cx 
    ret 
pColision endp 

pDestEnemA proc
    push cx 
    push dx
    push ax 
    mov DestEnemA,0
    mov cx,ce_y ;column
    mov dx,ce_x ;fila
    dec dx 
    dec dx 
    dec dx 
    mov ah, 0Dh
    int 10h 
    cmp al,0t; negro, entonces fue eliminado 
    jne nodestruido ; si no ha sido destruido no hacer nada 
        mov DestEnemA,1 ;si esta destruido indicarle al programa que ha sido destruido anteriormente 
    nodestruido: 
    pop ax 
    pop dx 
    pop cx 
    ret 
pDestEnemA endp 

pDrawEborradoU proc
    mSumarDw scoreG, 1t
    mSumarDw unidad, 1t

    push cx
    push ax
    push dx 
    mov ax, borrXenemy
    mov dx, borrYEnemy
    mov cx, 8t
    figuraB:
        mDecVar borrYenemy,4t 
        mDrawFila borrXenemy,borrYenemy,0t,8     
        mov borrYenemy, dx 
        dec borrXenemy
        loop figuraB
    mov borrXenemy,dx
    pop dx
    pop ax
    pop cx 
    
    cmp unidad,9
    je den1
    jmp salir
    den1:
        mSumarDw decena, 1t
        mov unidad,0 
        jmp salir

    salir:
        ret
pDrawEborradoU endp 

;CONFIGURACIONES 
pConfigIni proc 
    ;LETREROS PRINCIPALES
    mImprimirLetreros Usergame,1t,0t,53t
    mImprimirLetreros Leveltitle,14t,1t,9t
    mImprimirLetreros Scoregame,7t,1t,53t
    mImprimirLetreros Timegame,10t,1t,53t
    ;mImprimirLetreros Livesgame,13t,1t,9t
    ;mImprimirLetreros PressSpace,18t,1t,9t
    ;mImprimirLetreros toStartG,20t,1t,9t
    call pNameUser ;rellena la variable que almacenara el nickname del usuario
    mImprimirLetreros NameUserG,4t,0t,15t ;imprime el nickname 
    ;CUADROS DIVISORES PARA EL JUEGO
                   ;FILA,COLUMNA,ANCHO,ALTO,COLOR
    mDrawRectangulo 1t,1t,120t,200t,39t 
    ;mDrawRectangulo 132t,1t,120t,67t,39t
    mDrawRectangulo 1t,121t,200t,198t,39t ; este es el del juego
    ;RESTAURA VIDA DE NAVE 
    mov liNave, 3
    ;NIVELES 
        mov printEnemyE,0  ; para saber si ya se pinto las filas de los enemigos o no 
        mov nivelGame,1 ;nivel del juego 
    ;COORDENADAS INICIALES PARA LOS ENEMIGOS Y NAVE PRINCIPAL RET
    mov cNave_x,185t ;fila inicial de la nave 
    mov cNave_y,220t ;columna inicial de la nave
    mov estEnem,3  ;para que se empiece moviendo el enemigo tipo 3 
    mov mingameN,0 ;minutos desde que se inicio el juego 
    mov seggameN,0 ;segundos desde que se inicio el juego 
    mov cengameN,-1 ;centisegundos desde que se inicio el juego, COMIENZA CON -1 por que el metodo que imprime el tiempo
                    ; suma 1 al inicio 
    mov segGameReporte,0 ;segundos para el reporte 
    ;RESET VARIABLES
    mov scoreG,0
     mov unidad,0
      mov decena,0
    mov vidas,3
    mLimpiar scoreGString,5t,0
    mov exitGame, 0
    ret 
pConfigIni endp  

;Rellena la variable donde estara el nombre de usuario actual 
pNameUser proc 
    push cx 
    push si
    mLimpiar NameUserG,15t," " 
    mov cx,15t 
    mov si,0
    ciclo:
        cmp UsuarioI[si],"$"
        je salir 
        MovVariables NameUserG[si],UsuarioI[si]
        inc si 
    loop ciclo 
    salir: 
    pop si 
    pop cx 
    ret 
pNameUser endp 

;IMPRIME EL TIEMPO DEL JUEGO 
pTimeGame proc 
    inc cengameN
    cmp cengameN,100t ;cuando llegue a 100 el contador de centisegundos volvera a 0 y se le sumara 1 a los segundos caso contrario solo sumara uno y se saldra 
    jne salir 

    mov cengameN,0 ;centisegundos vuelve a 0
    inc seggameN ;se aumenta a uno los segundos 
    inc segGameReporte; se aumenta en uno los segundos para el reporte 
    cmp seggameN,60t;cuando llegue a 60 volvera a 0 los segundos y se le sumara uno a los minutos 
    jne salir 

    mov seggameN,0t
    inc mingameN
    salir: 
        mLimpiar cengameS,2,0
        mLimpiar seggameS,2,0
        mLimpiar mingameS,2,0
        Num2String cengameN,cengameS
        Num2String seggameN,seggameS
        Num2String mingameN,mingameS
        mImprimirLetreros mingameS,12t,4t,15t
        mImprimirLetreros dospuntosg,12t,6t,15t
        mImprimirLetreros seggameS,12t,7t,15t
        mImprimirLetreros dospuntosg,12t,9t,15t
        mImprimirLetreros cengameS,12t,10t,15t  
    ret 
pTimeGame endp 
;IMPRIME EL NIVEL DEL JUEGO 
pLevel proc
    movVariablesDw nivelGameS,nivelGame
    add nivelGameS,30h
    mImprimirLetreros nivelGameS,6t,10t,15t 
    ret 
pLevel endp 
;IMPRIME EL SCORE DEL JUEGO  Scoregame
pScore proc
    mLimpiar scoreGString,5,0
    Num2String scoreG,scoreGString
    mImprimirLetreros scoreGString,9t,4t,15t
    ret 
pScore endp 


pvida proc
    mLimpiar vidasString,5,0
    Num2String liNave,vidasString
    mImprimirLetreros vidasString,16t,4t,15t
    ret 
pvida endp 


;PAUSA DEL JUEGO 
pPauseGame proc 
    call pGuardarMatrizVideo ; guardar el estado de la matriz de video para posteriormente cargarla sin los letreros 
    mov exitGame, 0
    mImprimirLetreros letPause,5t,25t,15t
    mImprimirLetreros letRen,12t,20t,15t
    mImprimirLetreros letExit,15t,20t,15t
    ciclo:
        mov ah, 00  ;Espera a que se presione una tecla y la lee
        int 16h
        cmp al, 27t ;escape 
        je exitG 
        cmp al, " " ;espacio 
        je salir
        jmp ciclo  ;estara en un ciclo si no es o espacio o escape 
    exitG: 
        mov exitGame,1 
    salir: 
        call pCargarMatrizVideo ;cargar la matriz de video guardada luego de los letreros 
    ret 
pPauseGame endp 
;PAUSA PARA PRESENTAR EL NIVEL A JUGAR Y ESPERAR SE PRESIONE LA TECLA ESPACIO 
pEspInicial proc
    cmp nivelGame,1 
    je nivel1 
    cmp nivelGame,2 
    je nivel2 
    cmp nivelGame,3 
    je nivel3 
    jmp salir 
    nivel1: ;imprime "nivel 1" y espera un espacio
        mImprimirLetreros letN1,8t,24t,15t 
        mWaitKey " "
        mImprimirLetreros letclear,8t,24t,15t 
        jmp salir 
    nivel2: ;imprime "nivel 2" y espera un espacio
        mImprimirLetreros letN2,8t,24t,15t 
        mWaitKey " "
        mImprimirLetreros letclear,8t,24t,15t
        jmp salir
    nivel3: ;imprime "nivel 3" y espera un espacio
        mImprimirLetreros letN3,8t,24t,15t 
        mWaitKey " "
        mImprimirLetreros letclear,8t,24t,15t
        jmp salir
    salir: 
    ret 
pEspInicial endp 

;MACROS PARA GUARDAR Y CARGAR LA MATRIZ DE VIDEO 
;Macro para sobreescribir la matriz de video en un archivo "matriz.vi"
pGuardarMatrizVideo proc
    push cx 
    push ax 
    push si  
    mCrearFile matrizgraph
    mOpenFile2Write matrizgraph
    mov si,0
    mov cx, 64000t
    copiarmatriz:
        mov bl, es:[si]
        mov eleactualG,bl 
        mWriteToFile eleactualG
        inc si 
    loop copiarmatriz
    call pCloseFile
    pop si 
    pop bx 
    pop cx 
    ret 
pGuardarMatrizVideo endp 

;macro para cargar la matriz guardada con anterioridad 
pCargarMatrizVideo proc
    push cx 
    push ax 
    push si  
    mOpenFile2Write matrizgraph
    mov si,0
    mov cx, 64000t
    copiarmatriz2:
        mReadFile eleactualG
        mov bl,eleactualG
        mov  es:[si],bl
        inc si 
    loop copiarmatriz2
    call pCloseFile
    pop si 
    pop bx 
    pop cx 
    ret
pCargarMatrizVideo endp 


;===============================================ORDENAMIENTOS===================================================
;rellenar array de datos con los datos de puntaje del juego 

pMenuOrd  proc  
    push ax 
    cicloAsdec:
        call pLimpiarConsola
        mMostrarString msgBubbleTitle ;IMPRIMIR TITULO DEL APARTADO  
        call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
        mMostrarString MenuDirOrd
        mov ah,01;atrapa la tecla fn
        int 21
        cmp al,31h ;F1=;
        je ascending
        cmp al,32h ;F2="<"
        je descending
        cmp al,33h
        je salir 
        mMostrarString opi 
        call pEspEnter
        jmp cicloAsdec
    ascending:
        mov ascDec,0
        jmp cicloMetrica
    descending: 
        mov ascDec,1 
    cicloMetrica:
        call pLimpiarConsola
        mMostrarString msgMetricTittle ;IMPRIMIR TITULO DEL APARTADO  
        call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
        mMostrarString MenuMetricaOrd
        mov ah,01;atrapa la tecla fn
        int 21
        cmp al,31h ;F1=;
        je mePoints
        cmp al,32h ;F2="<"
        je meTiempo
        cmp al,33h
        je salir 
        mMostrarString opi 
        call pEspEnter
        jmp cicloMetrica
        mePoints:
            mov punOtiempo,0
            jmp cicloVelocidad
        meTiempo:
            mov punOtiempo,1 
    cicloVelocidad:
        call pLimpiarConsola
        mMostrarString msgSpeedTittle;IMPRIMIR TITULO DEL APARTADO  
        call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
        mMostrarString MenuSpeed
        mov ah,01;atrapa la tecla fn
        int 21
        mov ah,01  ;atrapa la tecla escogida  
        int 21
        cmp al,59t
        je v0
        cmp al,"<"
        je v1
        cmp al,"="
        je v2
        cmp al,">"
        je v3
        cmp al,"?"
        je v4
        cmp al,"@"
        je v5
        cmp al,"A"
        je v6
        cmp al,"B"
        je v7
        cmp al,"C"
        je salir
        mMostrarString opi 
        call pEspEnter
        jmp cicloVelocidad
    ;ENTRE MAS GRANDE SEA EL LA VELOCIDAD ESCOGIDA MAYOR SERA EL DELAY
    v0:
        mov velocity,0t 
        jmp ord 
    v1:
        mov velocity,1t 
        jmp ord
    v2:
        mov velocity,2t 
        jmp ord
    v3:
        mov velocity,3t 
        jmp ord
    v4:
        mov velocity,4t 
        jmp ord
    v5:
        mov velocity,5t 
        jmp ord
    v6:
        mov velocity,6t 
        jmp ord
    v7:
        mov velocity,7t 
        jmp ord
    ord: 
        call pOrdenamiento
    salir:
        pop ax 
    ret 
pMenuOrd endp 


pOrdenamiento proc
    call pMemVideoMode
    call pVideoMode 
    call pMoveOrdenamiento
    call pReporteOrden
    call pTextMode
    ret 
pOrdenamiento endp 

;REPORTE FINAL LUEGO DEL ORDENAMIENTO  msgPressEnd msgPressHome
pReporteOrden proc 
    push ax 
    push bx 
    push cx 
    push si 
    mov auxDw,0 ;para el rank 
    mCrearFile RepOrdName
    mWriteToFile sepRepOrden
    mWriteToFile mensajeI
    mWriteToFile sepRepOrden
   ; mWriteToFile msgType
        cmp tOrdenamiento,0 ;burbuja
        je burbuja
        jmp burbuja;CAMBIAR ESTO CUANDO SE AGREGUEN OTROS ORDENAMIENTOS 
        burbuja:
            mWriteToFile msgBubble 
            jmp finTord
        otro: 
        finTord: 
    mWriteToFile msgEspacios
    ;mWriteToFile msgSentido
        cmp ascDec,0
        jne desc ;si no es ascending saltara a descending 
        asc:
            mWriteToFile msgAscen
            jmp finAscDesc
        desc:
            mWriteToFile msgDescen
        finAscDesc: 
    mWriteToFile msgEnter 
    call pFechaTime
    mWriteToFile msgFecha
        mWriteToFile dia
        mWriteToFile slash
        mWriteToFile mes
        mWriteToFile slash
        mWriteToFile anio
    mWriteToFile msgEspacios
    mWriteToFile msgHora
        mWriteToFile hora
        mWriteToFile dospuntosg
        mWriteToFile min
        mWriteToFile dospuntosg
        mWriteToFile segun
    mWriteToFile msgEnter
    mWriteToFile sepRepOrden
    mWriteToFile sepRepOrden
        mWriteToFile msgTitleRep
    mWriteToFile sepRepOrden
    mWriteToFile espacioL
    call pCloseFile
    ;APARTADO PARA EL TOP 10 DE USUARIOS 
    mov bx,0 
    mov ax, 0
    mov cx,CDatos
    cicloTop10:
        mOpenFile2Write scoresb
            mMoverAFila [indexDato+bx]
            mLimpiar filaScore,25t,0
            mCapturarFilaDoc filaScore
        call pCloseFile
        mOpenFile2Write RepOrdName
            call pFinaldoc
            ;rank 
            mov auxDw,ax 
            inc auxDw
            mLimpiar auxString,4t,0
            Num2String auxDw,auxString
            mWriteToFile auxString
            mWriteToFile filaScore
            mWriteToFile enterg 
        call pCloseFile 
        add bx,2
        inc ax 
        cmp ax,10t 
        je finCiclo10
    dec cx 
    jne cicloTop10
    jmp salir 
    finCiclo10: 
    call pCloseFile
    salir: 
    pop si 
    pop cx 
    pop bx 
    pop ax 
    ret 
pReporteOrden endp 

;PRESIONAR TECLA HOME 
pOrdMando proc 
    push ax 
    ciclo: 
    mov ah, 00  ;Espera a que se presione una tecla y la lee
    int 16h
    cmp al,"G"
    je ordenamiento 
    cmp al,"7"
    je ordenamiento
    jmp ciclo
    ordenamiento:
        mov EstOrd,1
        call pResetVarOrd
    jmp salir 
    salir: 
    pop ax 
    ret 
pOrdMando endp
;ENCARGADO DEL MOVIMIENTO DE LOS ORDENAMIENTOS
pMoveOrdenamiento proc
    push ax 
    push dx 
    mov auxfpsT,0
    reset: 
        call pConfigInicOrd
        call pDrawBarras 
        call pOrdMando
    fps: ;ciclo que provoca un movimiento cada centisegundo 
        mov ah,2Ch
        int 21
        cmp dl, auxfpsT
        je fps
    mov auxfpsT, dl 
    call pTimeOrd
    cmp EstOrd,0t
    je sinAccion
        mDrawBarra 17t,0t,170t,8t,0t;borrar flechas de pasos anteriores 
        call pBubbleSort  
        cmp EstOrd,0t
        je exit
    sinAccion:
    jmp fps 
    exit: 
        ;mImprimirLetreros msgPressEnd,24t,7t,15t msgPressEnd
        ciclo: ;SALE HASTA QUE SE PRESIONE "FIN"
        mov ah, 00  ;Espera a que se presione una tecla y la lee
        int 16h
        cmp al,"O"
        je exit2 
        cmp al,"1"
        je exit2
        jmp ciclo
        exit2:
        pop dx 
        pop ax 
    ret 
pMoveOrdenamiento endp 
;RECOLECTOR DE DATOS DE BLOC DE NOTAS  scoresb
pRDatosOrdPuntos proc
    push si 
    call pLimpiarArraySort   
    mov auxDw,0
    mov CDatos,0
    mov NumactualDoc,0
    ;NAMEUSER -01- NIVEL -01- PUNTOS -01- TIEMPO ENTER ESPACIO 
    mOpenFile2Write scoresb 
    call pInidoc
    mov si, 0
    ciclo:
    mReadFile eleactual
    cmp eleactual," "
    je salir 
    mHallarSimbolo ";"
    mHallarSimbolo ";"
    cmp punOtiempo,1 ;SE ESCOGIO LA METRICA DEL TIEMPO? SI ES ASI MOVERSE UNA SEPARACION MAS
    jne notiempo;SI NO ES ASI NO MOVERSE MAS DE LA POSICION ACTUAL 
        mHallarSimbolo ";"
    notiempo: 
    mReadFile eleactual
    mLimpiar NumactualDocS,6t,"$"
    mCapturarStringDoc NumactualDocS ;captura el numero en esta variable
    String2Num NumactualDocS,NumactualDoc,"$"; convierte el numero string a numero decimal 
    MovVariablesDw datosOrd[si], NumactualDoc ;mmueve el numeor a esta posicion de arreglo 
    movVariablesDw indexDato[si],auxDw ; index 
    inc auxDw 
    mHallarSimbolo 0A 
    inc si 
    inc si 
    inc CDatos
    cmp CDatos,20t ;si son mas de 20 termina de recopilar 
    je salir 
    jmp ciclo 
    salir: 
    call pCloseFile
    pop si 
    ret 
pRDatosOrdPuntos endp 
;LIMPIAR LOS ARRAY DE INDEX DATO Y DATOS ORD 
pLimpiarArraySort proc 
    push cx
    push bx 
    mov cx,20t 
    mov bx,0
    ciclo:
        mov [indexDato+bx],0
        mov [datosOrd+bx],0
        add bx,2 
    loop ciclo  
    pop bx 
    pop cx 
    ret 
pLimpiarArraySort endp 
;GRAFICAR BARRAS 
pDrawBarras proc 
    push cx 
    push si 
    push ax 
    cmp CDatos,0
    je salir
    mov cx, CDatos ;se repetira el ciclo la n cantidad de datos tomados 
    mov si,0  ; se inicia si 
    mov brEspOy, 0; para el borrado 
    mov x_barra , 16t ;empezara en el pixel 16t y fila 3 de un string 
    mov y_barra , 50t ;empezara a graficar cada barra desde aqui
    mov altoBarra, 140t  ; 140t es el espacio de filas de pixeles libres  para graficar sin contar los rotulos 
    mDivisionDw altoBarra,CDatos  ;se divide entre la cantidad de datos 

    cicloBarras: 
        mDrawBarra x_barra,brEspOy,altoBarra,318t,0t ;BORRA LOS MOVIMIENTOS ANTERIORES DE CADA LINEA 
        push x_barra;se guarda x 
        ;SE DIVIDE LA POSICION ACTUAL ENTRE 8 PARA IMPRIMIR EL STRING DEL VALOR DE LA BARRA 
        mDivisionDw x_barra,8t 
        mov ax,x_barra
        mov filaLetreroOrd,al
        mLimpiar DatOrsb,6t,0
        Num2String datosOrd[si],DatOrsb 
        mImprimirLetreros DatOrsb,filaLetreroOrd,1t,15t 
        pop x_barra;se recupera el valor inicial de la barra 

        movVariablesDw anchoBarra, datosOrd[si] ;se obtiene el ancho de la barra tomando el valor actual del  array de datos 
        ;--------------------------------------PUNTAJE O TIEMPO--------------------------------
        cmp punOtiempo,0
        je puntaje
        jne tiempo 
        puntaje: 
        mDivisionDw anchoBarra,65t  ;se dividira por esto para que la barra se reduzca un 80 veces su valor en decimal y pueda caber en la pantalla
        jmp graficarBarra
        tiempo: 
        cmp anchoBarra,269t
        jbe NoSobrepasaAncho;<= 
        mov anchoBarra,267t 
        NoSobrepasaAncho: 
        ;-------------------------------------------------------------------------------------
        graficarBarra: 
        mDrawBarra x_barra,y_barra,altoBarra,anchoBarra,15t ;se grafica la barra 
        mIncVar x_barra, altoBarra ;se desplaza hacia abajo la barra n pixeles iguales al tamaño de cada barra
        inc x_barra ;se le suma uno para dejar un espacio vacio, EN ESTE MOMENTO YA SE ENCUENTRA EN LA FILA ACTUAL INDICADA SE DIVIDE POR 8  
        inc si 
        inc si 
    dec cx 
    jne cicloBarras 
    salir:
    pop ax 
    pop si 
    pop cx 
    ret 
pDrawBarras endp 
;METODO DE ORDENAMIENTO BUBBLE 
pBubbleSort proc
    push ax
    push dx 
    push cx
    push bx
    cmp CDatos,1 
    jbe StopOrden
    mCompararDw nRepeticiones,CDatos 
    je StopOrden
        mCompararDw nRepeticiones2,CDatos
        je StopCiclo
            mov bx,indexCiclo 
            mov ax, [datosOrd+bx]
            cmp ascDec,0
            je ascendenteG
            jmp descendenteG 
            ascendenteG: 
                cmp ax, [datosOrd+bx+2]
                jae noswap ;si el dato 1 es mas grande al dato 2, no se mueve y se queda de primero
                jmp swap 
            descendenteG: 
                cmp ax, [datosOrd+bx+2]
                jbe noswap ;si el dato 1 es mas grande al dato 2, no se mueve y se queda de primero
            swap:
            ;swap 
            mov dx,[datosOrd+bx+2]
            mov [datosOrd+bx+2],ax
            mov [datosOrd+bx],dx 
            mDelaytCenti velocity;VELOCIDAD DEL DELAY 
            call pInterCambioB
            ;MOVER INDEX 
            call pMoverIndex
            noswap:
            mDelaytCenti velocity;VELOCIDAD DEL DELAY 
            call pDrawBarraBubble
                mIncVar x_barra, altoBarra ;se desplaza hacia abajo la barra n pixeles iguales al tamaño de cada barra
                inc x_barra ;se le suma uno para dejar un espacio vacio, EN ESTE MOMENTO YA SE ENCUENTRA EN LA FILA ACTUAL INDICADA SE DIVIDE POR 8  
                inc indexCiclo
                inc indexCiclo
            call pDrawBarraBubble
        inc nRepeticiones2 
    jmp salir 
    StopCiclo:
        call pResetVarOrd
        inc nRepeticiones  
        jmp salir 
    StopOrden: 
        call pDrawBarras 
        mov EstOrd,0
    salir: 
    pop bx 
    pop cx 
    pop dx 
    pop ax 
    ret 
pBubbleSort endp 
;DIBUJAR UNA UNICA BARRA 
pDrawBarraBubble proc  
        push si 
        mov si,indexCiclo
        
        mDrawBarra x_barra,brEspOy,altoBarra,318t,0t ;BORRA LOS MOVIMIENTOS ANTERIORES DE CADA LINEA 
        push x_barra;se guarda x 
        ;SE DIVIDE LA POSICION ACTUAL ENTRE 8 PARA IMPRIMIR EL STRING DEL VALOR DE LA BARRA 
        mDivisionDw x_barra,8t 
        mov ax,x_barra
        mov filaLetreroOrd,al
        mLimpiar DatOrsb,6t,0
        Num2String datosOrd[si],DatOrsb 
        
        mImprimirLetreros DatOrsb,filaLetreroOrd,1t,15t 
        pop x_barra;se recupera el valor inicial de la barra 
        movVariablesDw anchoBarra, datosOrd[si] ;se obtiene el ancho de la barra tomando el valor actual del  array de datos 
        ;--------------------------------------PUNTAJE O TIEMPO--------------------------------
        cmp punOtiempo,0
        je puntaje
        jne tiempo 
        puntaje: 
        mDivisionDw anchoBarra,65t  ;se dividira por esto para que la barra se reduzca un 80 veces su valor en decimal y pueda caber en la pantalla
        jmp graficarBarra
        tiempo: 
        cmp anchoBarra,269t
        jbe NoSobrepasaAncho;<= 
        mov anchoBarra,267t 
        NoSobrepasaAncho: 
        ;-------------------------------------------------------------------------------------
        graficarBarra: 
        mImprimirLetreros flecha,filaLetreroOrd,0t,15t  ;FLECHA 
        mDrawBarra x_barra,y_barra,altoBarra,anchoBarra,15t ;se grafica la barra 
        pop si 
    ret 
pDrawBarraBubble endp  
;DIBUJAR BARRAS ROJAS 
pDrawBarraBubbleRed proc  
        push si 
        mov si,indexCiclo
        mDrawBarra x_barra,brEspOy,altoBarra,318t,0t ;BORRA LOS MOVIMIENTOS ANTERIORES DE CADA LINEA 
        push x_barra;se guarda x 
        ;SE DIVIDE LA POSICION ACTUAL ENTRE 8 PARA IMPRIMIR EL STRING DEL VALOR DE LA BARRA 
        mDivisionDw x_barra,8t 
        mov ax,x_barra
        mov filaLetreroOrd,al
        mLimpiar DatOrsb,6t,0
        Num2String datosOrd[si],DatOrsb 
        mImprimirLetreros DatOrsb,filaLetreroOrd,1t,15t 
        pop x_barra;se recupera el valor inicial de la barra 
        movVariablesDw anchoBarra, datosOrd[si] ;se obtiene el ancho de la barra tomando el valor actual del  array de datos 
        ;--------------------------------------PUNTAJE O TIEMPO--------------------------------
        cmp punOtiempo,0
        je puntaje
        jne tiempo 
        puntaje: 
        mDivisionDw anchoBarra,65t  ;se dividira por esto para que la barra se reduzca un 80 veces su valor en decimal y pueda caber en la pantalla
        jmp graficarBarra
        tiempo: 
        cmp anchoBarra,269t
        jbe NoSobrepasaAncho;<= 
        mov anchoBarra,267t 
        NoSobrepasaAncho:  
        ;-------------------------------------------------------------------------------------
        graficarBarra: 
        mDrawBarra x_barra,y_barra,altoBarra,anchoBarra,39t ;se grafica la barra  
        mImprimirLetreros flecha,filaLetreroOrd,0t,15t  ;FLECHA 
        pop si 
    ret 
pDrawBarraBubbleRed endp 
;EN EL CASO SE PRODUZCA UN CAMBIO DE POSICIONES 
pInterCambioB proc
    mDelaytCenti velocity
    call pDrawBarraBubbleRed
        mIncVar x_barra, altoBarra ;se desplaza hacia abajo la barra n pixeles iguales al tamaño de cada barra
        inc x_barra ;se le suma uno para dejar un espacio vacio, EN ESTE MOMENTO YA SE ENCUENTRA EN LA FILA ACTUAL INDICADA SE DIVIDE POR 8  
        inc indexCiclo
        inc indexCiclo
    call pDrawBarraBubbleRed
        mDecVar x_barra, altoBarra ;se desplaza hacia abajo la barra n pixeles iguales al tamaño de cada barra
        dec x_barra ;se le suma uno para dejar un espacio vacio, EN ESTE MOMENTO YA SE ENCUENTRA EN LA FILA ACTUAL INDICADA SE DIVIDE POR 8  
        dec indexCiclo
        dec indexCiclo
    ret 
pInterCambioB endp 
;mueve los indices en orden para saber que lineas van primero en el doc de sores y el lastsort
pMoverIndex proc
    mov ax,[indexDato+bx]
    mov dx,[indexDato+bx+2]
    mov [indexDato+bx+2],ax 
    mov [indexDato+bx],dx 
    ret 
pMoverIndex endp 
;pinta las flechas 
pDrawFlechasBurble proc
    mImprimirLetreros flecha,x_f1,0t,15t 
    mIncFilaBar x_f1
    mImprimirLetreros flecha,x_f1,0t,15t
    ret 
pDrawFlechasBurble endp 


;CONFIGURACIONES 
pConfigInicOrd proc
    ;PARTE DE ARRIBA 
        call pTitlesIniO ;TITULOS DE LA PRIMERA FILA A MOSTRAR 
        mov CDatos,0  ;resetea la cantidad de datos 
        call pRDatosOrdPuntos ;OBTIENE TODOS LOS PUNTOS DEL ARCHIVO SCORE 
        mDrawBarra 10t,1t,2t,319t,3t 
        ;call pDrawBarras
    ;RESETEO DE VARIABLES 
        mov nRepeticiones,0
        call pResetVarOrd
        mDivisionDw altoBarra,CDatos  ;se divide entre la cantidad de datos 
        ;tiempo:
        mov mingameN,0 ;minutos desde que se inicio el ordenamiento
        mov seggameN,0 ;segundos desde que se inicio el ordenamiento 
        mov segGameReporte,0
        mov cengameN,0 ;centisegundos desde que se inicio el ordenamiento 
        call pDrawTimeOrd
        
    ;PARTE DE ABAJO 
        cmp punOtiempo,0 ;SE ESCOGIO PUNTEO?
        jne nopunteo ; NO ENTONCES PINTAR EL MENSAJE DE TIEMPO
        mImprimirLetreros msgPointOrd,22t,17t,9t ;SI ESCRIBIR EL MENSAJE DE PUNTEO 
        jmp fMtitle ;SALIR DE IMPRIMIR NOMBRES DE METRICA ESCOGIDA 
        nopunteo:
        mImprimirLetreros msgTimeOrd,22t,17t,9t ;SE IMPRIME EL MENSAJE DE TIEMPO
        fMtitle: 
                   ;fila,columna,ancho,largo,color   (ancho:arriba-abajo,largo: izq-der)
        mDrawBarra 188t,1t,3t,319t,3t 
        ;mImprimirLetreros msgPressHome,24t,7t,15t toStartG
    ret 
pConfigInicOrd endp 

;AUX PARA RESETEAR VARIABLES 
pResetVarOrd proc 
    mov filaLetreroOrd,2t
    mov nRepeticiones2,1 ; para que termine una posiicon antes del ultimo dato 
    mov brEspOy, 0; para el borrado 
    mov x_barra , 16t ;empezara en el pixel 16t y fila 3 de un string 
    mov y_barra , 50t ;empezara a graficar cada barra desde aqui
    mov indexCiclo,0
    ret 
pResetVarOrd endp 


;TITULOS DE INICIO DE LA VENTANA DE ORDENAMIENTO 
pTitlesIniO proc
    ;ORDENAMIENTO 
    cmp tOrdenamiento,0 ;burbuja
    je burbuja
    jmp burbuja;CAMBIAR ESTO CUANDO SE AGREGUEN OTROS ORDENAMIENTOS 
    burbuja:
        mImprimirLetreros msgBubble,0t,0t,15t 
        jmp finTord
    otro: 
    finTord: 
    cmp ascDec,0
    jne desc ;si no es ascending saltara a descending 
    asc:
        mImprimirLetreros arriba,0t,10t,15t 
        jmp finAscDesc
    desc:
        mImprimirLetreros abajo,0t,10t,15t 
    finAscDesc: 
        mImprimirLetreros msgSpped,0t,15t,15t 
        MovVariables velString,velocity
        mSumardb velString,30h
        mImprimirLetreros velString,0t,22t,15t 
    ret 
pTitlesIniO endp 


;aumenta el tiempo con cada centisegundo 
pTimeOrd proc 
    inc cengameN
    cmp cengameN,100t ;cuando llegue a 100 el contador de centisegundos volvera a 0 y se le sumara 1 a los segundos caso contrario solo sumara uno y se saldra 
    jne salir 

    mov cengameN,0 ;centisegundos vuelve a 0
    inc seggameN ;se aumenta a uno los segundos 
    inc segGameReporte; se aumenta en uno los segundos para el reporte 
    cmp seggameN,60t;cuando llegue a 60 volvera a 0 los segundos y se le sumara uno a los minutos 
    jne salir 

    mov seggameN,0t
    inc mingameN
    salir: 
        call pDrawTimeOrd 
    ret 
pTimeOrd endp 
;imprimir el tiempo
pDrawTimeOrd proc 
    mLimpiar cengameS,2,0
    mLimpiar seggameS,2,0
    mLimpiar mingameS,2,0
    Num2String cengameN,cengameS
    Num2String seggameN,seggameS
    Num2String mingameN,mingameS
    mImprimirLetreros mingameS,0t,32t,15t
    mImprimirLetreros dospuntosg,0t,34t,15t
    mImprimirLetreros seggameS,0t,35t,15t
    mImprimirLetreros dospuntosg,0t,37t,15t
    mImprimirLetreros cengameS,0t,38t,15t 
    ret 
pDrawTimeOrd endp 

;top10
pShowtop10 proc
    call pReporteOrden
    push ax 
    push bx 
    push cx 
    call pLimpiarConsola
    mMostrarString msgTop10 ;IMPRIMIR TITULO DEL APARTADO  
    call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
    mov punOtiempo,0
    ;capturar Datos 
    call pRDatosOrdPuntos
    ;burble, ORDENAR LOS DATOS 
    call pBubbleSortAuto
    ;print 
    mMostrarString msgTitleRep
    mMostrarString sepRepOrden
    mov auxDw,0
    mov bx,0 
    mov ax, 0
    mov cx,CDatos
    mOpenFile2Write scoresb
    cicloTop10:
            mMoverAFila [indexDato+bx]
            mLimpiar filaScore,25t,0
            mCapturarFilaDoc filaScore
            ;rank 
            mov auxDw,ax 
            inc auxDw
            mLimpiar auxString,4t,0
            Num2String auxDw,auxString
            mMostrarString auxString
            mMostrarString filaScore
            mMostrarString msgEnter
        add bx,2
        inc ax 
        cmp ax,10t 
        je finCiclo10
    dec cx 
    jne cicloTop10
    finCiclo10: 
    call pCloseFile
    call pEspEnter
    call pLimpiarConsola
    pop cx
    pop bx 
    pop ax 
    ret 
pShowtop10 endp 

pShowMytop10 proc
    push ax 
    push bx 
    push cx 
    push dx 
    call pLimpiarConsola
    mMostrarString msgMyTop10 ;IMPRIMIR TITULO DEL APARTADO  
    call pImprimirUser ;IMPRIMIR USUARIO ACTUAL 
    mov punOtiempo,0
    ;capturar Datos 
    call pRDatosOrdPuntos
    ;burble, ORDENAR LOS DATOS 
    call pBubbleSortAuto
    ;print 
    mMostrarString msgTitleRep
    mMostrarString sepRepOrden
    mov auxDw,0
    mov bx,0 
    mov ax, 0
    mov cx,CDatos
    mOpenFile2Write scoresb
    cicloTop10:
            mMoverAFila [indexDato+bx]
            mLimpiar filaScore,25t,0
            mCapturarFilaDoc filaScore
            call pFilaUScore  ;procedimiento que compara la variable UserNameG con el principio de la fila
            cmp cadIguales,1 ;si son iguales se procede a imprimir la fila 
            jne nofilaUser ; si no son iguales no se imprime nada 
            ;EL USER EN LA FILA ES IGUAL, SE PROCEDE A IMPRIMIR LA FILA 
                mov auxDw,ax 
                inc auxDw
                mLimpiar auxString,4t,0
                Num2String auxDw,auxString
                mMostrarString auxString
                mMostrarString filaScore
                mMostrarString msgEnter
                inc dx 
                cmp dx,10t  ;si ya se imprimio 10 veces un dato, se deja de imprimir mas escores 
                je finCiclo10
        nofilaUser: 
        add bx,2
        inc ax 
    dec cx 
    jne cicloTop10
    finCiclo10: 
    call pCloseFile
    call pEspEnter
    call pLimpiarConsola
    pop dx 
    pop cx
    pop bx 
    pop ax 
    ret 
pShowMytop10 endp  

pFilaUScore proc
    ;CAMBIAR USERPRUEBA POR NAMEUSERG
    push cx 
    push ax 
    push bx 
    mov cadIguales,0 
    mov bx,0
    mov cx,15t 
    ciclo:
        mov ah, [UsuarioI+bx]
        cmp ah,24 ;LLEGO AL FIN DE LA CADENA 1? 
        je fincad1 ;SI 
        cmp ah, [filaScore+bx]
        jne noigual 
        inc bx
    loop ciclo 
    jmp igual ;SI SE MOVIO LAS 15 VECES ENTONCES AMBAS CADENAS SON IGUALES 
    fincad1:
        cmp [filaScore+bx]," " ;LLEGO AL FIN DE LA CADENA 2? 
        jne noigual; NO NO ES IGUAL
    fincad2: ;SI ES IGUAL 
        jmp igual ;MARCA AL PROGRAMA QUE SI ES IGUAL 
    noigual:
        mov cadIguales,0 
        jmp salir 
    igual: 
        mov cadIguales,1 
    salir: 
    pop bx 
    pop ax 
    pop cx 
    ret 
pFilaUScore endp 
;ORDENAMIENTO BURBUJA AUTOMATICO SIN PAUSAS
pBubbleSortAuto proc
    push ax
    push dx 
    push cx
    push bx 
    cmp CDatos,1t 
    je salir 
    mov cx,CDatos
    nRepeat: 
        push cx 
        mov cx, CDatos
        dec cx 
        mov bx,0
        compEvery: ;comparar dato con cada dato del arreglo  
            mov ax, [datosOrd+bx] 
            cmp ax, [datosOrd+bx+2]
            jae noswap ;si el dato 1 es mas grande al dato 2, no se mueve y se queda de primerz
            ;swap 
            mov dx,[datosOrd+bx+2]
            mov [datosOrd+bx+2],ax
            mov [datosOrd+bx],dx 
            ;MOVER INDEX 
            call pMoverIndex
            noswap:
            add bx,2
        dec cx 
        jne compEvery
        pop cx 
    loop nRepeat 
    salir: 
    pop bx 
    pop cx 
    pop dx 
    pop ax 
    ret 
pBubbleSortAuto endp 



;PROC para rellenar las variables de tiempo
pFechaTime proc 
    push bx 
    push cx 
    xor bx,bx
    ;dia,mes,anio,hora,min,segun
    mov ah,2Ah   
    int 21h 
    mov year,cx  ;valor numerico de año
    mov bl, dh   ;valor numerico de mes
    mov month,bx  
    mov bl, dl   ;valor numerico de dia
    mov day,bx   

    mov ah,2Ch
    int 21h
    mov bl, ch  ;valor numerico de horas
    mov hours,bx 
    mov bl, cl   ;valor numerico de minutos
    mov minutes,bx 
    mov bl, dh   ;valor numerico de segundos
    mov seconds,bx 
    
    ;CONVERSION DE NUMEROS A VARIABLES
    Num2String year, anio
    Num2String month, mes
    Num2String day, dia
    Num2String hours, hora
    Num2String minutes,min
    Num2String seconds,segun 
    pop cx 
    pop bx 
    ret 
pFechaTime endp 
;LOOP 2
;mov cx,nvecesRepetir     
;ciclo: 
    ;INSTRUCCIONES
;dec cx 
;jne ciclo 

END start 

