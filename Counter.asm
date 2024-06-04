    INCLUDE <P16F627A.INC>     ; Include standard definitions for the PIC16F627A

    ORG 0x00                   ; Origin, starting address of the program
    GOTO main                  ; Go to main routine

    ORG 0x04                   ; Interrupt vector location
    RETFIE                     ; Return from interrupt

; Main program starts here
main:
    ; Initialize ports
    BSF     STATUS, RP0       ; Switch to Bank 1
    CLRF    TRISA             ; Clear TRISA to set PORTA as input
    MOVLW   0x00
    MOVWF   TRISA             ; Confirm PORTA as input
    MOVLW   0x00
    MOVWF   TRISB             ; Set PORTB as output
    BCF     STATUS, RP0       ; Switch to Bank 0
    CLRF    PORTB             ; Clear PORTB (turn off all segments)
    CLRF    0x20              ; Clear counter value at address 0x20

; Main loop to check the switches
check_switches:
    BTFSC   PORTA, 0          ; Check if RA0 (increment button) is pressed
    CALL    increment         ; If pressed, call increment subroutine

    BTFSC   PORTA, 1          ; Check if RA1 (decrement button) is pressed
    CALL    decrement         ; If pressed, call decrement subroutine

    CALL    display           ; Update the 7-segment display with current counter value

    GOTO    check_switches    ; Repeat the loop

; Subroutine to increment the counter
increment:
    INCF    0x20, F           ; Increment counter value at address 0x20
    MOVF    0x20, W           ; Move counter value to W register
    XORLW   0x0A              ; Compare W register with 10 (0x0A)
    BTFSS   STATUS, Z         ; Skip if not zero (i.e., counter is not 10)
    GOTO    skip_reset        ; Skip resetting if counter is not 10
    CLRF    0x20              ; Reset counter value to 0 if it was 10
skip_reset:
    CALL    delay             ; Call delay subroutine for debounce
    RETURN                    ; Return from subroutine

; Subroutine to decrement the counter
decrement:
    MOVF    0x20, W           ; Move counter value to W register
    IORLW   0x00              ; Compare W register with 0
    BTFSS   STATUS, Z         ; Skip if not zero (i.e., counter is not 0)
    GOTO    skip_set_to_9     ; Skip setting to 9 if counter is not 0
    MOVLW   0x09              ; Load W register with 9
    MOVWF   0x20              ; Set counter value to 9
    GOTO    skip_decrement    ; Skip normal decrement operation
skip_set_to_9:
    DECF    0x20, F           ; Decrement counter value at address 0x20
skip_decrement:
    CALL    delay             ; Call delay subroutine for debounce
    RETURN                    ; Return from subroutine

; Custom delay subroutine for debouncing
delay:
    MOVLW   0xFF              ; Load W register with 255
    MOVWF   0x21              ; Store 255 in register 0x21
    MOVLW   0xFF              ; Load W register with 255 again
    MOVWF   0x22              ; Store 255 in register 0x22
d1:
    DECFSZ  0x21, F           ; Decrement register 0x21 and skip if zero
    GOTO    d1                ; Loop until register 0x21 is zero
    DECFSZ  0x22, F           ; Decrement register 0x22 and skip if zero
    GOTO    d1                ; Loop until register 0x22 is zero
    RETURN                    ; Return from subroutine

; Display subroutine to update 7-segment display
display:
    MOVF    0x20, W           ; Move counter value to W register
    CALL    seg_decode        ; Call segment decode subroutine
    MOVWF   PORTB             ; Output decoded value to PORTB
    RETURN                    ; Return from subroutine

; Segment decode subroutine to convert counter value to 7-segment code
seg_decode:
    ADDWF   PCL, F            ; Add counter value to program counter (PCL)
    RETLW   b'00111111'       ; 0: Display 0 on 7-segment
    RETLW   b'00000110'       ; 1: Display 1 on 7-segment
    RETLW   b'01011011'       ; 2: Display 2 on 7-segment
    RETLW   b'01001111'       ; 3: Display 3 on 7-segment
    RETLW   b'01100110'       ; 4: Display 4 on 7-segment
    RETLW   b'01101101'       ; 5: Display 5 on 7-segment
    RETLW   b'01111101'       ; 6: Display 6 on 7-segment
    RETLW   b'00000111'       ; 7: Display 7 on 7-segment
    RETLW   b'01111111'       ; 8: Display 8 on 7-segment
    RETLW   b'01101111'       ; 9: Display 9 on 7-segment

    END                       ; End of program
