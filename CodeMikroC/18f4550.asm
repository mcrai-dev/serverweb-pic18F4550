
_SPI_Ethernet_UserTCP:

;18f4550.c,85 :: 		unsigned int localPort, unsigned int reqLength, TEthPktFlags *flags)
;18f4550.c,87 :: 		unsigned int    len = 0 ;
	CLRF        SPI_Ethernet_UserTCP_len_L0+0 
	CLRF        SPI_Ethernet_UserTCP_len_L0+1 
;18f4550.c,90 :: 		if(localPort != 80)
	MOVLW       0
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP32
	MOVLW       80
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+0, 0 
L__SPI_Ethernet_UserTCP32:
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP0
;18f4550.c,92 :: 		return(0) ;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_SPI_Ethernet_UserTCP
;18f4550.c,93 :: 		}
L_SPI_Ethernet_UserTCP0:
;18f4550.c,96 :: 		for(i = 0 ; i < 10 ; i++)
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
L_SPI_Ethernet_UserTCP1:
	MOVLW       0
	SUBWF       SPI_Ethernet_UserTCP_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP33
	MOVLW       10
	SUBWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
L__SPI_Ethernet_UserTCP33:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP2
;18f4550.c,98 :: 		getRequest[i] = SPI_Ethernet_getByte() ;
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+1 
	CALL        _SPI_Ethernet_getByte+0, 0
	MOVFF       FLOC__SPI_Ethernet_UserTCP+0, FSR1
	MOVFF       FLOC__SPI_Ethernet_UserTCP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;18f4550.c,96 :: 		for(i = 0 ; i < 10 ; i++)
	INFSNZ      SPI_Ethernet_UserTCP_i_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_i_L0+1, 1 
;18f4550.c,99 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP1
L_SPI_Ethernet_UserTCP2:
;18f4550.c,101 :: 		getRequest[i] = 0 ;
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;18f4550.c,103 :: 		if(memcmp(getRequest, httpMethod, 5))
	MOVLW       _getRequest+0
	MOVWF       FARG_memcmp_s1+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_memcmp_s1+1 
	MOVLW       _httpMethod+0
	MOVWF       FARG_memcmp_s2+0 
	MOVLW       hi_addr(_httpMethod+0)
	MOVWF       FARG_memcmp_s2+1 
	MOVLW       5
	MOVWF       FARG_memcmp_n+0 
	MOVLW       0
	MOVWF       FARG_memcmp_n+1 
	CALL        _memcmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP4
;18f4550.c,105 :: 		return(0) ;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_SPI_Ethernet_UserTCP
;18f4550.c,106 :: 		}
L_SPI_Ethernet_UserTCP4:
;18f4550.c,108 :: 		httpCounter++ ;
	MOVLW       1
	ADDWF       _httpCounter+0, 1 
	MOVLW       0
	ADDWFC      _httpCounter+1, 1 
	ADDWFC      _httpCounter+2, 1 
	ADDWFC      _httpCounter+3, 1 
;18f4550.c,110 :: 		get_Request = getRequest[5];  // s
	MOVF        _getRequest+5, 0 
	MOVWF       _get_Request+0 
;18f4550.c,112 :: 		if(get_Request == 's')  // utiliser pour <script src=/s></script>
	MOVF        _getRequest+5, 0 
	XORLW       115
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP5
;18f4550.c,115 :: 		len = putConstString(httpHeader);     // HTTP header
	MOVLW       _httpHeader+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;18f4550.c,116 :: 		len += putConstString(httpMimeTypeScript); // with text MIME type
	MOVLW       _httpMimeTypeScript+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpMimeTypeScript+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpMimeTypeScript+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,119 :: 		adc3 = ADC_Read(3);
	MOVLW       3
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _adc3+0 
	MOVF        R1, 0 
	MOVWF       _adc3+1 
;18f4550.c,120 :: 		prise2 =( adc3 * 5.0 )  /1023.0;
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise2+0 
	MOVF        R1, 0 
	MOVWF       _prise2+1 
	MOVF        R2, 0 
	MOVWF       _prise2+2 
	MOVF        R3, 0 
	MOVWF       _prise2+3 
