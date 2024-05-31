    INCLUDE <P16F627A.INC>

    ORG 0x00
    GOTO main

    ORG 0x04
    RETFIE

main:
    ; Initialize ports
    BSF     STATUS, RP0       ; Select Bank 1
    CLRF    TRISA             ; Set PORTA as input
    MOVLW   0x00
    MOVWF   TRISA
    MOVLW   0x00
    MOVWF   TRISB             ; Set PORTB as output
    BCF     STATUS, RP0       ; Select Bank 0
    CLRF    PORTB             ; Clear PORTB
    CLRF    0x20              ; Clear counter value

check_switches:
    BTFSC   PORTA, 0          ; Check if RA0 is pressed
    CALL    increment

    BTFSC   PORTA, 1          ; Check if RA1 is pressed
    CALL    decrement

    CALL    display           ; Display counter value on 7-segment

    GOTO    check_switches    ; Loop

increment:
    INCF    0x20, F           ; Increment counter value
    CALL    delay             ; Wait for 250ms (Debounce)
    RETURN

decrement:
    DECF    0x20, F           ; Decrement counter value
    CALL    delay             ; Wait for 250ms (Debounce)
    RETURN

delay:
    MOVLW   0xFF
    MOVWF   0x21
    MOVLW   0xFF
    MOVWF   0x22
d1:
    DECFSZ  0x21, F
    GOTO    d1
    DECFSZ  0x22, F
    GOTO    d1
    RETURN

display:
    MOVF    0x20, W
    CALL    seg_decode
    MOVWF   PORTB
    RETURN

seg_decode:
    ADDWF   PCL, F
    RETLW   b'00111111'      ; 0
    RETLW   b'00000110'      ; 1
    RETLW   b'01011011'      ; 2
    RETLW   b'01001111'      ; 3
    RETLW   b'01100110'      ; 4
    RETLW   b'01101101'      ; 5
    RETLW   b'01111101'      ; 6
    RETLW   b'00000111'      ; 7
    RETLW   b'01111111'      ; 8
    RETLW   b'01101111'      ; 9

    END