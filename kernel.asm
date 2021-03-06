org 0x7e00
jmp 0x0000:start 

    
data:                           ;dados do projeto
    press_enter                 db 'Press ENTER to start',0
    dangerous_dave              db 'Dangerous Dave',0
    empty_string                db '                    ',0
    ground                      db '----------------------------------------',0
    scenario_tile1              db '--------------',0
    scenario_tile2              db '----',0
    score_string                db 'SCORE:',0
    jetpack_on_string           db 'JETPACK ON!',0
    get_the_jetpack_string      db 'GET THE JETPACK!',0
    congratulations             db 'CONGRATULATIONS!',0
    you_are_really_dangerous    db 'You are really dangerous!',0
    dave_pos_x                  db 05
    dave_pos_y                  db 22
    dave_next_pos_x             db 0
    dave_next_pos_y             db 0
    score                       db 48
    jetpack_boolean             db 0
    game_over_boolean           db 0
    


putchar:                        ;Printa um caractere na tela, pega o valor salvo em al
    mov ah, 0x0e
    int 10h
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
getchar:                        ;Pega o caractere lido no teclado e salva em al
    mov ah, 0x00
    int 16h
    ret

go_to_xy:
    mov bh, 0                   ; escolhe a página
    mov ah, 0x2                 ; escolhe a função de setar posição do cursor
    int 0x10                    ; 
    ret

read_char_in_cursor_pos:
    xor bh, bh
    mov ah, 0x08
    int 10h
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




start_screen:
    mov bl, 14              ; muda a cor das letras para amarelo

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

game_over_screen:
    mov bl, 4              ; muda a cor das letras para vermelho

    mov dh, 2    
    mov dl, 12
    call go_to_xy

    mov si, congratulations
    call prints

    ; reset cursor to the center of the screen
    mov dh, 12
    mov dl, 9
    call go_to_xy


    mov si, you_are_really_dangerous    ;si aponta para o começo do endereço onde está mensagem
    call prints         ;

    ret

start_game:
    .loop:
        call getchar    ;Recebe caractere do usuário
        cmp al, 0x0D    ;Compara o caractere digitado com ENTER (carriege return)
        je .endloop    ;Se o caractere for ENTER, a tela é limpa
        jmp .loop

    .endloop:
        mov dh, 2    
        mov dl, 14
        call go_to_xy

        mov si, empty_string
        call prints

        ; reset cursor to the center of the screen
        mov dh, 12
        mov dl, 11
        call go_to_xy


        mov si, empty_string    ;si aponta para o começo do endereço onde está mensagem
        call prints       

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
    mov dh, 2
    mov dl, 0
    .loop:
        call go_to_xy


        mov al, 0x7C         ; '|'
        mov bl, 0x04         ; cor vermelha
        call putchar
        inc dh
        cmp dh, 24
        je .draw_pipe
        jmp .loop
    
        .draw_pipe:
            mov dh, 20
            mov dl, 1
            call go_to_xy


            mov bl, 07      ; Desenha parte de cima do cano
            mov al, 0x2D
            call putchar
            inc dl
            call putchar
            inc dl 
            call putchar

            inc dh          
            call go_to_xy   ; Desenha saída do cano
            mov al, 0x4F
            call putchar

            mov dh, 22
            mov dl, 1
            call go_to_xy
            mov al, 0x2D
            call putchar    ; Desenha parte de baixo do cano
            inc dl 
            call putchar
            inc dl 
            call putchar
            jmp .endloop
        
    .endloop:
        ret

draw_right_wall:
    mov dh, 2
    mov dl, 39
    
    .loop:
        call go_to_xy
        mov al, 0x7C
        mov bl, 4
        call putchar
        inc dh
        cmp dh, 24
        je .endloop
        jmp .loop
    
    .endloop:
        ret

draw_roof:
    mov dh, 2
    mov dl, 1
    
    .loop:
        call go_to_xy
        mov al, 0x2D                    ; seta para caractere '-'
        mov bl, 4
        call putchar
        inc dl                          ; pula para a próxima posição
        call read_char_in_cursor_pos
        cmp ah, 4                       ; verifica se a cor é vermelha
        je .endloop
        jmp .loop
    
    .endloop:
        ret

