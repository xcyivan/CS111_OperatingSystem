// UCLA CS 111 Lab 1 command execution

#include "command.h"
#include "command-internals.h"

// #include <error.h>
#include <stdio.h>

#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>


int
command_status (command_t c)
{
  return c->status;
}

int redirect(command_t c, bool time_travel);
int exe_simple_command(command_t c, bool time_travel);
int exe_sequence_command(command_t c, bool time_travel);
int exe_and_command(command_t c, bool time_travel);
int exe_or_command(command_t c, bool time_travel);
int exe_pipe_command(command_t c,bool time_travel);
int exe_subshell_command(command_t c, bool time_travel);
int exe_exec_command(command_t c, bool time_travel);

void
show_error (char *desc, char *desc2)
{
	if(desc2 == NULL)
		fprintf (stderr, "error %s\n",  desc);
	else
		fprintf (stderr, "error %s \"%s\"\n", desc, desc2);
	_exit (EXIT_FAILURE);
}

void 
execute_command (command_t c, bool time_travel)
{
	// if(time_travel){
	// 	fprintf(stderr, "Time Travel Mode is yet to be implemented, please try later!\n");
	// 	exit(1);
	// }

	switch(c->type){
		case SIMPLE_COMMAND:
			exe_simple_command(c, time_travel);
			break;
		case SEQUENCE_COMMAND:
			exe_sequence_command(c, time_travel);
			break;
		case AND_COMMAND:
			exe_and_command(c, time_travel);
			break;
		case OR_COMMAND:
			exe_or_command(c, time_travel);
			break;
		case PIPE_COMMAND:
			exe_pipe_command(c, time_travel);
			break;
		case SUBSHELL_COMMAND:
			exe_subshell_command(c, time_travel);
			break;
		default:
			fprintf(stderr,"Unknown command!\n");
	}	
}

int redirect(command_t c, bool time_travel){
	if(c->input!=NULL){
		int fd=open(c->input,O_RDONLY);
		if(fd<0)
		{//can't find a filedescriptor
			error(1,0,"Unable to open %s as input", c->input);
		}
		if(dup2(fd,0)<0)
		{//can't dup stdin to fd
			error(1,0,"Unable to dup2 %s as stdin", c->input);
		}
		close(fd);
	}
	if(c->output!=NULL){
		int fd=open(c->output,O_CREAT|O_TRUNC|O_WRONLY,0644);
		if(fd<0)
		{//can't find a filedescriptor
			error(1, 0, "Unable to open %s as output", c->output);
		}
		if(dup2(fd,1)<0)
		{//can't dup stdout to fd
			error(1,0,"Unable to dup2 %s to stdout", c->output);
		}
		close(fd);
	}
	return 0;
}

int exe_simple_command(command_t c, bool time_travel)
{
	int fd_in_backup = dup(STDIN_FILENO);
	int fd_out_backup = dup(STDOUT_FILENO);
	redirect(c, time_travel);
	
	exe_exec_command(c, time_travel);
	pid_t p = fork();
	if (p == 0)
	{
		execvp(c->u.word[0], c->u.word);
		//show_error(c->line, "invalid", c->u.word[0]);
		show_error("invalid", c->u.word[0]);
	}
	else
	{
		int status;
		waitpid(p, &status, 0);
		int exit_status = WEXITSTATUS(status);
		c->status = exit_status;
	}
	dup2(fd_in_backup, STDIN_FILENO);
	dup2(fd_out_backup, STDOUT_FILENO);
	close(fd_in_backup);
	close(fd_out_backup);
	return 0;
}

int exe_and_command(command_t c, bool time_travel)
{
	execute_command(c->u.command[0], time_travel);
	c->status = c->u.command[0]->status;

	if (c->u.command[0]->status == 0)
	{
		execute_command(c->u.command[1], time_travel);
		c->status = c->u.command[1]->status;
	}
	return 0;
}

int exe_or_command(command_t c, bool time_travel)
{
	execute_command(c->u.command[0], time_travel);
	c->status = c->u.command[0]->status;

	if (c->u.command[0]->status != 0)
	{
		execute_command(c->u.command[1], time_travel);
		c->status = c->u.command[1]->status;
	}
	
	return 0;
}

int exe_sequence_command(command_t c, bool time_travel)
{
	execute_command(c->u.command[0], time_travel);
	c->status = c->u.command[0]->status;

	execute_command(c->u.command[1], time_travel);
	c->status = c->u.command[1]->status;
	return 0;
}

int exe_pipe_command(command_t c,bool time_travel)
{	
	int fd[2];
	pipe(fd);
	command_t left = c->u.command[0];
	command_t right = c->u.command[1];

	pid_t firstpid=fork();
	if(firstpid==0){
		close(fd[1]);
		dup2(fd[0],0);
		execute_command(right, time_travel);
		_exit(right->status);
	}
	else{
		pid_t secondpid=fork();
		if(secondpid==0){
			close(fd[0]);
			dup2(fd[1],1);
			execute_command(left,time_travel);
			_exit(left->status);
		}
		else{
			close(fd[0]);
			close(fd[1]);
			int status;
			int returnedpid=waitpid(-1,&status,0);
			if(returnedpid==secondpid){
				waitpid(firstpid,&status,0);
				int exit_status = WEXITSTATUS(status);
				c->status = exit_status;
			}
			if(returnedpid==firstpid){
				waitpid(secondpid, &status, 0);
				int exit_status = WEXITSTATUS(status);
				c->status = exit_status;
			}
		}
	}
	//printf("%d\n",(int)getpid());
	return 0;
}

int exe_subshell_command(command_t c, bool time_travel)
{
	int fd_in_backup = dup(STDIN_FILENO);
	int fd_out_backup = dup(STDOUT_FILENO);
	redirect(c, time_travel);
	execute_command(c->u.subshell_command, time_travel);
	c->status = c->u.subshell_command->status;
	dup2(fd_in_backup, STDIN_FILENO);
	dup2(fd_out_backup, STDOUT_FILENO);
	close(fd_in_backup);
	close(fd_out_backup);

	return 0;
}

int exe_exec_command(command_t c, bool time_travel)
{
	if (c->type == SIMPLE_COMMAND && !strcmp(c->u.word[0], "exec"))
	{
		execvp(c->u.word[1], &c->u.word[1]);
		//show_error(c->line, "invalid command", c->u.word[1]);
		show_error("invalid command", c->u.word[1]);
		// _exit(127);
	}
		
	return 0;
	
}
