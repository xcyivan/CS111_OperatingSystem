// UCLA CS 111 Lab 1 command interface

#include <stdbool.h>
#include <unistd.h>

typedef struct command *command_t;
typedef struct command_stream *command_stream_t;

typedef struct graph_node *graph_node_t;
typedef struct queue *queue_t;
typedef struct dependency_graph *dependency_graph_t;

typedef struct listNode* listNode_t;
typedef struct arr* arr_t;

struct queue
{
	graph_node_t node;
	queue_t next;
};

struct graph_node
{
	command_t command;
	queue_t before;
	pid_t pid;
};

struct dependency_graph{
	queue_t no_dependencies;
	queue_t dependencies; 
};

struct arr{
	char* item[1024];
	int itemNum;
};

struct listNode{
	graph_node_t m_node;
	arr_t m_readList;
	arr_t m_writeList;
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

void add_queue(queue_t queue, graph_node_t node);


//----------------------for 1C---------------------------
queue_t init_queue();

graph_node_t init_graph_node(command_t command);

dependency_graph_t init_dependency_graph();

dependency_graph_t create_graph(command_stream_t command_stream);

void execute_graph(dependency_graph_t dependency_graph);

void execute_no_dependencies(queue_t queue);

void execute_dependencies(queue_t queue);

arr_t init_arr();

listNode_t init_listNode(graph_node_t node);



// void add_queue(queue_t queue)
// {
// ;
// }