draw_door_wall:
    mov dh, 20
    mov dl, 18
    
    .loop:
        call go_to_xy
        mov al, 0x7C
        mov bl, 4
        call putchar
        inc dh
        cmp dh, 23
        je .endloop
        jmp .loop
    
    .endloop:
        ret

draw_door:
    mov bl, 6                   ; Muda a cor para marrom

    mov dh, 20                  ;
    mov dl, 23                  ; Move o cursor para a linha 22 e coluna 22
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
draw_gem:

    mov al, 4                   ; 
    call putchar                ; desenha a gema

    ret

draw_gems:
    mov bl,14                    ; Muda a cor para amarelo


    mov dh, 04                  ;
    mov dl, 09                  ; Move cursor para a linha 4 e coluna 9
    call go_to_xy
    call draw_gem

    mov bl, 02                  ; Muda a cor para verde claro
    mov dh, 09                  ;
    mov dl, 01                  ; Move cursor para a linha 09 e coluna 01
    call go_to_xy
    call draw_gem

    mov bl, 13                  ; Muda a cor para rosa
    mov dh, 09                  ;
    mov dl, 20                  ; Move cursor para a linha 09 e coluna 01
    call go_to_xy
    call draw_gem

    mov bl, 14                   ; Muda cor para amarelo
    mov dh, 14                  ;
    mov dl, 06                  ;Move cursor para a linha 14 e coluna 6
    call go_to_xy
    call draw_gem

    mov dh, 18                  ;
    mov dl, 20                  ; Move cursor para a linha 18 e coluna 20
    call go_to_xy
    call draw_gem

    mov bl, 13                  ; Muda a cor para rosa claro
    mov dh, 19                  ;
    mov dl, 11                  ; Move cursor para a linha 09 e coluna 01
    call go_to_xy
    call draw_gem

    ret

collect_gem:
    cmp ah, 2                           
    je .emerald_collect_score_increase  ; aumenta score em 3 ao coletar esmeralda (gema verde)

    cmp ah, 14                          
    je .gold_collect_score_increase      ; aumenta score em 1 ao coletar ouro

    cmp ah, 13
    je .quartzo_collect_score_increase  ; aumenta score em 2 ao coletar quartzo (gema rosa)

    ret


    .gold_collect_score_increase:
        inc byte [score]
        call draw_score_value
        ret

    .quartzo_collect_score_increase:
        inc byte [score]
        inc byte [score]
        call draw_score_value
        ret

    .emerald_collect_score_increase:
        inc byte [score]
        inc byte [score]
        call draw_score_value
        ret

draw_scenario:
    call draw_ground
    call draw_left_wall
    call draw_right_wall
    call draw_roof
    call draw_platforms
    call draw_door_wall
    call draw_door

draw_items:
    call draw_gems
    call draw_jetpack
    ret

draw_dave:

    mov dh, [dave_pos_y]        ;
    mov dl, [dave_pos_x]        ; define a posição do Dave
    call go_to_xy               ;

    mov bl, 4                   ; escolhe a cor vermlha
    mov al, 0x36                ; escolhe o caractere '6'
    call putchar                ;

    ret

clean_dave_current_pos:
    mov dh, [dave_pos_y]    
    mov dl, [dave_pos_x]    ; limpa a posição atual do dave para usarmos na movimentação do dave
    mov al, 0x20    
    call go_to_xy   
    call putchar    

    ret


draw_jetpack_on_string:
    mov bl, 10                  ; muda a cor pra verde

    mov dh, 1                   ;
    mov dl, 23                  ; muda posição do x e do y
    call go_to_xy               ;

    mov si, jetpack_on_string
    call prints
    mov al, 0x20                ; caractere espaço
    call putchar
    mov al, 1
    call putchar
    mov al, 0x20                ; caractere espaço
    call putchar
    call putchar
    call putchar
    ret
draw_get_the_jetpack_string:
    mov bl, 10
    mov dh, 1    
    mov dl, 23
    call go_to_xy

    mov si, get_the_jetpack_string
    call prints
    ret
draw_score_string:
    mov bl, 10
    mov dh, 1    
    mov dl, 1
    call go_to_xy

    mov si, score_string
    call prints
    ret
draw_score_value:
    mov bl, 10
    mov dh, 1
    mov dl, 7
    call go_to_xy
    mov al, [score]
    call putchar
    ret

