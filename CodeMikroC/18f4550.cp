#line 1 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"






sfr sbit SPI_Ethernet_Rst at RC0_bit;
sfr sbit SPI_Ethernet_CS at RC1_bit;
sfr sbit SPI_Ethernet_Rst_Direction at TRISC0_bit;
sfr sbit SPI_Ethernet_CS_Direction at TRISC1_bit;


typedef struct
{
 unsigned canCloseTCP: 1;
 unsigned isBroadcast: 1;
} TEthPktFlags;
#line 22 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"
const unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type: " ;
const unsigned char httpMimeTypeHTML[] = "text/html\n\n" ;
const unsigned char httpMimeTypeScript[] = "text/plain\n\n" ;
unsigned char httpMethod[] = "GET /";
#line 34 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"
const char *indexPageHEAD = "<meta http-equiv='refresh' content='10;url=http://192.168.0.170/'><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">     <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><HTML><HEAD></HEAD><BODY><h1 style=\"text-align: center;\">HOME CURRENT MESUREMENT</h1><hr><p style=\"text-align: center;\"><a href=/>Reload</a><p><script src=/s></script>";
#line 59 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"
const char *indexPageBODY = "<div> <table  align=center>            <tr><td>                    <h3 >CHAMBRE 1</h3>                    <p>en Ampere</p>                    <h4>                        <script>document.write(AN0); </script>                    </h4> </td>                <td>                    <h3 >CHAMBRE 2</h3>                    <p>en Ampere</p>                    <h4 >                        <script>document.write(AN2); </script>                    </h4> </td>                <td style=\"width: 5%;\"></td>                 </tr>                        <tr><td align = center colspan=2> <h3>PUISSANCE TOTAL</h3>                    <p style=\"text-align: center;\" >en Watt</p>                     <h4 style=\"background-color: #FFDEE9\">                    <script> document.write(PT);                         </script>                        </h4><br><p>PUISSANCE AUTORISE = 10 000 Watt</p></td>                       </tr>                        </table></div>";
#line 62 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"
const char *indexPageBODY2 = "<p  style=\"text-align: center;\">This is HTTP request #<script>document.write(REQ)</script><p></BODY></HTML>";
#line 70 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"
unsigned char myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f};
unsigned char myIpAddr[4] = {192, 168, 0, 170};
unsigned char getRequest[15];
unsigned char get_Request, digit_getRequest, etat_interrupteur;
float prise1, prise2, prise3, prise4, priseT, prise34 ,prise12,max1, max2, max3;
unsigned int adc2, adc3, adc4, adc5;
unsigned char dyna[30];
float puissanceMax = 10000.0 ;
unsigned long httpCounter = 0;





unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort,
 unsigned int localPort, unsigned int reqLength, TEthPktFlags *flags)
{
 unsigned int len = 0 ;
 unsigned int i ;

 if(localPort != 80)
 {
 return(0) ;
 }


 for(i = 0 ; i < 10 ; i++)
 {
 getRequest[i] = SPI_Ethernet_getByte() ;
 }

 getRequest[i] = 0 ;

 if(memcmp(getRequest, httpMethod, 5))
 {
 return(0) ;
 }

 httpCounter++ ;

 get_Request = getRequest[5];

 if(get_Request == 's')
 {

 len =  SPI_Ethernet_putConstString (httpHeader);
 len +=  SPI_Ethernet_putConstString (httpMimeTypeScript);


 adc3 = ADC_Read(3);
 prise2 =( adc3 * 5.0 ) /1023.0;
 prise2 = (prise2 -2.5) / 0.066;
 prise2 = prise2 *220.0;

 adc2 = ADC_Read(2);
 prise1 =( adc2 * 5.0 ) /1023.0;
 prise1 = (prise1 -2.5) / 0.066;
 prise1 = prise1 *220.0;
 prise12 = prise2 + prise1;
 FloatToStr(prise12, dyna);
 len +=  SPI_Ethernet_putConstString ("var AN2=");
 len +=  SPI_Ethernet_putString (dyna);
 len +=  SPI_Ethernet_putConstString (";");




 adc5 = ADC_Read(1);
 prise4 =( adc5 * 5.0 ) /1023.0;
 prise4 = (prise4-2.5) / 0.066;
 prise4 = prise4 * 12.0;


 adc4 = ADC_Read(0);
 prise3 =( adc4 * 5.0 ) /1023.0;
 prise3 = (prise3 -2.5) / 0.066;
 prise3 = prise3 * 12.0;
 prise34 = prise3 + prise4;
 FloatToStr(prise34, dyna);

 len +=  SPI_Ethernet_putConstString ("var AN0=");
 len +=  SPI_Ethernet_putString (dyna);
 len +=  SPI_Ethernet_putConstString (";");


 priseT = prise1 + prise2+ prise3+ prise4 ;
 FloatToStr(priseT, dyna);
 len +=  SPI_Ethernet_putConstString ("var PT=");
 len +=  SPI_Ethernet_putString (dyna);
 len +=  SPI_Ethernet_putConstString (";");


 IntToStr(httpCounter, dyna);
 len +=  SPI_Ethernet_putConstString ("var REQ=");
 len +=  SPI_Ethernet_putString (dyna);
 len +=  SPI_Ethernet_putConstString (";");
 }
 else
 {


 }

 if(len == 0)
 {
 len =  SPI_Ethernet_putConstString (httpHeader);
 len +=  SPI_Ethernet_putConstString (httpMimeTypeHTML);
 len +=  SPI_Ethernet_putConstString (indexPageHEAD);
 len +=  SPI_Ethernet_putConstString (indexPageBODY);
 len +=  SPI_Ethernet_putConstString (indexPageBODY2);
 }

 return(len) ;
}



unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort,
 unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
{
 return 0;
}
#line 196 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"
void main()
{

PORTA = 0 ;
TRISA = 0xff ;
TRISD = 0 ;
#line 210 "C:/Users/Nilaina Solange/OneDrive/Bureau/18f45450/18f4550.c"
SPI1_Init();
SPI_Ethernet_Init(myMacAddr, myIpAddr,  0x01 ) ;

 while(1)
 {

 SPI_Ethernet_doPacket() ;

 if( puissanceMax < priseT )
 {
 if(prise1> prise2)
 {
 max1 = prise1;
 } else if(prise1= prise2){max1 = prise1;}
 else if(prise1< prise2){max1 = prise2;
 }

 if(prise3> prise4)
 {
 max2 = prise3;
 } else if(prise3= prise4){max2 = prise3;}
 else if(prise3< prise4){max2 = prise4;
 }

 if(max1> max2)
 {
 max3 = max1;
 } else if(max1= max2){max3 = max1;}
 else if(max1< max2){max3 = max2;
 }
 if (max3 == prise1)
 {
 PORTD.F0= 1;
 }
 if (max3 == prise2)
 {
 PORTD.F1= 1;
 }
 if (max3 == prise3)
 {
 PORTD.F2= 1;
 }
 if (max3 == prise4)
 {
 PORTD.F3= 1;
 }

 }else {
 PORTD.F0= 0;
 PORTD.F1= 0;
 PORTD.F2= 0;
 PORTD.F3= 0;
 }


 }
}
