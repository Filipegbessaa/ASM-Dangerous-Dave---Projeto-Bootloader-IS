org 0x7e00
jmp 0x0000:start 

data:
    press_enter db 'Press ENTER to start',0
    dangerous_dave db 'Dangerous Dave',0
    ground db '----------------------------------------',0
    scenario_tile1 db '--------------',0
    scenario_tile2 db '----',0
    

    ;dados do projeto

putchar:                        ;Printa um caractere na tela, pega o valor salvo em al
    mov ah, 0x0e
    int 10h
    ret
    
getchar:                        ;Pega o caractere lido no teclado e salva em al
    mov ah, 0x00
    int 16h
    ret

go_to_xy:
    mov bh, 0                   ; escolhe a página
    mov ah, 0x2                 ; escolhe a função de setar posição do cursor
    int 0x10                    ; 
    ret

clear:
    mov dx, 0                   ; move o cursor pro canto superior esquerdo
    call go_to_xy

    mov cx, 2000 
    mov bh, 0
    mov al, 0x20                ; printa 2000 caracteres vazios para limpar a tela
    mov ah, 0x9
    int 0x10

    mov dh, 0x0C                ; reset cursor to the center of the screen
    mov dl, 0x0B
    call go_to_xy

    ret

endl:                           ;Pula uma linha, printando na tela o caractere que representa o /n
    mov al, 0x0a                ; line feed
    call putchar
    mov al, 0x0d                ; carriage return
    call putchar
    ret
prints:                         ; mov si, string
    .loop:
        lodsb                   ; bota character apontado por si em al 
        cmp al, 0               ; 0 é o valor atribuido ao final de uma string
        je .endloop             ; Se for o final da string, acaba o loop
        call putchar            ; printa o caractere
        jmp .loop               ; volta para o inicio do loop
    .endloop:
        ret

start_screen:
        
    mov dx, 0               ; 
    call go_to_xy           ;
                            ;
    mov cx, 2000            ;
    mov bh, 0               ; limpa a tela
    mov al, 0x20            ;
    mov ah, 0x9             ;
    int 0x10                ;

    mov dh, 2    
    mov dl, 14
    call go_to_xy

    mov si, dangerous_dave
    call prints

    ; reset cursor to the center of the screen
    mov dh, 12
    mov dl, 11
    call go_to_xy


    mov si, press_enter    ;si aponta para o começo do endereço onde está mensagem
    call prints         ;Como só é impresso um caractere por vez, pegamos uma string com N caracteres e printamos um por um em ordem até chegar ao caractere de valor 0 que é o fim da string, assim prints pega a string para qual o ponteiro si aponta e a imprime na tela até o seu final

    ret

start_game:
    .loop2:
        call getchar    ;Recebe caractere do usuário
        cmp al, 0x0D    ;Compara o caractere digitado com ENTER (carriege return)
        je .endloop2    ;Se o caractere for ENTER, a tela é limpa
        jmp .loop2
    .endloop2:
        call clear
        ret
    

draw_ground:
    mov dh, 25
    mov dl, 0
    call go_to_xy


    mov bl, 0x04
    mov si, ground
    call prints

    mov dl, 0
    mov dh, 0
    call go_to_xy


    ret

draw_left_wall:
    mov dh, 0
    mov dl, 0
    .loop
        call go_to_xy


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
            call go_to_xy


            mov bl, 07      ;Draw the top of the pipe
            mov al, 0x2D
            call putchar
            inc dl
            call putchar
            inc dl 
            call putchar

            inc dh          
            call go_to_xy   ; Draw the pipe outlet
            mov al, 0x4F
            call putchar

            mov dh, 22
            mov dl, 1
            call go_to_xy
            mov al, 0x2D
            call putchar    ; Draw the bottom of the pipe
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
        call go_to_xy
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
        call go_to_xy
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
    mov dl, 23      ; Move o cursor para a linha 22 e coluna 22
    call go_to_xy


    mov al, 0x5F                ; seta al para o caractere '_' 
    call putchar                ; desenha parte de cima da porta

    inc dh
    dec dl                      ; Move o cursor para a linha 21 e coluna 22
    call go_to_xy
    mov al, 0x7C                ; seta al para o caractere '|' 
    call putchar

    inc dh
    call go_to_xy
    call putchar

    dec dh                      ;
    inc dl                      ; Move o cursor para a linha 23 e coluna 22
    inc dl                      ; 
    call go_to_xy

    mov al, 0x7C                ; seta al para o caractere '|' 
    call putchar

    inc dh
    call go_to_xy
    call putchar
    