draw_jetpack:
    mov dh, 22                  ;
    mov dl, 10                  ; Move cursor para a linha 23 e coluna 5
    call go_to_xy
    mov bl, 10
    mov al, 1                   ;
    call putchar                ; desenha 'O'
    ret


normal_movement:
    mov cl, [game_over_boolean]
    cmp cl, 1
    je .end_game

    call draw_dave

    call getchar

    cmp al, "w"
    je .move_up

    cmp al, "a"
    je .move_left

    cmp al, "d"
    je .move_right
    
    jmp game_loop


    .move_up:
        call clean_dave_current_pos
        dec byte [dave_pos_y]
        call draw_dave
        cmp dh, 21
        je .gravity
        

    .move_left:
        dec dl
        call go_to_xy
        call read_char_in_cursor_pos
        cmp ah, 7                       ;compara cor do caractere onde o cursor está posicionado (cinza)
        je game_loop

        call clean_dave_current_pos
        dec byte [dave_pos_x]
        jmp game_loop

    .move_right:
        inc dl
        call go_to_xy
        call read_char_in_cursor_pos
        cmp ah, 10                      ;compara cor do caractere onde o cursor está posicionado (verde claro)
        je .jetpack_on

        call clean_dave_current_pos
        inc byte [dave_pos_x]
        jmp game_loop
    
    .gravity:
        mov cx, 2      ;HIGH WORD.
        mov dx, 3       ;LOW WORD.
        mov ah, 86h    ;WAIT.
        int 15h

        call clean_dave_current_pos
        inc byte [dave_pos_y]
        jmp game_loop

    .jetpack_on:
        inc byte [jetpack_boolean]
        call draw_jetpack_on_string
        call clean_dave_current_pos
        inc byte [dave_pos_x]
        jmp game_loop
    
    .end_game:
        ret
        jmp game_loop
jetpack_movement:
    mov al, [jetpack_boolean]
    cmp al, 0
    je normal_movement
    call draw_dave

    mov cx, 5      ;HIGH WORD.
    mov dx, 3   ;LOW WORD.
    mov ah, 86h    ;WAIT.
    int 15h
    call getchar
    mov dl, [dave_pos_x]
    mov dh, [dave_pos_y]

    cmp al, "w"
    je .move_up

    cmp al, "a"
    je .move_left

    cmp al, "s"
    je .move_down

    cmp al, "d"
    je .move_right
    
    jmp game_loop

    .move_up:
        dec dh
        call go_to_xy
        call read_char_in_cursor_pos
        cmp ah, 4
        je game_loop
        call collect_gem
        
        call clean_dave_current_pos
        dec byte [dave_pos_y]
        jmp game_loop

    .move_left:
        dec dl
        call go_to_xy
        call read_char_in_cursor_pos
        cmp ah, 4                           ; vermelho
        je game_loop
        cmp ah, 7                           ; cinza
        je game_loop
        cmp ah, 6                           ; marrom
        je .check_game_over
        call collect_gem

        call clean_dave_current_pos
        dec byte [dave_pos_x]
        jmp game_loop

    .move_down:
        inc dh
        call go_to_xy
        call read_char_in_cursor_pos
        cmp ah, 4
        je game_loop
        cmp ah, 7
        je game_loop
        cmp ah, 6
        je game_loop
        call collect_gem

        
        call clean_dave_current_pos
        inc byte [dave_pos_y]
        jmp game_loop

    .move_right:
        inc dl
        call go_to_xy
        call read_char_in_cursor_pos
        cmp ah, 4
        je game_loop
        call collect_gem

        call clean_dave_current_pos
        inc byte [dave_pos_x]
        jmp game_loop

    .check_game_over:
        mov cl, [score]
        cmp cl, 57              ; checa se o score está apontando para o código ASCII do caractere '9'
        je .game_over
        jmp game_loop
    
    .game_over:
        inc byte [game_over_boolean]
        jmp clear
        ret

game_loop:
    call jetpack_movement
    call normal_movement
    ret

start:          
    mov ax, 13h             ; iniciar modo gráfico
    int 10h         

    xor ax, ax              ; limpando ax
    mov ds, ax              ; limpando ds

    call start_screen
    call start_game

    call draw_scenario
    call draw_items

    call draw_score_string
    call draw_get_the_jetpack_string
    call draw_score_value

    call game_loop
    call game_over_screen



jmp $