;18f4550.c,121 :: 		prise2 = (prise2 -2.5) / 0.066;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVLW       2
	MOVWF       R4 
	MOVLW       43
	MOVWF       R5 
	MOVLW       7
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise2+0 
	MOVF        R1, 0 
	MOVWF       _prise2+1 
	MOVF        R2, 0 
	MOVWF       _prise2+2 
	MOVF        R3, 0 
	MOVWF       _prise2+3 
;18f4550.c,122 :: 		prise2 = prise2 *220.0;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       92
	MOVWF       R6 
	MOVLW       134
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise2+0 
	MOVF        R1, 0 
	MOVWF       _prise2+1 
	MOVF        R2, 0 
	MOVWF       _prise2+2 
	MOVF        R3, 0 
	MOVWF       _prise2+3 
;18f4550.c,124 :: 		adc2 = ADC_Read(2);
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _adc2+0 
	MOVF        R1, 0 
	MOVWF       _adc2+1 
;18f4550.c,125 :: 		prise1 =( adc2 * 5.0 )  /1023.0;
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise1+0 
	MOVF        R1, 0 
	MOVWF       _prise1+1 
	MOVF        R2, 0 
	MOVWF       _prise1+2 
	MOVF        R3, 0 
	MOVWF       _prise1+3 
;18f4550.c,126 :: 		prise1 = (prise1 -2.5) / 0.066;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVLW       2
	MOVWF       R4 
	MOVLW       43
	MOVWF       R5 
	MOVLW       7
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise1+0 
	MOVF        R1, 0 
	MOVWF       _prise1+1 
	MOVF        R2, 0 
	MOVWF       _prise1+2 
	MOVF        R3, 0 
	MOVWF       _prise1+3 
;18f4550.c,127 :: 		prise1 = prise1 *220.0;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       92
	MOVWF       R6 
	MOVLW       134
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise1+0 
	MOVF        R1, 0 
	MOVWF       _prise1+1 
	MOVF        R2, 0 
	MOVWF       _prise1+2 
	MOVF        R3, 0 
	MOVWF       _prise1+3 
;18f4550.c,128 :: 		prise12 = prise2 + prise1;
	MOVF        _prise2+0, 0 
	MOVWF       R4 
	MOVF        _prise2+1, 0 
	MOVWF       R5 
	MOVF        _prise2+2, 0 
	MOVWF       R6 
	MOVF        _prise2+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise12+0 
	MOVF        R1, 0 
	MOVWF       _prise12+1 
	MOVF        R2, 0 
	MOVWF       _prise12+2 
	MOVF        R3, 0 
	MOVWF       _prise12+3 
;18f4550.c,129 :: 		FloatToStr(prise12, dyna);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _dyna+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;18f4550.c,130 :: 		len += putConstString("var AN2=");  //mandefa valeur mandeha am site
	MOVLW       ?lstr_4_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_4_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_4_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,131 :: 		len += putString(dyna);
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,132 :: 		len += putConstString(";");
	MOVLW       ?lstr_5_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_5_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_5_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,137 :: 		adc5 = ADC_Read(1);
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _adc5+0 
	MOVF        R1, 0 
	MOVWF       _adc5+1 
;18f4550.c,138 :: 		prise4 =( adc5 * 5.0 )  /1023.0;
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise4+0 
	MOVF        R1, 0 
	MOVWF       _prise4+1 
	MOVF        R2, 0 
	MOVWF       _prise4+2 
	MOVF        R3, 0 
	MOVWF       _prise4+3 
;18f4550.c,139 :: 		prise4 = (prise4-2.5) / 0.066;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVLW       2
	MOVWF       R4 
	MOVLW       43
	MOVWF       R5 
	MOVLW       7
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise4+0 
	MOVF        R1, 0 
	MOVWF       _prise4+1 
	MOVF        R2, 0 
	MOVWF       _prise4+2 
	MOVF        R3, 0 
	MOVWF       _prise4+3 
;18f4550.c,140 :: 		prise4 = prise4 * 12.0;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       64
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise4+0 
	MOVF        R1, 0 
	MOVWF       _prise4+1 
	MOVF        R2, 0 
	MOVWF       _prise4+2 
	MOVF        R3, 0 
	MOVWF       _prise4+3 
