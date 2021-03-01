org 0x7e00
jmp 0x0000:start 

data:
    press_enter db 'Press ENTER to start',0
    dangerous_dave db 'Dangerous Dave',0
    ground db '----------------------------------------',0
    scenario_tile1 db '--------------',0
    scenario_tile2 db '----',0
    

    ;dados do projeto

putchar:    ;Printa um caractere na tela, pega o valor salvo em al
    mov ah, 0x0e
    int 10h
    ret
    
getchar:    ;Pega o caractere lido no teclado e salva em al
    mov ah, 0x00
    int 16h
    ret

clear:                   ; mov bl, color
    ; set the cursor to top left-most corner of screen
    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10    
    ; print 2000 blank chars to clean  
    mov cx, 2000 
    mov bh, 0
    mov al, 0x20 ; blank char
    mov ah, 0x9
    int 0x10

    ; reset cursor to the center of the screen
    mov dh, 0x0C
    mov dl, 0x0B
    mov bh, 0      
    mov ah, 0x2
    int 0x10
    ret

endl:       ;Pula uma linha, printando na tela o caractere que representa o /n
    mov al, 0x0a          ; line feed
    call putchar
    mov al, 0x0d          ; carriage return
    call putchar
    ret
prints:             ; mov si, string
    .loop:
        lodsb           ; bota character apontado por si em al 
        cmp al, 0       ; 0 é o valor atribuido ao final de uma string
        je .endloop     ; Se for o final da string, acaba o loop
        call putchar    ; printa o caractere
        jmp .loop       ; volta para o inicio do loop
    .endloop:
        ret

start_screen:
        ; set the cursor to top left-most corner of screen
    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10    
    ; print 2000 blank chars to clean  
    mov cx, 2000 
    mov bh, 0
    mov al, 0x20 ; blank char
    mov ah, 0x9
    int 0x10

    mov dh, 0x02    
    mov dl, 0x0E
    mov bh, 0      
    mov ah, 0x2
    int 0x10
    mov si, dangerous_dave
    call prints

    ; reset cursor to the center of the screen
    mov dh, 0x0C
    mov dl, 0x0B
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    mov si, press_enter    ;si aponta para o começo do endereço onde está mensagem
    call prints         ;Como só é impresso um caractere por vez, pegamos uma string com N caracteres e printamos um por um em ordem até chegar ao caractere de valor 0 que é o fim da string, assim prints pega a string para qual o ponteiro si aponta e a imprime na tela até o seu final

    ret

start_game:
    .loop2:
        call getchar    ;Recebe caractere do usuário
        cmp al, 0x0D    ;Compara o caractere digitado com ENTER (carriege return)
        je .endloop2     ;Se o caractere for ENTER, a tela é limpa
        jmp .loop2
    .endloop2:
        call clear
        ret
    

draw_ground:
    mov dh, 25
    mov dl, 0
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    mov bl, 0x04
    mov si, ground
    call prints

    mov dl, 0
    mov dh, 0
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    ret

draw_left_wall:
    mov dh, 0
    mov dl, 0
    .loop
        mov bh, 0      
        mov ah, 0x2
        int 0x10

        mov al, 0x7C
        mov bl, 0x04
        call putchar
        inc dh
        cmp dh, 24
        je .draw_pipe
        jmp .loop
    
        .draw_pipe:
            mov dh, 20
            mov dl, 1
            mov bh, 0      
            mov ah, 0x2
            int 0x10

            mov bl, 07      ;Draw the top of the pipe
            mov al, 0x2D
            call putchar
            inc dl
            call putchar
            inc dl 
            call putchar

            inc dh          
            mov bh, 0       ;Draw the pipe outlet
            mov ah, 0x2
            int 0x10
            mov al, 0x4F
            call putchar

            mov dh, 22
            mov dl, 1
            mov bh, 0      ;Draw the bottom of the pipe
            mov ah, 0x2
            int 0x10
            mov al, 0x2D
            call putchar
            inc dl 
            call putchar
            inc dl 
            call putchar
            jmp .endloop
        
    .endloop
    ret

draw_right_wall:
    mov dh, 0
    mov dl, 39
    
    .loop
        mov bh, 0      
        mov ah, 0x02
        int 0x10
        mov al, 0x7C
        mov bl, 0x04
        call putchar
        inc dh
        cmp dh, 24
        je .endloop
        jmp .loop
    
    .endloop
    ret
draw_door_wall:
    mov dh, 20
    mov dl, 18
    
    .loop
        mov bh, 0      
        mov ah, 0x02
        int 0x10
        mov al, 0x7C
        mov bl, 4
        call putchar
        inc dh
        cmp dh, 23
        je .endloop
        jmp .loop
    
    .endloop
    ret

