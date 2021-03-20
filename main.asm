.386                   
.model flat, stdcall
.stack 4096                   
option casemap :none                    

include \masm32\include\windows.inc     
include \masm32\macros\macros.asm       
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data 
    szPrompt    db          'Digite seu RA: ', 0 ; String para cabecalho
    repeticao   db          100 dup (0) ; Array que contem a contagem de repeticao


.data?
    txtInput    db          250 dup(0) ; Array que representa o RA fornecido pelo usuario
    

.code
    main:
        mov ebx, 0 ; Contador
        mov ecx, 0 ; Contador
        lea edi, repeticao ; Contem valores repetidos
        
        print offset szPrompt ; Printa cabecalho
        invoke StdIn, offset txtInput, sizeof txtInput ; Espera o input do usuario

        mov byte ptr txtInput [eax], 0
      
        lea eax, txtInput ; Armazena o RA digitado
    
    ; ///////////////////////////////// Ordenacao do RA /////////////////////////////////

    ; Troca posicoes do RA se for possivel
    ordenar:
        cmp ebx, 4 ; Esta no fim do vetor
        je zerarCont

        mov dh, byte ptr [eax + ebx] ; Anterior
        mov dl, byte ptr [eax + ebx + 1] ; Proximo

        ; Se o anterior for maior que o proximo
        cmp dh, dl
        jg trocar

        inc ebx
        xor ecx, ecx
        jmp validar
    
    ; Verifica se o vetor esta ordenado
    validar:
        mov dh, byte ptr[eax + ecx]
        mov dl, byte ptr[eax + ecx + 1]

        ; Se o anterior for maior que o proximo a ordenacao continua
        cmp dh, dl
        jg ordenar

        inc ecx

        ; Enquanto nao encontrou um elemento anterior maior que o proximo continua validacao
        cmp ecx, 4
        jne validar
        
        ; RA esta ordenado
        mov ebp, 0
        mov esi, 0
        xor ebx, ebx
        mov ecx, 1
        jmp primeiroFor

    ; Zera o contador para recomecar a troca de posicoes
    zerarCont:
        xor ebx, ebx
        jmp ordenar

    ; Realiza de troca de posicoes do RA
    trocar:
        mov byte ptr[eax + ebx], dl
        mov byte ptr[eax + ebx + 1], dh

        inc ebx

        jmp ordenar
    
    ; ///////////////////////////////// Contagem de Repeticao /////////////////////////////////
    
    ; Abaixo dois lacos de repeticao, um lento e outro rapido, executam a funcao de verificar  
    ; a presenca de elementos repetidos

    ; Primeiro for para indice lento
    primeiroFor:
        mov dh, byte ptr[eax + ebx]
        
        cmp ebx, 5
        jne segundoFor

        jmp ultimaEtapa
    
    ; Segundo for para indice rapido
    segundoFor:
        cmp ecx, 5 ; Indice rapido ja passou por todas as posicoes
        je reiniciarRapido

        mov dl, byte ptr[eax + ecx]
    
        ; Encontrou dois elementos iguais
        cmp dh, dl
        je realizarContagem

        inc ecx

        jmp segundoFor
    
    ; Funcao que verifica e insere, se puder, o elementor repetido
    realizarContagem:
        mov dl, byte ptr[eax + ebx - 1] ; Obtem o elemento anteriror ao elemento lento atual

        cmp dh, dl ; Verifica se ja houve contagem desse elemento
        je apenasSeguir

        inc esi
        inc ecx
        jmp segundoFor
    
    ; Funcao que apenas continua todo o processo de loop (lacos)
    apenasSeguir:
        inc ecx
        jmp segundoFor
    
    ; Reinicia o indice rapido, e se houver contagem de elemento repetido, guarda o mesmo
    reiniciarRapido:
        add esi, 48 ; Converte para caracter ASCII

        cmp esi, 48 ; Verifica se houve contagem (se esi for 48 quer dizer que nao foi incrementado)
        jg inserirContagem

        xor esi, esi
        inc ebx
        mov ecx, ebx
        inc ecx
        jmp primeiroFor
    
    ; Insere a contagem na string de edi
    inserirContagem:
        inc esi

        mov dh, byte ptr[eax + ebx]
        mov dword ptr[edi + ebp], "{"
        mov byte ptr[edi + ebp + 1], dh
        mov dword ptr[edi + ebp + 2], ":"
        mov dword ptr[edi + ebp + 3], esi
        mov dword ptr[edi + ebp + 4], "x"
        mov dword ptr[edi + ebp + 5], "}"
        
        add ebp, 6
        mov ecx, ebx

        xor esi, esi
        inc ebx
        inc ecx
        jmp primeiroFor

    ; ///////////////////////////////// Printar valores /////////////////////////////////

    ; Se o RA nao tem repeticao
    semRepeticao:
        print chr$(10, 13)
        print chr$("RA sem repeticao")
        jmp fim
    
    ; Se o RA tem repeticao
    comRepeticao:
        print chr$(10, 13)
        print chr$("Numero (s) repetido (s): ")
        print edi
        jmp fim
            
    ; Penultima funcao, para verificar como serao printados os valores
    ultimaEtapa:
        print eax

        mov dl, byte ptr[edi]
        
        ; Se dl for 0, quer dizer que o edi nao foi alterado
        cmp dl, 0
        je semRepeticao

        jmp comRepeticao

    ; Fim do programa
    fim:
        end main