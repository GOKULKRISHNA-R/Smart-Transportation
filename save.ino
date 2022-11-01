#include <SPI.h>
#include <MFRC522.h>
#include <ESP8266WiFi.h>
#include "FirebaseESP8266.h"
#include <ArduinoJson.h>
#include <Servo.h>

Servo myservo; 
 
#define FIREBASE_HOST "smart-transporation-cagd-default-rtdb.firebaseio.com" //Without http:// or https:// schemes
#define FIREBASE_AUTH "kYAbkbE55FlOAlRaRzKAlXROYDebyWO6aarpJPS4"
#define WIFI_SSID "Dhanush"
#define WIFI_PASSWORD "elxc2580"

constexpr uint8_t RST_PIN = D3;     // Configurable, see typical pin layout above
constexpr uint8_t SS_PIN = D4;     // Configurable, see typical pin layout above

MFRC522 rfid(SS_PIN, RST_PIN); // Instance of the class
MFRC522::MIFARE_Key key;



String tag;
FirebaseData firebaseData;
FirebaseData firebaseGetData;
StaticJsonDocument<1024> jsonDoc;

int y = 0;
int balance = 500 ;

void setup() {

  // // The servo control wire is connected to Arduino D2 pin.
  myservo.attach(5);
  // Servo is stationary.
  myservo.write(90);

  Serial.begin(9600);
  SPI.begin(); // Init SPI bus
  rfid.PCD_Init(); // Init MFRC522
 
  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
   
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {  
// Servo spins forward at full speed for 1 second.
  myservo.write(180);
  delay(50);
  // Servo is stationary for 1 second.
  myservo.write(90);
  delay(50);
  // Servo spins in reverse at full speed for 1 second.
  myservo.write(0);
  delay(50);
  // Servo is stationary for 1 second.
  myservo.write(90);
  delay(50);

  if ( ! rfid.PICC_IsNewCardPresent())
    return;
  if (rfid.PICC_ReadCardSerial()) {
    for (byte i = 0; i < 4; i++) {
      tag += rfid.uid.uidByte[i];
    }
    Serial.println(tag);
   
    String cpath = "Smart Trasportation/"+tag+"/count";
    String bpath = "Smart Trasportation/"+tag+"/balance";
   
   if (Firebase.getInt(firebaseGetData, cpath)) {
      y = firebaseGetData.intData();
      Serial.println(y);
      y = y + 1 ;
    }
   // String tpath = "Smart Trasportation/"+tag+"/time";

    if (Firebase.getInt(firebaseGetData, bpath)) {
      balance = firebaseGetData.intData();
      Serial.println(balance);
      if(balance < 200){
        Serial.println("Low Balance");
      }else if( y % 2 == 0 ){
        balance = balance - 20 ;
      }
    }
    
    Firebase.setInt(firebaseData,"/Smart Trasportation/"+tag+"/count",y);
    Firebase.setInt(firebaseData,"/Smart Trasportation/"+tag+"/balance",balance);
   
   
    tag = "";
    y = 0 ;
    balance = 0 ;
    rfid.PICC_HaltA();
    rfid.PCD_StopCrypto1();
  }
}




