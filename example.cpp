#include <avr/io.h>
#include <util/delay.h>

// in arduino, blink led once per second
int main()
{
	bool state=false;
	
	//set port as OUTPUT
	DDRB |= _BV(DDB5);;
	
	//switch state every second
	while(1)
	{
		if(state)
			PORTB |= _BV(PORTB5);
		else
			PORTB &= ~_BV(PORTB5);
		state=!state;
		_delay_ms(1000);
	}
}
