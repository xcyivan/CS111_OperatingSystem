// UCLA CS 111 Lab 1 command execution

#include "command.h"
#include "command-internals.h"

#include <error.h>
#include <stdio.h>

#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdlib.h>


int
command_status (command_t c)
{
  return c->status;
}


// Not yet include the case starting with "exec"
int do_execute(command_t c);
int redirect(command_t c);
int exe_simple_command(command_t c);
int exe_sequence_command(command_t c);
int exe_and_command(command_t c);
int exe_or_command(command_t c);
int exe_pipe_command(command_t c);
int exe_subshell_command(command c);

void
execute_command (command_t c, bool time_travel){
	if(time_travel){
		fprintf(stderr, "Time Travel Mode is yet to be implemented, please try later!\n");
		exit(1);
	}

	switch(c->type){
		case SIMPLE_COMMAND:
			exe_simple_command(c);
			break;
		case SEQUENCE_COMMAND:
			exe_sequence_command(c);
			break;
		case AND_COMMAND:
			exe_and_command(c);
			break;
		case OR_COMMAND:
			exe_or_command(c);
			break;
		case PIPE_COMMAND:
			exe_pipe_command(c);
			break;
		case SUBSHELL_COMMAND:
			do_execute(c->u.subshell_command);
			break;
		default:
			fprintf(stderr,"Unknown command!\n");
	}
}

int redirect(command_t c){
	if(c->input!=NULL){
		int fd=open(c->input,0_RDONLY);
		if(fd<0) return 1;//can't find a filedescriptor
		if(duo2(fd,0)<0) return 1;//can't dup stdin to fd
	}
	if(c->output!=NULL){
		int fd=open(c->output,O_CREAT|O_TRUNC|0_WRONLY,0644);
		if(fd<0) return 1;//can't find a filedescriptor
		if(dup2(fd,1)<0) return 1;//can't dup stdout to fd
	}
	return 0;
}

int exe_simple_command(command_t c){
	pid_t p=fork();
	if(p==0){//child process
		if(redirect(c)!=0){
			fprintf(stderr,"Cannot redirect the simple cammand\n");
			return 1;
		}
		if(execvp(c->u.word[0],c->u.word)!=0){//if successful, child process would end here
			fprintf(stderr,"Cannot execute simple command!\n");
			return 1;
		}

	}
	return 0;
}

int exe_sequence_command(command_t c){
	pid_t p=fork();
	if(p==0){//child process to exe the first command
		execute_command(c->u.command[0]);
	}
	else{//parent process to exe to second command
		execute_command(c->u.command[1]);
	}
	return 0;
}

int exe_and_command(command_t c){
	pid_t p=fork();
	if(p==0){//child process to exe first command
		execute_command(c->u.command[0]);
	}
	else{//parent process wait child status to exe second command
		int status;
		waitpid(p,&status,0);
		int exitstatus=WEXITSTATUS(status);
		if(exitstatus==0){
			execute_command(c->u.command[1]);
		}
	}
	return 0;
}


int exe_or_command(command_t c){
	pid_t p=fork();
	if(p==0){//child process to exe first command
		execute_command(c->u.command[0]);
	}
	else{//parent process wait child status to exe second command
		int status;
		waitpid(p,&status,0);
		int exitstatus=WEXITSTATUS(status);
		if(exitstatus!=0){
			execute_command(c->u.command[1]);
		}
	}
	return 0;
}

int exe_subshell_command(command_t c){
	if(redirect(c)!=0){
		fprintf(stderr,"Cannot redirect the subshell cammand\n");
		return 1;
	}
	execute_command(c->u.subshell_command);
	return 0;
}

int exe_pipe_command(command_t c){
	int fd[2];
	pipe(fd);
	command_t left = cmd->u.command[0];
	command_t right = cmd->u.command[1];

	pid_t firstpid=fork();
	if(firstpid==0){//in the first child process, exe the right command
		close(fd[1]);
		dup2(fd[0],0);
		execute_command(right);
	}
	else{
		pid_t secondpid=fork();
		if(secondpid==0){//in the second child process, exe the left command
			close(fd[0]);
			dup2(fd[1],1);
			execute_command(left);
		}
		else{//in the parent process
			close(fd[0]);
			close(fd[1]);
			int status;
			int returnedpid=waitpid(-1,&status);
			if(returnedpid==secondpid){
				waitpid(firstpid,&status,0);
			}
			if(returnedpid==firstpid){
				waitpid(secondpid,&status,0);
			}
		}
	}
	return 0;
}