draw_door:
    mov bl, 6       ; Muda a cor para marrom

    mov dh, 20      ;
    mov dl, 23      ;
    mov bh, 0       ; Move o cursor para a linha 22 e coluna 22
    mov ah, 0x2     ;
    int 0x10        ;

    mov al, 0x5F    ; seta al para o caractere '_' 
    call putchar    ; desenha parte de cima da porta

    inc dh
    dec dl
    mov bh, 0       ; Move o cursor para a linha 21 e coluna 22
    mov ah, 0x2     ;
    int 0x10        ;
    mov al, 0x7C    ; seta al para o caractere '|' 
    call putchar

    inc dh
    mov bh, 0       
    mov ah, 0x2     
    int 0x10 
    call putchar

    dec dh
    inc dl
    inc dl
    mov bh, 0       ; Move o cursor para a linha 23 e coluna 22
    mov ah, 0x2     ;
    int 0x10        ;
    mov al, 0x7C    ; seta al para o caractere '|' 
    call putchar

    inc dh
    mov bh, 0       
    mov ah, 0x2     
    int 0x10 
    call putchar
    


draw_dave:

    mov dl, 5
    mov dh, 22
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    mov al, 0x36
    mov bl, 0x04
    call putchar
    ret

draw_platforms:

    mov dh, 05                  ;
    mov dl, 22                  ;
    mov bh, 0                   ; Move cursor para a linha 5 e coluna 22
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1

    mov dh, 05                  ;
    mov dl, 08                  ;
    mov bh, 0                   ; Move cursor para a linha 5 e coluna 8
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1

    mov dh, 10                  ;
    mov dl, 01                  ;
    mov bh, 0                   ; Move cursor para a linha 10 e coluna 1
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1

    mov dh, 10                  ;
    mov dl, 17                    ;
    mov bh, 0                   ; Move cursor para a linha 10 e coluna 17
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1
    

    mov dh, 15                  ;
    mov dl, 15                  ;
    mov bh, 0                   ; Move cursor para a linha 15 e coluna 15
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1
    
    mov dh, 15                  ;
    mov dl, 05                  ;
    mov bh, 0                   ; Move cursor para a linha 15 e coluna 5
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1

    mov dh, 20                  ;
    mov dl, 10                  ;
    mov bh, 0                   ; Move cursor para a linha 20 e coluna 8
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1


    mov dh, 19                  ;
    mov dl, 18                  ;
    mov bh, 0                   ; Move cursor para a linha 20 e coluna 22
    mov ah, 0x2                 ;
    int 0x10                    ;

    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1


    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1

    ret


draw_diamond:

    mov al, 0x5C                ;
    call putchar                ; desenha '\'

    dec dh
    mov bh, 0                   ; sobe o cursor em 1 linha
    mov ah, 0x2                 ;
    int 0x10
    
    mov al, 0x5F                ;
    call putchar                ; desenha '_'

    mov al, 0x5F                ;
    call putchar                ; desenha '_'

    
    inc dh
    inc dl
    mov bh, 0                   ; sobe o cursor em 1 linha
    mov ah, 0x2                 ;
    int 0x10

    mov al, 0x2F
    call putchar

    ret

draw_diamonds:
    mov bl,3                    ; Muda a cor para ciano


    mov dh, 04                  ;
    mov dl, 09                  ;
    mov bh, 0                   ; Move cursor para a linha 4 e coluna 9
    mov ah, 0x2                 ;
    int 0x10                    ;
    call draw_diamond

    mov bl, 02                  ; Muda a cor do diamante de ciano para verde claro
    mov dh, 09                  ;
    mov dl, 01                  ;
    mov bh, 0                   ; Move cursor para a linha 09 e coluna 01
    mov ah, 0x2                 ;
    int 0x10                    ;
    call draw_diamond

    mov bl, 13                  ; Muda a cor do diamante para rosa
    mov dh, 09                  ;
    mov dl, 20                  ;
    mov bh, 0                   ; Move cursor para a linha 09 e coluna 01
    mov ah, 0x2                 ;
    int 0x10                    ;
    call draw_diamond

    mov bl, 3                   ; Muda cor para ciano
    mov dh, 14                  ;
    mov dl, 06                  ;
    mov bh, 0                   ; Move cursor para a linha 14 e coluna 6
    mov ah, 0x2                 ;
    int 0x10                    ;
    call draw_diamond

    mov dh, 18                  ;
    mov dl, 20                  ;
    mov bh, 0                   ; Move cursor para a linha 18 e coluna 20
    mov ah, 0x2                 ;
    int 0x10                    ;
    call draw_diamond

    mov bl, 13                  ; Muda a cor do diamante para rosa claro
    mov dh, 19                  ;
    mov dl, 11                  ;
    mov bh, 0                   ; Move cursor para a linha 09 e coluna 01
    mov ah, 0x2                 ;
    int 0x10                    ;
    call draw_diamond

    ret


start:
    mov ax, 13h  
    int 10h
    xor ax, ax    ;limpando ax
    mov ds, ax    ;limpando ds
    mov es, ax    ;limpando es


    ;limpando a tela, em bl fica o valor da cor que vai ser utilizada na tela, 15 é o valor branco, outras cores disponíveis no tutorial    
    mov bl, 0x0E
    call clear

    call start_screen
    call start_game


    call draw_ground
    call draw_left_wall
    call draw_right_wall
    call draw_platforms
    call draw_door_wall
    call draw_door
    call draw_diamonds
    call draw_dave


jmp $