;18f4550.c,143 :: 		adc4 = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _adc4+0 
	MOVF        R1, 0 
	MOVWF       _adc4+1 
;18f4550.c,144 :: 		prise3 =( adc4 * 5.0 )  /1023.0;
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise3+0 
	MOVF        R1, 0 
	MOVWF       _prise3+1 
	MOVF        R2, 0 
	MOVWF       _prise3+2 
	MOVF        R3, 0 
	MOVWF       _prise3+3 
;18f4550.c,145 :: 		prise3 = (prise3 -2.5) / 0.066;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVLW       2
	MOVWF       R4 
	MOVLW       43
	MOVWF       R5 
	MOVLW       7
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise3+0 
	MOVF        R1, 0 
	MOVWF       _prise3+1 
	MOVF        R2, 0 
	MOVWF       _prise3+2 
	MOVF        R3, 0 
	MOVWF       _prise3+3 
;18f4550.c,146 :: 		prise3 = prise3 * 12.0;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       64
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise3+0 
	MOVF        R1, 0 
	MOVWF       _prise3+1 
	MOVF        R2, 0 
	MOVWF       _prise3+2 
	MOVF        R3, 0 
	MOVWF       _prise3+3 
;18f4550.c,147 :: 		prise34 = prise3 + prise4;
	MOVF        _prise4+0, 0 
	MOVWF       R4 
	MOVF        _prise4+1, 0 
	MOVWF       R5 
	MOVF        _prise4+2, 0 
	MOVWF       R6 
	MOVF        _prise4+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _prise34+0 
	MOVF        R1, 0 
	MOVWF       _prise34+1 
	MOVF        R2, 0 
	MOVWF       _prise34+2 
	MOVF        R3, 0 
	MOVWF       _prise34+3 
;18f4550.c,148 :: 		FloatToStr(prise34, dyna);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _dyna+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;18f4550.c,150 :: 		len += putConstString("var AN0=");
	MOVLW       ?lstr_6_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_6_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_6_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,151 :: 		len += putString(dyna);
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,152 :: 		len += putConstString(";");
	MOVLW       ?lstr_7_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_7_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_7_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,155 :: 		priseT = prise1 + prise2+ prise3+ prise4 ;
	MOVF        _prise1+0, 0 
	MOVWF       R0 
	MOVF        _prise1+1, 0 
	MOVWF       R1 
	MOVF        _prise1+2, 0 
	MOVWF       R2 
	MOVF        _prise1+3, 0 
	MOVWF       R3 
	MOVF        _prise2+0, 0 
	MOVWF       R4 
	MOVF        _prise2+1, 0 
	MOVWF       R5 
	MOVF        _prise2+2, 0 
	MOVWF       R6 
	MOVF        _prise2+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        _prise3+0, 0 
	MOVWF       R4 
	MOVF        _prise3+1, 0 
	MOVWF       R5 
	MOVF        _prise3+2, 0 
	MOVWF       R6 
	MOVF        _prise3+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        _prise4+0, 0 
	MOVWF       R4 
	MOVF        _prise4+1, 0 
	MOVWF       R5 
	MOVF        _prise4+2, 0 
	MOVWF       R6 
	MOVF        _prise4+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _priseT+0 
	MOVF        R1, 0 
	MOVWF       _priseT+1 
	MOVF        R2, 0 
	MOVWF       _priseT+2 
	MOVF        R3, 0 
	MOVWF       _priseT+3 
;18f4550.c,156 :: 		FloatToStr(priseT, dyna);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _dyna+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;18f4550.c,157 :: 		len += putConstString("var PT=");
	MOVLW       ?lstr_8_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_8_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_8_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,158 :: 		len += putString(dyna);
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,159 :: 		len += putConstString(";");
	MOVLW       ?lstr_9_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_9_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_9_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,162 :: 		IntToStr(httpCounter, dyna);
	MOVF        _httpCounter+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _httpCounter+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;18f4550.c,163 :: 		len += putConstString("var REQ=");
	MOVLW       ?lstr_10_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_10_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_10_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,164 :: 		len += putString(dyna);
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,165 :: 		len += putConstString(";");
	MOVLW       ?lstr_11_18f4550+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_11_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_11_18f4550+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,166 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP6
