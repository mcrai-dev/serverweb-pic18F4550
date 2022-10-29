
// duplex config flags
#define Spi_Ethernet_HALFDUPLEX     0x00  // half duplex
#define Spi_Ethernet_FULLDUPLEX     0x01  // full duplex

// mE ehternet NIC pinout
sfr sbit SPI_Ethernet_Rst at RC0_bit;
sfr sbit SPI_Ethernet_CS  at RC1_bit;
sfr sbit SPI_Ethernet_Rst_Direction at TRISC0_bit;
sfr sbit SPI_Ethernet_CS_Direction  at TRISC1_bit;
// end ethernet NIC definitions

typedef struct
{
  unsigned canCloseTCP: 1;  // flag which closes TCP socket (not relevant to UDP)
  unsigned isBroadcast: 1;  // flag which denotes that the IP package has been received via subnet broadcast address (not used for PIC16 family)
} TEthPktFlags;

/************************************************************
 * ROM constant strings
 */
const unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type: " ;  // HTTP header
const unsigned char httpMimeTypeHTML[] = "text/html\n\n" ;              // HTML MIME type
const unsigned char httpMimeTypeScript[] = "text/plain\n\n" ;           // TEXT MIME type
unsigned char httpMethod[] = "GET /";

 // Notre page se divise en 2 partie  l'entete  et le corp de notre page   ici  declaration entete
const char *indexPageHEAD = "<meta http-equiv='refresh' content='10;url=http://192.168.0.170/'>\
<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> \
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
<HTML><HEAD></HEAD><BODY>\
<h1 style=\"text-align: center;\">HOME CURRENT MESUREMENT</h1><hr>\
<p style=\"text-align: center;\"><a href=/>Reload</a><p>\
<script src=/s></script>";

// decalration corp de notre page
const char *indexPageBODY =  "<div> <table  align=center>\
            <tr><td>\
                    <h3 >CHAMBRE 1</h3>\
                    <p>en Ampere</p>\
                    <h4>\
                        <script>document.write(AN0); </script>\
                    </h4> </td>\
                <td>\
                    <h3 >CHAMBRE 2</h3>\
                    <p>en Ampere</p>\
                    <h4 >\
                        <script>document.write(AN2); </script>\
                    </h4> </td>\
                <td style=\"width: 5%;\"></td>\
                 </tr>\
                        <tr><td align = center colspan=2> <h3>PUISSANCE TOTAL</h3>\
                    <p style=\"text-align: center;\" >en Watt</p> \
                    <h4 style=\"background-color: #FFDEE9\">\
                    <script> document.write(PT); \
                        </script>\
                        </h4><br><p>PUISSANCE AUTORISE = 10 000 Watt</p></td>\
                       </tr>\
                        </table></div>";

const char *indexPageBODY2 =  "<p  style=\"text-align: center;\">This is HTTP request #<script>document.write(REQ)</script><p>\
</BODY></HTML>";

//*************************************************************************


/***********************************
 * Declaration variable prise1 est une  capteur1,  ainsi de suite
 */
unsigned char   myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f};   //  MAC address  PIC
unsigned char   myIpAddr[4]  = {192, 168, 0, 170};                     //  IP address   pic
unsigned char   getRequest[15];                                        // HTTP request bufferiser
unsigned char   get_Request, digit_getRequest, etat_interrupteur;
float prise1, prise2, prise3, prise4, priseT, prise34 ,prise12,max1, max2, max3;
unsigned int adc2, adc3, adc4, adc5;
unsigned char  dyna[30];   
float puissanceMax = 10000.0 ;    // puissance maxumum
unsigned long   httpCounter = 0;   // compteur requete HTTP

#define putConstString  SPI_Ethernet_putConstString
#define putString  SPI_Ethernet_putString


unsigned int  SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort,
                               unsigned int localPort, unsigned int reqLength, TEthPktFlags *flags)
{
  unsigned int    len = 0 ;
  unsigned int    i ;

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

  get_Request = getRequest[5];  // s

  if(get_Request == 's')  // utiliser pour <script src=/s></script>
  {

    len = putConstString(httpHeader);     // HTTP header
    len += putConstString(httpMimeTypeScript); // with text MIME type

    // recuperation valeur analogique de chaque AN0, AN1,AN2,AN3
    adc3 = ADC_Read(3);
    prise2 =( adc3 * 5.0 )  /1023.0;
    prise2 = (prise2 -2.5) / 0.066;
    prise2 = prise2 *220.0;
    
    adc2 = ADC_Read(2);
    prise1 =( adc2 * 5.0 )  /1023.0;
    prise1 = (prise1 -2.5) / 0.066;
    prise1 = prise1 *220.0;
    prise12 = prise2 + prise1;
    FloatToStr(prise12, dyna);
    len += putConstString("var AN2=");  //mandefa valeur mandeha am site
    len += putString(dyna);
    len += putConstString(";");




    adc5 = ADC_Read(1);
    prise4 =( adc5 * 5.0 )  /1023.0;
    prise4 = (prise4-2.5) / 0.066;
    prise4 = prise4 * 12.0;

    
    adc4 = ADC_Read(0);
    prise3 =( adc4 * 5.0 )  /1023.0;
    prise3 = (prise3 -2.5) / 0.066;
    prise3 = prise3 * 12.0;
    prise34 = prise3 + prise4;
    FloatToStr(prise34, dyna);
    //IntToStr(ADC_Read(3), dyna);
    len += putConstString("var AN0=");
    len += putString(dyna);
    len += putConstString(";");


   priseT = prise1 + prise2+ prise3+ prise4 ;
    FloatToStr(priseT, dyna);
    len += putConstString("var PT=");
    len += putString(dyna);
    len += putConstString(";");

 // add HTTP requests counter to reply
    IntToStr(httpCounter, dyna);
    len += putConstString("var REQ=");
    len += putString(dyna);
    len += putConstString(";");
  }
  else
  {
     //

   }

  if(len == 0)
  {           // what do to by default
    len =  putConstString(httpHeader);       // HTTP header
    len += putConstString(httpMimeTypeHTML); // with HTML MIME type
    len += putConstString(indexPageHEAD);    // HTML page first part
    len += putConstString(indexPageBODY);    // HTML page second part
    len += putConstString(indexPageBODY2);   // HTML page second part
  }

  return(len) ;                               // return to the library with the number of bytes to transmit
}



unsigned int  SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort,
                                   unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
{
   return 0;
}

/*
 * main entry
 */
void main()
{

PORTA = 0 ;
TRISA = 0xff ;          // mettre ports A en entré
TRISD = 0 ;             // mettre ports D en sortie

  /*
   * starts ENC28J60 with :
   * reset bit on RC0
   * CS bit on RC1
   * my MAC & IP address
   * full duplex
   */
SPI1_Init();
SPI_Ethernet_Init(myMacAddr, myIpAddr, Spi_Ethernet_FULLDUPLEX) ;

  while(1)
  {  

    SPI_Ethernet_doPacket() ;   // process incoming Ethernet packets
    
    if( puissanceMax  < priseT )
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