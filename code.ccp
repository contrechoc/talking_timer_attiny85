/* 2015 contrechoc: copyrights? do whatever you want with this code and enjoy!

attiny85
2 LED, red green
1 wackle rumble motor
1 butterfly/led thingy
3V coin cell

idea: after 5 minutes of talking with someone, you should free yourself for another person.
this other person touches, red LED is on for 5 minutes, after that
green LED on

meanwhile a butterfly (small gadget) is activate once in a while

the electronics will be fitted into a knitted loop, which can be around the neck
two ends on the shoulders will carry the green and red led
the butterfy thingy will be on the bracelet hanging down

added interrupt to reduce (some) power consumption
https://kartikmohta.com/tech/avr/tutorial/interrupts/walkingled.c.html
but this doesn't work: we already use a timer, and the adc
solution:
for LED's long shining, make a alternance:
		PORTB |= _BV(PB1);
		delay(1);
		PORTB &= ~_BV(PB1);
		delay(18);

*/

 
long timer2; // butterfly timer
long b_interval = 1000;
//long timer1; // 5 minutes talking time timer !! attiny85 cannot have 2 timers!!
int tCounter = 0;
int t_interval = 5*60; //interval in units of 1000 milliseconds = 5 minutes
int w_interval = 5*60;

char state = 0;

void setup()
{

//	pinMode(PB0, OUTPUT);//green LED
//	pinMode(PB1, OUTPUT);//red LED
//	pinMode(PB2, OUTPUT);//rumble motor
//	pinMode(PB4, OUTPUT);//butterfly

	DDRB |= _BV(PB0);
	DDRB |= _BV(PB1);
	DDRB |= _BV(PB2);
	DDRB |= _BV(PB4);
	//PB4 will be analog input for the touch sensor
	timer2 = millis() + b_interval;

//starting test
	//digitalWrite(PB0, HIGH);
	PORTB |= _BV(PB0);
	delay(50);
	//digitalWrite(PB0, LOW);
	PORTB &= ~_BV(PB0);
	delay(150);
	//digitalWrite(PB1, HIGH);
	PORTB |= _BV(PB1);
	delay(50);
	//digitalWrite(PB1, LOW);
	PORTB &= ~_BV(PB1);
	delay(150);
	//digitalWrite(PB2, HIGH);
	PORTB |= _BV(PB2);
	delay(50);
	//digitalWrite(PB2, LOW);
	PORTB &= ~_BV(PB2);
	delay(150);
	//digitalWrite(PB4, HIGH);
	PORTB |= _BV(PB4);
	delay(50);
	//digitalWrite(PB4, LOW);
	PORTB &= ~_BV(PB4);
	delay(150);

//starting state: free
	//digitalWrite(PB0, HIGH);
	PORTB |= _BV(PB0);
	//digitalWrite(PB1, LOW);
	PORTB &= ~_BV(PB1);
	state = 0; //free
//  state = 1; //talking
//  state = 2: //overtime talking

}



void rumble()
{
	//digitalWrite(PB2, HIGH);
	PORTB |= _BV(PB2);
	delay(500);
	//digitalWrite(PB2, LOW);
	PORTB &= ~_BV(PB2);
	delay(10);
}

void loop()
{

	if ( timer2 < millis() ) //blink butterfly a bit
	{

		tCounter++;//used for the talking
		//digitalWrite(PB4, HIGH);
		PORTB |= _BV(PB4);
		delay(50);
		//digitalWrite(PB4, LOW);
		PORTB &= ~_BV(PB4);
		timer2 = millis() + b_interval;

		if ( state == 2) //
		{
			//too long free
			rumble();//annoy wearer
		}
	}


	if ( tCounter > w_interval )
	{
		tCounter = 0;
		w_interval = 2;
		state = 0;
		rumble();
		//digitalWrite(PB0, HIGH);//five minutes talking over: warn to change person
		//digitalWrite(PB1, LOW);
		PORTB |= _BV(PB0);
		PORTB &= ~_BV(PB1);
	}

	if ( state == 1 )
	{
		PORTB |= _BV(PB1);
		delay(1);
		PORTB &= ~_BV(PB1);
		delay(18);
	}

	if ( state == 0)
	{
		
		PORTB |= _BV(PB0);
		delay(1);
		PORTB &= ~_BV(PB0);
		delay(18);
		
		
		int a3 = analogRead(PB3);
		if ( a3 > 500 )//next person talking to: set 5 minutes timer
		{
			state = 1;//occupied talking
			w_interval = t_interval;
			//digitalWrite(PB0, LOW);
			//digitalWrite(PB1, HIGH);
			PORTB |= _BV(PB1);
			PORTB &= ~_BV(PB0);
			tCounter = 0;
			delay(500);
		}
	}


}
