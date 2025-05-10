    .data

input_addr:      .word  0x80           
output_addr:     .word  0x84            
msk:            .word  0x0             


    .text
_start:
    @p input_addr a! @                  \ dataStack.push(mem[mem[input_addr]])

    count_leading_zeros 

    @p output_addr a! !                 \ mem[mem[output_addr]] <- dataStack.pop()
    halt

init_msk:
    lit 1                               \ dataStack.push(1)

    lit 30 >r                           \ for R = 30  
msk_cycle:
    2*                                  \ T << 1
    next msk_cycle

    !p msk ;                           \ mem[mask] <- dataStack.pop(); return

count_leading_zeros:
    dup if zero                         \ if dataStack.pop() == 0 then goto zero
    
    lit 0                               \ dataStack.push(0)
    over                                \ swap(T, S)
    
    init_msk

count_cycle:
    dup                                 \ dataStack.push(dataStack.top())
    
    @p msk                             \ dataStack.push(mem[mask])
    and                                 \ dataStack.push(dataStack.pop() & dataStack.pop())  
    
    if continue                         \ if dataStack.pop() == 0 then goto continue
    end ;                               \ else goto end  

continue:
    over lit 1 + over                   \ S += 1
    
    @p msk                             \ mem[mask] >> 1
    2/
    !p msk

    count_cycle ;                       \ goto count_cycle

end:
    over ;                              \ swap(T, S); return

zero:
    lit 32 ;                            \ dataStack.push(32); return