L_SPI_Ethernet_UserTCP5:
;18f4550.c,171 :: 		}
L_SPI_Ethernet_UserTCP6:
;18f4550.c,173 :: 		if(len == 0)
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP34
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
L__SPI_Ethernet_UserTCP34:
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP7
;18f4550.c,175 :: 		len =  putConstString(httpHeader);       // HTTP header
	MOVLW       _httpHeader+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;18f4550.c,176 :: 		len += putConstString(httpMimeTypeHTML); // with HTML MIME type
	MOVLW       _httpMimeTypeHTML+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,177 :: 		len += putConstString(indexPageHEAD);    // HTML page first part
	MOVF        _indexPageHEAD+0, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVF        _indexPageHEAD+1, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVF        _indexPageHEAD+2, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,178 :: 		len += putConstString(indexPageBODY);    // HTML page second part
	MOVF        _indexPageBODY+0, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVF        _indexPageBODY+1, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVF        _indexPageBODY+2, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,179 :: 		len += putConstString(indexPageBODY2);   // HTML page second part
	MOVF        _indexPageBODY2+0, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVF        _indexPageBODY2+1, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVF        _indexPageBODY2+2, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;18f4550.c,180 :: 		}
L_SPI_Ethernet_UserTCP7:
;18f4550.c,182 :: 		return(len) ;                               // return to the library with the number of bytes to transmit
	MOVF        SPI_Ethernet_UserTCP_len_L0+0, 0 
	MOVWF       R0 
	MOVF        SPI_Ethernet_UserTCP_len_L0+1, 0 
	MOVWF       R1 
;18f4550.c,183 :: 		}
L_end_SPI_Ethernet_UserTCP:
	RETURN      0
; end of _SPI_Ethernet_UserTCP

_SPI_Ethernet_UserUDP:

;18f4550.c,188 :: 		unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
;18f4550.c,190 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;18f4550.c,191 :: 		}
L_end_SPI_Ethernet_UserUDP:
	RETURN      0
; end of _SPI_Ethernet_UserUDP

_main:

;18f4550.c,196 :: 		void main()
;18f4550.c,199 :: 		PORTA = 0 ;
	CLRF        PORTA+0 
;18f4550.c,200 :: 		TRISA = 0xff ;          // mettre ports A en entré
	MOVLW       255
	MOVWF       TRISA+0 
;18f4550.c,201 :: 		TRISD = 0 ;             // mettre ports D en sortie
	CLRF        TRISD+0 
;18f4550.c,210 :: 		SPI1_Init();
	CALL        _SPI1_Init+0, 0
;18f4550.c,211 :: 		SPI_Ethernet_Init(myMacAddr, myIpAddr, Spi_Ethernet_FULLDUPLEX) ;
	MOVLW       _myMacAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_mac+0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_mac+1 
	MOVLW       _myIpAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_ip+0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_ip+1 
	MOVLW       1
	MOVWF       FARG_SPI_Ethernet_Init_fullDuplex+0 
	CALL        _SPI_Ethernet_Init+0, 0
;18f4550.c,213 :: 		while(1)
L_main8:
;18f4550.c,216 :: 		SPI_Ethernet_doPacket() ;   // process incoming Ethernet packets
	CALL        _SPI_Ethernet_doPacket+0, 0
;18f4550.c,218 :: 		if( puissanceMax  < priseT )
	MOVF        _priseT+0, 0 
	MOVWF       R4 
	MOVF        _priseT+1, 0 
	MOVWF       R5 
	MOVF        _priseT+2, 0 
	MOVWF       R6 
	MOVF        _priseT+3, 0 
	MOVWF       R7 
	MOVF        _puissanceMax+0, 0 
	MOVWF       R0 
	MOVF        _puissanceMax+1, 0 
	MOVWF       R1 
	MOVF        _puissanceMax+2, 0 
	MOVWF       R2 
	MOVF        _puissanceMax+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
