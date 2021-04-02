#include <ESP8266WiFi.h>
#include "DHTesp.h"

DHTesp dht;

//nastavenie wifi
const char* ssid = "interniet";
const char* password = "Smazak123.";

const char* nazov = "TeraMale";

int dht_pin = 12;

//pridanie podpory wifi
WiFiServer ESPserver(80);//Service Port

//ktore piny chcem pouzivat
int zoznam_pinov[] = { 3, 5, 4, 0};      
int pocet_pinov = sizeof(zoznam_pinov) / sizeof(zoznam_pinov[0]);


void setup()
  {
  String thisBoard= ARDUINO_BOARD;
  dht.setup(dht_pin, DHTesp::DHT22);
    
  Serial.begin(115200);
  Serial.println("");
  Serial.println("#######################################");

  Serial.print("Pripravujem GPIO piny: "); 
  for (int i = 0; i < pocet_pinov; i++) 
    { 
    Serial.print(zoznam_pinov[i]); 
    Serial.print(", "); 
    pinMode(zoznam_pinov[i], OUTPUT);
    }
   
  Serial.println();
  Serial.print("Pirpajam sa na WiFi siet: ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);
  IPAddress ip(192, 168, 0, 240);
  IPAddress gateway(192, 168, 0, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.config(ip, gateway, subnet);

  delay(5000);

  while (WiFi.status() != WL_CONNECTED)
    {
    delay(500);
    Serial.print(".");
    }
  Serial.println("");
  Serial.println("WiFi pripojenie bolo uspesne");

  ESPserver.begin();
  Serial.println("Web server bol spusteny");

  Serial.print("Adresa web servera je: ");
  Serial.print("http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");
}

void loop()
{
  // Check if a client has connected
  WiFiClient client = ESPserver.available();
  if (!client)
    return;

  // Wait until the client sends some data
  //Serial.println("new client");
  while (!client.available())
    delay(1);

  // Read the first line of the request
  String request = client.readStringUntil('\r');
  //Serial.println(request);
  client.flush();

  //if (request.indexOf("/status=") == -1)
  //  return; 
  
  Serial.println("");
  Serial.println("Klient pripojeny");
  Serial.println(request);

  if (request.indexOf("/status=") != -1)
    {
    String url_status = request.substring( 5, 13);
    String url_pin = request.substring( 14, 19);
    if ( url_status != ""  &&  url_pin != "" )
      {
      url_status = url_status.substring( 7, 8);
      url_pin = url_pin.substring( 4, 5);
  
      Serial.print("status: " + url_status);
      Serial.println(" - pin: " + url_pin);
  
      int pom = 0;
      for (int i = 0; i < pocet_pinov; i++) 
        { if ( zoznam_pinov[i] == url_pin.toInt() ) pom = 1; }
        
      if ( pom == 1 )
        {
        if ( url_status.toInt() == 0 ) digitalWrite(url_pin.toInt(), LOW);
        if ( url_status.toInt() == 1 ) digitalWrite(url_pin.toInt(), HIGH);
        }
      }
    }

  delay(dht.getMinimumSamplingPeriod());
  float humidity = dht.getHumidity();
  float temperature = dht.getTemperature();

  // Obsah stranky
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: text/html");
  client.println(""); //  IMPORTANT
  client.println("<!DOCTYPE HTML>");
  client.println("<html>");
  client.println("<h1>Nazov modulu: ");
  client.println(nazov);
  client.println("</h1><br>");
  
  for (int i = 0; i < pocet_pinov; i++) 
    { 
    client.println("D");
    client.println( zoznam_pinov[i] );
    client.println(" - <a href=\"/status=0&pin=");
    client.println(zoznam_pinov[i]);
    client.println("\">OFF</a> / <a href=\"/status=1&pin=");
    client.println(zoznam_pinov[i]);
    client.println("\">ON</a><br>");
    }
  client.println("<br><br>Stav senzoru: ");
  client.println( dht.getStatusString() );
  client.println("<br>Vlhkost: ");
  client.println(humidity);
  client.println("% <br>Teplota: ");
  client.println(temperature);
  client.println("C </html>");

  delay(1);
  Serial.println("Klient odpojeny");
  Serial.println("");
}
