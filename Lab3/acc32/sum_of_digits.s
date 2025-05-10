.data
input_addr:   .word  0x80      ; Input address containing the pointer to the number 'n'
output_addr:  .word  0x84      ; Output address containing the pointer to where the result is stored
n:            .word  0x00      ; Variable to store the number 'n'
result:       .word  0x00      ; Variable to store the sum of digits, initialized to 0
temp:         .word  0x00      ; Temporary variable to store intermediate values
const_10:     .word  0x0A      ; Constant 10
const_1:      .word  0x01      ; Constant 1


    .text
_start:
    load_ind        input_addr              ; acc <- mem[mem[input_addr]]
    store_addr      n                       ; mem[n] <- acc

    load_addr       n                       ; acc <- mem[n]
    bgt             sum_begin               ; If acc > 0, jump to sum_begin
    ble             convert_positive        ; If acc < 0, jump to convert_positive

convert_positive:
    load_addr       n                       ; acc <- mem[n]
    not                                     ; acc <- ~acc
    add             const_1                 ; acc <- ~acc + 1
    store_addr      n                       ; mem[n] <- acc

sum_begin:
    load_imm        0                       ; acc <- 0
    store_addr      result                  ; mem[result] <- 0
    load_addr       n                       ; acc <- mem[n]

sum_while:
    beqz            sum_end                 ; If acc == 0, jump to sum_end
    rem             const_10                ; acc <- acc % mem[const_10]
    store_addr      temp                    ; mem[temp] <- acc
    load_addr       result                  ; sum: acc <- mem[result]
    add             temp                    ; acc <- acc + mem[temp]
    bvs             sum_overflow            ; If overflow, jump to sum_overflow
    store_addr      result                  ; mem[result] <- acc
    load_addr       n                       ; acc <- mem[n]
    div             const_10                ; acc <- acc / mem[const_10]
    store_addr      n                       ; mem[n] <- acc
    load_addr       n                       ; acc <- mem[n]
    jmp             sum_while               

sum_end:
    load_addr       result                  ; acc <- mem[result]
    store_ind       output_addr             ; mem[mem[output_addr]] <- acc
    halt                       

sum_overflow:
    load_imm        0xCCCC_CCCC                    ; acc <- 0xCC
    store_ind       output_addr             ; mem[mem[output_addr]] <- acc
    halt  
    