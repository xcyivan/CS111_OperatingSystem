// UCLA CS 111 Lab 1 main program

#include <errno.h>
// #include <error.h>
#include <getopt.h>
#include <stdio.h>

#include "command.h"
#include "alloc.h"

static char const *program_name;
static char const *script_name;

void init_dependency_graph(dependency_graph_t dependency_graph)
{
  dependency_graph->no_dependencies = (queue_t)checked_malloc(sizeof(struct queue));
  dependency_graph->dependencies = (queue_t)checked_malloc(sizeof(struct queue));
}

void init_queue(queue_t queue)
{
  queue->node = (graph_node_t)checked_malloc(sizeof(struct graph_node));
  queue->next = (graph_node_t)checked_malloc(sizeof(struct graph_node));
}

void init_graph_node(graph_node_t graph_node, command_t command)
{
  graph_node->command = command;
  graph_node->before = (queue_t)checked_malloc(sizeof(struct queue));
  graph_node->pid = -1;
}

void add_queue(queue_t queue)
{
  //Pending to implement
  ;
}

dependency_graph_t create_graph(command_stream_t command_stream)
{
  //Pending to implement
  dependency_graph_t graph = (dependency_graph_t)checked_malloc(sizeof(struct dependency_graph));
  return graph;
}

void execute_graph(dependency_graph_t graph)
{
  execute_no_dependencies(graph->no_dependencies);
  execute_dependencies(graph->dependencies);
}

void execute_no_dependencies(queue_t queue)
{
  //Pending to implement
  ;
}

void execute_dependencies(queue_t queue)
{
  //Pending to implement
  ;
}



static void
usage (void)
{
  error (1, 0, "usage: %s [-pt] SCRIPT-FILE", program_name);
}

static int
get_next_byte (void *stream)
{
  return getc (stream);
}


int
main (int argc, char **argv)
{
  int command_number = 1;
  bool print_tree = false;
  bool time_travel = false;
  program_name = argv[0];

  for (;;)
    switch (getopt (argc, argv, "pt"))
      {
      case 'p': print_tree = true; break;
      case 't': time_travel = true; break;
      default: usage (); break;
      case -1: goto options_exhausted;
      }
 options_exhausted:;

  // There must be exactly one file argument.
  if (optind != argc - 1)
    usage ();

  script_name = argv[optind];
  FILE *script_stream = fopen (script_name, "r");
  if (! script_stream)
    error (1, errno, "%s: cannot open", script_name);
  command_stream_t command_stream =
    make_command_stream (get_next_byte, script_stream);

  command_t last_command = NULL;
  command_t command;
  if (time_travel)
  {
    dependency_graph_t graph = create_graph(command_stream);
    // dependency_graph_t graph ;
    // int status = 0;
    // status = execute_graph(graph);
    execute_graph(graph);
  }
  else
  {
    while ((command = read_command_stream (command_stream)))
    {
      if (print_tree)
    	{
    	  printf ("# %d\n", command_number++);
    	  print_command (command);
    	}
      else
    	{
        // bool flag = false;
    	  last_command = command;
    	  execute_command (command, time_travel);
    	}
    }
  }

  return print_tree || !last_command ? 0 : command_status (last_command);
}
