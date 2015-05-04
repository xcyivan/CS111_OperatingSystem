// UCLA CS 111 Lab 1 main program

#include <errno.h>
// #include <error.h>
#include <getopt.h>
#include <stdio.h>

#include "command.h"
#include "alloc.h"

static char const *program_name;
static char const *script_name;

dependency_graph_t init_dependency_graph()
{
  dependency_graph_t dependency_graph = (dependency_graph_t)checked_malloc(sizeof(struct dependency_graph));
  dependency_graph->no_dependencies = init_queue();
  dependency_graph->dependencies = init_queue();
  return dependency_graph;
}

queue_t init_queue()
{
  queue_t queue = (queue_t)checked_malloc(sizeof(struct queue));
  queue->node = NULL;
  queue->next = NULL;
  return queue;
}

graph_node_t init_graph_node(command_t command)
{
  graph_node_t graph_node = (graph_node_t)checked_malloc(sizeof(struct graph_node));
  graph_node->command = command;
  graph_node->before = init_queue();
  graph_node->pid = -1;
  graph_node->m_readList = init_arr();
  graph_node->m_writeList = init_arr();
  return graph_node;
}

void add_queue(queue_t queue, graph_node_t node)
{
  queue_t new = init_queue();
  new->node = node;
  queue_t cur = queue;
  while (cur->next != NULL)
  {
    cur = cur->next;
  }
  cur->next = new;
}

arr_t init_arr(){
  arr_t newArr = (arr_t) checked_malloc(sizeof(struct arr));
  newArr->itemNum=0;
  return newArr;
}

processCommand(command_t cmd, graph_node_t gNode){
  if(cmd->type==SIMPLE_COMMAND){
    if(cmd->input!=NULL){
      gNode->m_readList->item[itemNum]=checked_malloc(strlen(cmd->input)+1);
      memset(gNode->m_readList->item[itemNum], 0, sizeof(strlen(cmd->input)+1);
      strcpy(gNode->m_readList->item[itemNum], cmd->input);
      gNode->m_readList->itemNum++;
    }
    if(cmd->output!=NULL){
      gNode->m_writeList->item[itemNum]=checked_malloc(strlen(cmd->output)+1);
      memset(gNode->m_writeList->item[itemNum], 0, sizeof(strlen(cmd->output)+1);
      strcpy(gNode->m_writeList->item[itemNum], cmd->output);
      gNode->m_writeList->itemNum++;
    }
    int i=1;
    for(i=1; cmd->u.word[i]!=0; i++){
      if(cmd->u.word[i][0]!='-'){
        gNode->m_readList->item[itemNum]=checked_malloc(strlen(cmd->u.word[i])+1);
        memset(gNode->m_readList->item[itemNum], 0, strlen(cmd->u.word[i])+1);
        strcpy(gNode->m_readList->item[itemNum], cmd->u.word[i]);
        gNode->m_readList->itemNum++;
      }
    }
  }

  else if(cmd->type==SUBSHELL_COMMAND){
    if(cmd->input!=NULL){
      gNode->m_readList->item[itemNum]=checked_malloc(strlen(cmd->input)+1);
      memset(gNode->m_readList->item[itemNum], 0, sizeof(strlen(cmd->input)+1);
      strcpy(gNode->m_readList->item[itemNum], cmd->input);
      gNode->m_readList->itemNum++;
    }
    if(cmd->output!=NULL){
      gNode->m_writeList->item[itemNum]=checked_malloc(strlen(cmd->output)+1);
      memset(gNode->m_writeList->item[itemNum], 0, sizeof(strlen(cmd->output)+1);
      strcpy(gNode->m_writeList->item[itemNum], cmd->output);
      gNode->m_writeList->itemNum++;
    }
  }

  else{
    processCommand(cmd->u.command[0],gNode);
    processCommand(cmd->u.command[1],gNode);
  }
}

bool isDependent(graph_node_t n1, graph_node_t n2){
  //n1 is the leading node, n2 is the following node
  int i=0;
  for(i=0; i<n2->m_readList->itemNum; i++){
    //RAW
    int j=0;
    for(j=0; j<n1->m_writeList->itemNum; j++){
      if(!strcmp(n2->m_readList->item[i], n1->m_writeList->item[j]))
        return true;
    }
  }
  for(i=0; i<n2->m_writeList->itemNum; i++){
    //WAR
    int j=0;
    for(j=0; j<n1->m_readList->itemNum; j++){
      if(!strcmp(n2->m_readList->item[i], n1->m_readList->itemNum[j]))
        return true;
    }
    //WAW
    int k=0;
    for(k=0; k<n1->m_writeList->itemNum; k++){
      if(!strcmp(n2->m_writeList->item[1], n1->m_writeList->item[j]))
        return true;
    }
  }
}

void checkDependency(graph_node_t* gnArr, int gnCount){
  int i=0;
  for(i=0; i<gnCount-1; i++){
    if(isDependent(gnArr[i],gnArr[gnCount-1]))
      add_queue(gnArr[gnCount-1]->before, gnArr[i]);
  }
}

dependency_graph_t create_graph(command_stream_t command_stream)
{

  dependency_graph_t graph = (dependency_graph_t)checked_malloc(sizeof(struct dependency_graph));
  command_t command_tree;
  graph_node_t gnArr[1024];
  int gnCount=0;
  while ((command_tree = read_command_stream (command_stream))){
    graph_node_t gNode=init_graph_node(command_tree);
    listNode_t lNode=init_listNode(gNode);
    gnArr[gnCount++]=gNode;
    processCommand(command_tree, gNode);
    checkDependency(gnArr);
    if(gNode->before->next==NULL)
      add_queue(graph->no_dependencies,gNode);
    else
      add_queue(graph->dependencies,gNode);
  }
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
