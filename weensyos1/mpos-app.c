#include "mpos-app.h"
#include "lib.h"

/*****************************************************************************
 * mpos-app
 *
 *   This application simply starts a child process and then waits for it
 *   to exit.  Both processes print messages to the screen.
 *
 *****************************************************************************/

void run_child(void);

void
start(void)
{
	volatile int checker = 0; /* This variable checks that you correctly
				     gave the child process a new stack. */
	pid_t p;
	int status;

	app_printf("About to start a new process...\n");

	p = sys_fork();
	if (p == 0)
		run_child();
	else if (p > 0) {
		app_printf("Main process %d!\n", sys_getpid());
		do {
			status = sys_wait(p);
			//app_printf("W");
		} while (status == WAIT_TRYAGAIN);
		app_printf("Child %d exited with status %d!\n", p, status);

		// Check whether the child process corrupted our stack.
		// (This check doesn't find all errors, but it helps.)
		if (checker != 0) {
			app_printf("Error: stack collision!\n");
			sys_exit(1);
		} else
			sys_exit(0);

	} else {
		app_printf("Error!\n");
		sys_exit(1);
	}
}

// // ========================================
// // *Code for Exercise 5
// // ========================================
// void start(void) {
//         int x = 0;  /* note that local variable x lives on the stack */
//         int* volatile ptr = &x;
//         pid_t p = sys_fork();
//         if (p == 0){//in child process, we need to modify x both in 2 processes
//         		x++; //this changes x in child process
//         		(*ptr)++;
//             }
//         else if (p > 0)
//                 sys_wait(p); // assume blocking implementation
//         app_printf("%d", x);
//         sys_exit(0);
// }
// //=========end of Exercise 5===============

void
run_child(void)
{
	int i;
	volatile int checker = 1; /* This variable checks that you correctly
				     gave this process a new stack.
				     If the parent's 'checker' changed value
				     after the child ran, there's a problem! */

	app_printf("Child process %d!\n", sys_getpid());

	// Yield a couple times to help people test Exercise 3
	for (i = 0; i < 20; i++)
		sys_yield();

	sys_exit(1000);
}
