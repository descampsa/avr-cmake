#include <Arduino.h>

// in arduino, blink led once per second
int main()
{
	init();
	const int led=13;
	
	//set port as OUTPUT
	pinMode(led, OUTPUT);
	
	//switch state every second
	while(1)
	{
		digitalWrite(led, HIGH);
		delay(1000);
		digitalWrite(led, LOW);
		delay(1000);
	}
}
