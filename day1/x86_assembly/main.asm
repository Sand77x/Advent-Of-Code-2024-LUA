; x86 for part 1 (no merge sort)
; I could not code this without it
; I would probably have a stroke

    section .data
read:       db "r", 0
read_2d:    db "%d %d", 0
filename:   db "../input.txt", 0
dbg:        db "%d", 10, 0
ferror_msg: db "Failed to open file.", 10, 0
arr_size:   dd 1000
    section .bss
file_ptr:   resd 1
arr1:       resd 1
arr2:       resd 1
    section .text
    global _main
    extern _printf, _fopen, _fclose, _fscanf, _malloc
    extern _qsort, _comp
_main:
    ; create file pointer
    push read
    push filename
    call _fopen
    add esp, 8

    ; check if succeed
    test eax, eax
    jz file_error

    ; move pointer to inp
    mov [file_ptr], eax

    ; init variables for reading
    xor ebx, ebx            ; counter for arr_size 

    ; malloc space for arr1 and arr2
    mov eax, 4
    mul dword[arr_size]
    push eax
    call _malloc
    add esp, 4
    mov [arr1], eax

    mov eax, 4
    mul dword[arr_size]
    push eax
    call _malloc
    add esp, 4
    mov [arr2], eax

    ; lea the two arrays
    mov edi, [arr1]
    mov esi, [arr2]

    ; store 2 integers in lists
    read_from_file:
        push esi
        push edi
        push read_2d
        push dword[file_ptr]
        call _fscanf 
        add esp, 16

        ; update counter and ptrs
        add esi, 4
        add edi, 4

    ; loop back if _fscanf returns 2
    cmp eax, 2
    je read_from_file

    ; sort both lists
    ; push dword[arr_size]
    ; push arr1
    ; call _merge_sort
    ; add esp, 8

    ; sort arr1
    push _comp
    push 4
    push dword[arr_size]
    push dword[arr1]
    call _qsort
    add esp, 16

    ; sort arr2
    push _comp
    push 4
    push dword[arr_size]
    push dword[arr2]
    call _qsort
    add esp, 16

    xor ebx, ebx      ; init total to 0
    xor ecx, ecx      ; init counter to 0
loop_start:
    ; for i in 0..arr_siz
    cmp ecx, [arr_size]
    jge loop_end

    ; get abs value of list1[i] and list2[i]
    mov edx, [arr1]
    mov eax, [edx+ecx*4]
    mov edx, [arr2]
    sub eax, [edx+ecx*4]

    ; if val < 0
    cmp eax, 0
    jge add_to_total

    ; make it positive
    neg eax

add_to_total:
    add ebx, eax
    inc ecx
    jmp loop_start
loop_end:

    push ebx
    push dbg
    call _printf
    add esp, 8

    ; close file
    push dword[file_ptr]
    call _fclose
    add esp, 4
    xor eax, eax
    ret

file_error:
    ; if file fails to open
    push ferror_msg
    call _printf
    add esp, 4
    xor eax, eax
    ret
