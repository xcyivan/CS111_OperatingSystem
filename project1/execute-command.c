// UCLA CS 111 Lab 1 command execution

#include "command.h"
#include "command-internals.h"

#include <error.h>

#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdlib.h>

int
command_status (command_t c)
{
  return c->status;
}


int do_execute(command_t c);
int redirect(command_t c);
int exe_simple_command(command_t c);
int exe_sequence_command(command_t c);
int exe_and_command(command_t c);
int exe_or_command(command_t c);
int exe_pipe_command(command_t c);

void
execute_command (command_t c, bool time_travel){
	if(time_travel){
		fprintf(stderr, "Time Travel Mode is yet to be implemented, please try later!\n");
		exit(1);
	}
	pid_t p=fork();
	if(p<0){
		fprintf(stderr, "Fail to fork a process!\n");
		exit(1);
	}
	else if(p==0){//in child process, do the cmd_exe stuffs
		do_execute(c);
		_exit(0);
	}
	else{// in the parent process
		waitpid(p,NULL,0);
	}
}

int
do_execute(command_t c){
	if(redirect(c)!=0) return 1;
	switch(c->type){
		case SIMPLE_COMMAND:{
			exe_simple_command(c);
			break;
		}
		case SEQUENCE_COMMAND:{
			exe_sequence_command(c);
			break;
		}
		case AND_COMMAND:{
			exe_and_command(c);
			break;
		}
		case OR_COMMAND:{
			exe_or_command(c);
			break;
		}
		case PIPE_COMMAND:{
			exe_pipe_command(c);
			break;
		}
		case SUBSHELL_COMMAND:{
			do_execute(c->u.subshell_command);
			break;
		}
		default:
			return 0;
	}
	return 1;//supposedlly should not run to here
}

