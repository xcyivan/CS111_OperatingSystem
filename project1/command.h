// UCLA CS 111 Lab 1 command interface

#include <stdbool.h>
#include <unistd.h>

typedef struct command *command_t;
typedef struct command_stream *command_stream_t;

typedef struct graph_node *graph_node_t;
typedef struct queue *queue_t;
typedef struct dependency_graph *dependency_graph_t;

struct graph_node
{
	command_t command;
	queue_t before;
	pid_t pid;
};

struct queue
{
	graph_node_t node;
	graph_node_t next;
};

struct dependency_graph{
	queue_t no_dependencies;
	queue_t dependencies; 
};


/* Create a command stream from GETBYTE and ARG.  A reader of
   the command stream will invoke GETBYTE (ARG) to get the next byte.
   GETBYTE will return the next input byte, or a negative number
   (setting errno) on failure.  */
command_stream_t make_command_stream (int (*getbyte) (void *), void *arg);

/* Read a command from STREAM; return it, or NULL on EOF.  If there is
   an error, report the error and exit instead of returning.  */
command_t read_command_stream (command_stream_t stream);

/* Print a command to stdout, for debugging.  */
void print_command (command_t);

/* Execute a command.  Use "time travel" if the flag is set.  */
void execute_command (command_t, bool);

/* Return the exit status of a command, which must have previously
   been executed.  Wait for the command, if it is not already finished.  */
int command_status (command_t);

void add_queue(queue_t queue);

void init_queue(queue_t queue);

void init_graph_node(graph_node_t graph_node, command_t command);

void init_dependency_graph(dependency_graph_t dependency_graph);

dependency_graph_t create_graph(command_stream_t command_stream);

void execute_graph(dependency_graph_t dependency_graph);

void execute_no_dependencies(queue_t queue);

void execute_dependencies(queue_t queue);





// void add_queue(queue_t queue)
// {
// ;
// }