;18f4550.c,220 :: 		if(prise1> prise2)
	MOVF        _prise1+0, 0 
	MOVWF       R4 
	MOVF        _prise1+1, 0 
	MOVWF       R5 
	MOVF        _prise1+2, 0 
	MOVWF       R6 
	MOVF        _prise1+3, 0 
	MOVWF       R7 
	MOVF        _prise2+0, 0 
	MOVWF       R0 
	MOVF        _prise2+1, 0 
	MOVWF       R1 
	MOVF        _prise2+2, 0 
	MOVWF       R2 
	MOVF        _prise2+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main11
;18f4550.c,222 :: 		max1 = prise1;
	MOVF        _prise1+0, 0 
	MOVWF       _max1+0 
	MOVF        _prise1+1, 0 
	MOVWF       _max1+1 
	MOVF        _prise1+2, 0 
	MOVWF       _max1+2 
	MOVF        _prise1+3, 0 
	MOVWF       _max1+3 
;18f4550.c,223 :: 		} else if(prise1= prise2){max1 = prise1;}
	GOTO        L_main12
L_main11:
	MOVF        _prise2+0, 0 
	MOVWF       _prise1+0 
	MOVF        _prise2+1, 0 
	MOVWF       _prise1+1 
	MOVF        _prise2+2, 0 
	MOVWF       _prise1+2 
	MOVF        _prise2+3, 0 
	MOVWF       _prise1+3 
	MOVF        _prise2+0, 0 
	IORWF       _prise2+1, 0 
	IORWF       _prise2+2, 0 
	IORWF       _prise2+3, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVF        _prise1+0, 0 
	MOVWF       _max1+0 
	MOVF        _prise1+1, 0 
	MOVWF       _max1+1 
	MOVF        _prise1+2, 0 
	MOVWF       _max1+2 
	MOVF        _prise1+3, 0 
	MOVWF       _max1+3 
	GOTO        L_main14
L_main13:
;18f4550.c,224 :: 		else if(prise1< prise2){max1 = prise2;
	MOVF        _prise2+0, 0 
	MOVWF       R4 
	MOVF        _prise2+1, 0 
	MOVWF       R5 
	MOVF        _prise2+2, 0 
	MOVWF       R6 
	MOVF        _prise2+3, 0 
	MOVWF       R7 
	MOVF        _prise1+0, 0 
	MOVWF       R0 
	MOVF        _prise1+1, 0 
	MOVWF       R1 
	MOVF        _prise1+2, 0 
	MOVWF       R2 
	MOVF        _prise1+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
	MOVF        _prise2+0, 0 
	MOVWF       _max1+0 
	MOVF        _prise2+1, 0 
	MOVWF       _max1+1 
	MOVF        _prise2+2, 0 
	MOVWF       _max1+2 
	MOVF        _prise2+3, 0 
	MOVWF       _max1+3 
;18f4550.c,225 :: 		}
L_main15:
L_main14:
L_main12:
;18f4550.c,227 :: 		if(prise3> prise4)
	MOVF        _prise3+0, 0 
	MOVWF       R4 
	MOVF        _prise3+1, 0 
	MOVWF       R5 
	MOVF        _prise3+2, 0 
	MOVWF       R6 
	MOVF        _prise3+3, 0 
	MOVWF       R7 
	MOVF        _prise4+0, 0 
	MOVWF       R0 
	MOVF        _prise4+1, 0 
	MOVWF       R1 
	MOVF        _prise4+2, 0 
	MOVWF       R2 
	MOVF        _prise4+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
;18f4550.c,229 :: 		max2 = prise3;
	MOVF        _prise3+0, 0 
	MOVWF       _max2+0 
	MOVF        _prise3+1, 0 
	MOVWF       _max2+1 
	MOVF        _prise3+2, 0 
	MOVWF       _max2+2 
	MOVF        _prise3+3, 0 
	MOVWF       _max2+3 
;18f4550.c,230 :: 		} else if(prise3= prise4){max2 = prise3;}
	GOTO        L_main17
