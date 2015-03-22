# talking_timer_attiny85
also to be found at https://codebender.cc/sketch:96162

2015 contrechoc: copyrights? do whatever you want with this code and enjoy!

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
