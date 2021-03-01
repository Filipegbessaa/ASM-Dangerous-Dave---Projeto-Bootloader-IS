org 0x7e00
jmp 0x0000:start 

data:
    press_enter db 'Press ENTER to start',0
    dangerous_dave db 'Dangerous Dave',0
    ground db '----------------------------------------',0

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
    mov dl, 0x0B
    mov dh, 0x0C
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

    mov dl, 0x0E
    mov dh, 0x02    
    mov bh, 0      
    mov ah, 0x2
    int 0x10
    mov si, dangerous_dave
    call prints

    ; reset cursor to the center of the screen
    mov dl, 0x0B
    mov dh, 0x0C
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
    mov dl, 0
    mov dh, 24
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
    mov dl, 0
    mov dh, 0
    .loop
        mov bh, 0      
        mov ah, 0x2
        int 0x10

        mov al, '|'
        mov bl, 0x04
        call putchar
        inc dh
        cmp dh, 24
        je .endloop
        jmp .loop
    
    .draw_pipe:
        mov dl, 1
        mov dh, 20
        mov bh, 0      
        mov ah, 0x2
        int 0x10

        mov bl, 07      ;Draw the top of the pipe
        mov al, '-'
        call putchar
        inc dl
        call putchar
        inc dl 
        call putchar
        inc dl
        inc dh          
        mov bh, 0       ;Draw the pipe outlet
        mov ah, 0x2
        int 0x10
        mov al, 'O'
        call putchar

        mov dh, 22
        mov dl, 1
        mov bh, 0      ;Draw the bottom of the pipe
        mov ah, 0x2
        int 0x10
        mov al, '-'
        call putchar
        inc dl 
        call putchar
        inc dl 
        call putchar
        
    .endloop
    jmp .draw_pipe
    ret



draw_dave:

    mov dl, 5
    mov dh, 22
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    mov al, '6'
    mov bl, 0x04
    call putchar
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
    call draw_dave





jmp $