L_main16:
	MOVF        _prise4+0, 0 
	MOVWF       _prise3+0 
	MOVF        _prise4+1, 0 
	MOVWF       _prise3+1 
	MOVF        _prise4+2, 0 
	MOVWF       _prise3+2 
	MOVF        _prise4+3, 0 
	MOVWF       _prise3+3 
	MOVF        _prise4+0, 0 
	IORWF       _prise4+1, 0 
	IORWF       _prise4+2, 0 
	IORWF       _prise4+3, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
	MOVF        _prise3+0, 0 
	MOVWF       _max2+0 
	MOVF        _prise3+1, 0 
	MOVWF       _max2+1 
	MOVF        _prise3+2, 0 
	MOVWF       _max2+2 
	MOVF        _prise3+3, 0 
	MOVWF       _max2+3 
	GOTO        L_main19
L_main18:
;18f4550.c,231 :: 		else if(prise3< prise4){max2 = prise4;
	MOVF        _prise4+0, 0 
	MOVWF       R4 
	MOVF        _prise4+1, 0 
	MOVWF       R5 
	MOVF        _prise4+2, 0 
	MOVWF       R6 
	MOVF        _prise4+3, 0 
	MOVWF       R7 
	MOVF        _prise3+0, 0 
	MOVWF       R0 
	MOVF        _prise3+1, 0 
	MOVWF       R1 
	MOVF        _prise3+2, 0 
	MOVWF       R2 
	MOVF        _prise3+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main20
	MOVF        _prise4+0, 0 
	MOVWF       _max2+0 
	MOVF        _prise4+1, 0 
	MOVWF       _max2+1 
	MOVF        _prise4+2, 0 
	MOVWF       _max2+2 
	MOVF        _prise4+3, 0 
	MOVWF       _max2+3 
;18f4550.c,232 :: 		}
L_main20:
L_main19:
L_main17:
;18f4550.c,234 :: 		if(max1> max2)
	MOVF        _max1+0, 0 
	MOVWF       R4 
	MOVF        _max1+1, 0 
	MOVWF       R5 
	MOVF        _max1+2, 0 
	MOVWF       R6 
	MOVF        _max1+3, 0 
	MOVWF       R7 
	MOVF        _max2+0, 0 
	MOVWF       R0 
	MOVF        _max2+1, 0 
	MOVWF       R1 
	MOVF        _max2+2, 0 
	MOVWF       R2 
	MOVF        _max2+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main21
;18f4550.c,236 :: 		max3 = max1;
	MOVF        _max1+0, 0 
	MOVWF       _max3+0 
	MOVF        _max1+1, 0 
	MOVWF       _max3+1 
	MOVF        _max1+2, 0 
	MOVWF       _max3+2 
	MOVF        _max1+3, 0 
	MOVWF       _max3+3 
;18f4550.c,237 :: 		} else if(max1= max2){max3 = max1;}
	GOTO        L_main22
L_main21:
	MOVF        _max2+0, 0 
	MOVWF       _max1+0 
	MOVF        _max2+1, 0 
	MOVWF       _max1+1 
	MOVF        _max2+2, 0 
	MOVWF       _max1+2 
	MOVF        _max2+3, 0 
	MOVWF       _max1+3 
	MOVF        _max2+0, 0 
	IORWF       _max2+1, 0 
	IORWF       _max2+2, 0 
	IORWF       _max2+3, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main23
	MOVF        _max1+0, 0 
	MOVWF       _max3+0 
	MOVF        _max1+1, 0 
	MOVWF       _max3+1 
	MOVF        _max1+2, 0 
	MOVWF       _max3+2 
	MOVF        _max1+3, 0 
	MOVWF       _max3+3 
	GOTO        L_main24
