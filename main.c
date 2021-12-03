#include "stm8l15x.h"

int main() {
	GPIOA->DDR = 0xFF;
	return 0;
}
