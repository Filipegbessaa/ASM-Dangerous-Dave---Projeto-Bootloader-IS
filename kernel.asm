org 0x7e00
jmp 0x0000:start 

data:
    press_enter db 'Press ENTER to start',0

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

    ; reset cursor to top left-most corner of screen
    mov dl, 0x1E
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
  print_left_wall:
      .loop1:

start_game:
    .loop2:
        call getchar    ;Recebe caractere do usuário
        cmp al, 0x0D    ;Compara o caractere digitado com ENTER (carriege return)
        je .endloop2     ;Se o caractere for ENTER, a tela é limpa
        jmp .loop2
    .endloop2:
        call clear
        ret
    



start:
    xor ax, ax    ;limpando ax
    mov ds, ax    ;limpando ds
    mov es, ax    ;limpando es


    ;limpando a tela, em bl fica o valor da cor que vai ser utilizada na tela, 15 é o valor branco, outras cores disponíveis no tutorial    
    mov bl, 14 
    call clear

    ;Imprimindo na tela a mensagem declarada em data
    mov si, press_enter    ;si aponta para o começo do endereço onde está mensagem
    call prints         ;Como só é impresso um caractere por vez, pegamos uma string com N caracteres e printamos um por um em ordem até chegar ao caractere de valor 0 que é o fim da string, assim prints pega a string para qual o ponteiro si aponta e a imprime na tela até o seu final
    call start_game





jmp $