L_main23:
;18f4550.c,238 :: 		else if(max1< max2){max3 = max2;
	MOVF        _max2+0, 0 
	MOVWF       R4 
	MOVF        _max2+1, 0 
	MOVWF       R5 
	MOVF        _max2+2, 0 
	MOVWF       R6 
	MOVF        _max2+3, 0 
	MOVWF       R7 
	MOVF        _max1+0, 0 
	MOVWF       R0 
	MOVF        _max1+1, 0 
	MOVWF       R1 
	MOVF        _max1+2, 0 
	MOVWF       R2 
	MOVF        _max1+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
	MOVF        _max2+0, 0 
	MOVWF       _max3+0 
	MOVF        _max2+1, 0 
	MOVWF       _max3+1 
	MOVF        _max2+2, 0 
	MOVWF       _max3+2 
	MOVF        _max2+3, 0 
	MOVWF       _max3+3 
;18f4550.c,239 :: 		}
L_main25:
L_main24:
L_main22:
;18f4550.c,240 :: 		if (max3 == prise1)
	MOVF        _prise1+0, 0 
	MOVWF       R4 
	MOVF        _prise1+1, 0 
	MOVWF       R5 
	MOVF        _prise1+2, 0 
	MOVWF       R6 
	MOVF        _prise1+3, 0 
	MOVWF       R7 
	MOVF        _max3+0, 0 
	MOVWF       R0 
	MOVF        _max3+1, 0 
	MOVWF       R1 
	MOVF        _max3+2, 0 
	MOVWF       R2 
	MOVF        _max3+3, 0 
	MOVWF       R3 
	CALL        _Equals_Double+0, 0
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main26
;18f4550.c,242 :: 		PORTD.F0= 1;
	BSF         PORTD+0, 0 
;18f4550.c,243 :: 		}
L_main26:
;18f4550.c,244 :: 		if (max3 == prise2)
	MOVF        _prise2+0, 0 
	MOVWF       R4 
	MOVF        _prise2+1, 0 
	MOVWF       R5 
	MOVF        _prise2+2, 0 
	MOVWF       R6 
	MOVF        _prise2+3, 0 
	MOVWF       R7 
	MOVF        _max3+0, 0 
	MOVWF       R0 
	MOVF        _max3+1, 0 
	MOVWF       R1 
	MOVF        _max3+2, 0 
	MOVWF       R2 
	MOVF        _max3+3, 0 
	MOVWF       R3 
	CALL        _Equals_Double+0, 0
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main27
;18f4550.c,246 :: 		PORTD.F1= 1;
	BSF         PORTD+0, 1 
;18f4550.c,247 :: 		}
L_main27:
;18f4550.c,248 :: 		if (max3 == prise3)
	MOVF        _prise3+0, 0 
	MOVWF       R4 
	MOVF        _prise3+1, 0 
	MOVWF       R5 
	MOVF        _prise3+2, 0 
	MOVWF       R6 
	MOVF        _prise3+3, 0 
	MOVWF       R7 
	MOVF        _max3+0, 0 
	MOVWF       R0 
	MOVF        _max3+1, 0 
	MOVWF       R1 
	MOVF        _max3+2, 0 
	MOVWF       R2 
	MOVF        _max3+3, 0 
	MOVWF       R3 
	CALL        _Equals_Double+0, 0
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
;18f4550.c,250 :: 		PORTD.F2= 1;
	BSF         PORTD+0, 2 
;18f4550.c,251 :: 		}
L_main28:
;18f4550.c,252 :: 		if (max3 == prise4)
	MOVF        _prise4+0, 0 
	MOVWF       R4 
	MOVF        _prise4+1, 0 
	MOVWF       R5 
	MOVF        _prise4+2, 0 
	MOVWF       R6 
	MOVF        _prise4+3, 0 
	MOVWF       R7 
	MOVF        _max3+0, 0 
	MOVWF       R0 
	MOVF        _max3+1, 0 
	MOVWF       R1 
	MOVF        _max3+2, 0 
	MOVWF       R2 
	MOVF        _max3+3, 0 
	MOVWF       R3 
	CALL        _Equals_Double+0, 0
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main29
;18f4550.c,254 :: 		PORTD.F3= 1;
	BSF         PORTD+0, 3 
;18f4550.c,255 :: 		}
L_main29:
;18f4550.c,257 :: 		}else {
	GOTO        L_main30
L_main10:
;18f4550.c,258 :: 		PORTD.F0= 0;
	BCF         PORTD+0, 0 
;18f4550.c,259 :: 		PORTD.F1= 0;
	BCF         PORTD+0, 1 
;18f4550.c,260 :: 		PORTD.F2= 0;
	BCF         PORTD+0, 2 
;18f4550.c,261 :: 		PORTD.F3= 0;
	BCF         PORTD+0, 3 
;18f4550.c,262 :: 		}
L_main30:
;18f4550.c,265 :: 		}
	GOTO        L_main8
;18f4550.c,266 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
