    section .data
dbg:      db "%d %d", 10, 0
    section .text
    global _comp
    extern _printf
_comp:
    push ebp
    mov ebp, esp

    push edi
    push esi

    ; [ebp+8]
    ; [ebp+12]
    mov edi, [ebp+8]
    mov edi, [edi]
    mov esi, [ebp+12]
    mov esi, [esi]
    sub edi, esi

    mov eax, edi

    pop esi
    pop edi

    mov esp, ebp
    pop ebp
    ret
