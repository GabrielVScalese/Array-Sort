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
    szPrompt    db          'Digite seu RA: ', 0
    repeticao   db          100 dup (0)


.data?
    txtInput    db          250 dup(0)    
    

.code
    main:
        mov ebx, 0
        mov ecx, 0
        lea edi, repeticao ; Contem valores repetidos
        
        print offset szPrompt ; Printa cabecalho
        invoke StdIn, offset txtInput, sizeof txtInput ; Espera o input do usuario

        mov byte ptr txtInput [eax], 0
      
        lea eax, txtInput ; Armazena o RA digitado
    
    ; ///////////////////////////////// Ordenacao do RA /////////////////////////////////

    ; Chama metodo de troca de posicoes
    ordenar:
        cmp ebx, 4 ; Esta no fim do vetor
        je zerarCont

        mov dh, byte ptr [eax + ebx] ; Anterior
        mov dl, byte ptr [eax + ebx + 1] ; Fim

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

        cmp dh, dl
        jg ordenar

        inc ecx

        cmp ecx, 4
        jne validar
        
        mov esi, 0
        xor ebx, ebx
        mov ecx, 1
        jmp primeiroFor

    ; Zerar o contador para recomecar a troca de posicoes
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
    
    ; For com indice lento
    primeiroFor:
        mov dh, byte ptr[eax + ebx]
        
        cmp ebx, 5
        jne segundoFor

        xor dh, dh
        xor ebx, ebx
        mov ecx, 1
        xor esi, esi
        jmp primeiroFor2
    
    ; For com indice rapido
    segundoFor:
        cmp ecx, 5
        je reiniciarRapido

        mov dl, byte ptr[eax + ecx]
    
        cmp dh, dl
        je inserirRepetido

        inc ecx

        jmp segundoFor

    ; Insere os valores repetidos encontrados no RA
    inserirRepetido:
        mov dl, byte ptr[edi + esi - 2]

        cmp dl, dh
        je apenasSeguir

        mov byte ptr[edi + esi], dh
        mov byte ptr[edi + esi + 1], ","
        add esi, 2
        inc ecx
        jmp segundoFor
    
    ; Continua o loop sem inserir o elemento repetido
    apenasSeguir:
        inc ecx
        jmp segundoFor
    
    ; Reinicia o indice rapido
    reiniciarRapido:
        inc ebx
        mov ecx, ebx
        inc ecx
        jmp primeiroFor
    
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
    

    ; //////////////////////////////////////////////

    primeiroFor2:
        mov dh, byte ptr[eax + ebx]
        
        cmp ebx, 5
        jne segundoFor2

        jmp ultimaEtapa
    
    segundoFor2:
        cmp ecx, 5
        je reiniciarRapido2

        mov dl, byte ptr[eax + ecx]
    
        cmp dh, dl
        je realizarContagem

        inc ecx

        jmp segundoFor2
    
    realizarContagem:
        mov dl, byte ptr[eax + ebx - 1]

        cmp dh, dl
        je apenasSeguir2

        inc esi
        inc ecx
        jmp segundoFor2
    
    apenasSeguir2:
        inc ecx
        jmp segundoFor2
    
    reiniciarRapido2:
        add esi, 48

        cmp esi, 48
        jne inserirContagem

        xor esi, esi
        inc ebx
        mov ecx, ebx
        inc ecx
        jmp primeiroFor2
    
    inserirContagem:
        inc esi
        mov dh, byte ptr[eax + ebx]
        mov dword ptr[edi + ebx + 1], "["
        mov byte ptr[edi + ebx + 2], dh
        mov dword ptr[edi + ebx + 3], ":"
        mov dword ptr[edi + ebx + 4], esi
        mov dword ptr[edi + ebx + 4], "x"
        mov dword ptr[edi + ebx + 5], "]"
        xor esi, esi
        inc ebx
        mov ecx, ebx
        inc ecx
        jmp primeiroFor2

    ; //////////////////////////////////////////////
            
    ; Penultima funcao, para verificar como serao printados os valores
    ultimaEtapa:
        print eax

        mov dl, byte ptr[edi]
        cmp dl, 0
        je semRepeticao

        jmp comRepeticao

    ; Fim do programa
    fim:
        end main