draw_dave:

    mov dl, 5
    mov dh, 22
    call go_to_xy

    mov al, 0x36
    mov bl, 0x04
    call putchar
    ret


draw_platforms:

    mov dh, 05                  ;
    mov dl, 22                  ; Move cursor para a linha 5 e coluna 22
    call go_to_xy


    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1

    mov dh, 05                  ;
    mov dl, 08                  ; Move cursor para a linha 5 e coluna 8
    call go_to_xy

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
    mov dl, 17                  ; Move cursor para a linha 10 e coluna 17
    call go_to_xy


    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1
    

    mov dh, 15                  ;
    mov dl, 15                  ; Move cursor para a linha 15 e coluna 15
    call go_to_xy

    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1
    
    mov dh, 15                  ;
    mov dl, 05                  ; Move cursor para a linha 15 e coluna 5
    call go_to_xy


    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1

    mov dh, 20                  ;
    mov dl, 10                  ; Move cursor para a linha 20 e coluna 8
    call go_to_xy

    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1


    mov dh, 19                  ;
    mov dl, 18                  ; Move cursor para a linha 20 e coluna 22
    call go_to_xy

    mov si, scenario_tile1      ;
    call prints                 ; printa ground_tile1


    mov si, scenario_tile2      ;
    call prints                 ; printa ground_tile1

    ret


draw_diamond:

    mov al, 0x5C                ;
    call putchar                ; desenha '\'

    dec dh                      ;
    call go_to_xy               ; sobe o cursor em 1 linha

    
    mov al, 0x5F                ;
    call putchar                ; desenha '_'

    mov al, 0x5F                ;
    call putchar                ; desenha '_'

    
    inc dh
    inc dl
    call go_to_xy               ; move o cursor para uma linha mais embaixo e uma coluna mais à direita

    mov al, 0x2F                ; desenha '/'
    call putchar

    ret

draw_diamonds:
    mov bl,3                    ; Muda a cor para ciano


    mov dh, 04                  ;
    mov dl, 09                  ; Move cursor para a linha 4 e coluna 9
    call go_to_xy
    call draw_diamond

    mov bl, 02                  ; Muda a cor do diamante de ciano para verde claro
    mov dh, 09                  ;
    mov dl, 01                  ; Move cursor para a linha 09 e coluna 01
    call go_to_xy
    call draw_diamond

    mov bl, 13                  ; Muda a cor do diamante para rosa
    mov dh, 09                  ;
    mov dl, 20                  ; Move cursor para a linha 09 e coluna 01
    call go_to_xy
    call draw_diamond

    mov bl, 3                   ; Muda cor para ciano
    mov dh, 14                  ;
    mov dl, 06                  ;Move cursor para a linha 14 e coluna 6
    call go_to_xy
    call draw_diamond

    mov dh, 18                  ;
    mov dl, 20                  ; Move cursor para a linha 18 e coluna 20
    call go_to_xy
    call draw_diamond

    mov bl, 13                  ; Muda a cor do diamante para rosa claro
    mov dh, 19                  ;
    mov dl, 11                  ; Move cursor para a linha 09 e coluna 01
    call go_to_xy
    call draw_diamond

    ret

draw_scenario:
    call draw_ground
    call draw_left_wall
    call draw_right_wall
    call draw_platforms
    call draw_door_wall
    call draw_door
    call draw_diamonds
    ret



start:
    mov ax, 13h   ; iniciar modo gráfico
    int 10h
    xor ax, ax    ; limpando ax
    mov ds, ax    ; limpando ds
    mov es, ax    ; limpando es


    ;limpando a tela, em bl fica o valor da cor que vai ser utilizada na tela, 15 é o valor branco, outras cores disponíveis no tutorial    
    mov bl, 0x0E

    call start_screen
    call start_game
    call draw_scenario


    call draw_dave


jmp $